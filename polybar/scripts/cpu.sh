#!/bin/sh
# CPU usage + die temperature in one segment.
# Usage is computed from two /proc/stat samples; temperature is Ryzen Tctl
# via k10temp, located by hwmon name because hwmon numbering is not stable
# across boots.

RED="%{F#A54242}"
RESET="%{F-}"
WARN=85

read -r _ u1 n1 s1 i1 w1 q1 sq1 st1 _ < /proc/stat
sleep 0.5
read -r _ u2 n2 s2 i2 w2 q2 sq2 st2 _ < /proc/stat

busy=$(( (u2 + n2 + s2 + q2 + sq2 + st2) - (u1 + n1 + s1 + q1 + sq1 + st1) ))
total=$(( busy + (i2 + w2) - (i1 + w1) ))
[ "$total" -gt 0 ] && usage=$(( 100 * busy / total )) || usage="?"

t=""
for h in /sys/class/hwmon/hwmon*; do
    if [ "$(cat "$h/name" 2>/dev/null)" = "k10temp" ] && [ -r "$h/temp1_input" ]; then
        t=$(( $(cat "$h/temp1_input") / 1000 ))
        break
    fi
done

if [ -z "$t" ]; then
    temp="?°C"
elif [ "$t" -ge "$WARN" ]; then
    temp="${RED}${t}°C${RESET}"
else
    temp="${t}°C"
fi

echo "${usage}% ${temp}"
