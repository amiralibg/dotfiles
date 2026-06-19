#!/usr/bin/env bash

sketchybar --set clock label="$(date '+%H:%M:%S')"

# Popup content (cheap to refresh on the 1s tick).
sketchybar --set clock.date label="$(date '+%A, %d %B %Y')"
UPTIME=$(uptime | sed -E 's/^.*up //; s/,[[:space:]]*[0-9]+ user.*$//' | xargs)
sketchybar --set clock.uptime label="up ${UPTIME}"
