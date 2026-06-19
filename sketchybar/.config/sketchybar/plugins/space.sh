#!/usr/bin/env bash
# Highlights the pill for the currently-focused space.
source "$HOME/.config/sketchybar/colors.sh"

sid="${NAME#space.}"
focused=$(yabai -m query --spaces --space 2>/dev/null | jq -r '.index')

if [ "$sid" = "$focused" ]; then
  sketchybar --set "$NAME" \
    background.color=$MAUVE \
    icon.color=$BAR_COLOR
else
  sketchybar --set "$NAME" \
    background.color=$ITEM_BG \
    icon.color=$TEXT
fi
