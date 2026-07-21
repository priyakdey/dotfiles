#!/bin/bash

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // empty')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // empty')
remaining_pct=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
five_used=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_used=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

dirname=$(basename "$cwd")

output="${model}"
output="${output} | 📁${dirname}"

# Git branch (only if cwd is inside a git repo)
if git --no-optional-locks -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git --no-optional-locks -C "$cwd" branch --show-current 2>/dev/null)
  if [ -z "$branch" ]; then
    branch=$(git --no-optional-locks -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  fi
  if [ -n "$branch" ]; then
    output="${output} | ${branch}"
  fi
fi

# Context remaining
if [ -n "$remaining_pct" ]; then
  ctx_left=$(awk -v p="$remaining_pct" 'BEGIN{printf "%.0f", p}')
  output="${output} | Context Left: ${ctx_left}%"
fi

# Claude usage/quota remaining (prefer 5-hour session limit, fall back to 7-day)
if [ -n "$five_used" ]; then
  usage_left=$(awk -v p="$five_used" 'BEGIN{printf "%.0f", 100 - p}')
  output="${output} | Usage Left: ${usage_left}%"
elif [ -n "$seven_used" ]; then
  usage_left=$(awk -v p="$seven_used" 'BEGIN{printf "%.0f", 100 - p}')
  output="${output} | Usage Left: ${usage_left}%"
fi

printf '%s' "$output"
