#!/usr/bin/env bash

CORES=$(sysctl -n hw.ncpu 2>/dev/null || echo 8)
sketchybar --set "$NAME" icon="" \
  label="$(ps -A -o %cpu | awk -v c="$CORES" '{s+=$1} END {printf "%.0f%%", s/c}')"
