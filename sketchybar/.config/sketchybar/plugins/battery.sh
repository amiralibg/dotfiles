#!/usr/bin/env bash
source "$HOME/.config/sketchybar/colors.sh"

PERCENT=$(pmset -g batt | grep -Eo '[0-9]+%' | head -1 | tr -d '%')
CHARGING=$(pmset -g batt | grep -i 'AC Power')
[ -z "$PERCENT" ] && exit 0

COLOR=$TEXT
case "$PERCENT" in
  100|9[0-9]) ICON="" ;;
  [6-8][0-9]) ICON="" ;;
  [3-5][0-9]) ICON="" ;;
  [1-2][0-9]) ICON="" ; COLOR=$YELLOW ;;
  *)          ICON="" ; COLOR=$RED ;;
esac

if [ -n "$CHARGING" ]; then
  ICON=""
  COLOR=$GREEN
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENT}%"
