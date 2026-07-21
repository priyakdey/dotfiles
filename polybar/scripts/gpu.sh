#!/bin/sh
# Combined GPU usage + temperature: N = NVIDIA (nvidia-smi), A = AMD iGPU (sysfs).
# AMD sensors are located by name/vendor id because drm card and hwmon
# numbering are not stable across boots.

GOLD="%{F#F0C674}"
RED="%{F#A54242}"
RESET="%{F-}"
WARN=80

# temp: red when at/above WARN
fmt_temp() {
    [ -z "$1" ] && { printf '?°C'; return; }
    if [ "$1" -ge "$WARN" ]; then
        printf '%s%s°C%s' "$RED" "$1" "$RESET"
    else
        printf '%s°C' "$1"
    fi
}

nvidia=$(nvidia-smi --query-gpu=utilization.gpu,temperature.gpu --format=csv,noheader,nounits 2>/dev/null)
nu=$(echo "$nvidia" | cut -d, -f1 | tr -d ' ')
nt=$(echo "$nvidia" | cut -d, -f2 | tr -d ' ')

au=""
for c in /sys/class/drm/card*/device; do
    if [ "$(cat "$c/vendor" 2>/dev/null)" = "0x1002" ] && [ -r "$c/gpu_busy_percent" ]; then
        au=$(cat "$c/gpu_busy_percent")
        break
    fi
done

at=""
for h in /sys/class/hwmon/hwmon*; do
    if [ "$(cat "$h/name" 2>/dev/null)" = "amdgpu" ] && [ -r "$h/temp1_input" ]; then
        at=$(( $(cat "$h/temp1_input") / 1000 ))
        break
    fi
done

echo "${GOLD}N${RESET} ${nu:-?}% $(fmt_temp "$nt") ${GOLD}A${RESET} ${au:-?}% $(fmt_temp "$at")"
