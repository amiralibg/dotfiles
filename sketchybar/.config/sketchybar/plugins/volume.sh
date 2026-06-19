#!/usr/bin/env bash
source "$HOME/.config/sketchybar/colors.sh"

VOL="$INFO"
[ -z "$VOL" ] && VOL=$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)
[ -z "$VOL" ] && exit 0

case "$VOL" in
  0)                    ICON="" ;;
  [1-9]|[1-3][0-9])     ICON="" ;;
  [4-7][0-9])           ICON="" ;;
  *)                    ICON="" ;;
esac

sketchybar --set "$NAME" icon="$ICON" icon.color=$TEAL label="${VOL}%"
