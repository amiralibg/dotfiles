#!/usr/bin/env bash

source "$HOME/.config/sketchybar/variables.sh"
source "$HOME/.config/sketchybar/icon_map.sh"

sid="${NAME#space.}"

# ── Highlight the focused space (query yabai, don't rely on $SELECTED) ────────
focused=$(yabai -m query --spaces --space 2>/dev/null | jq -r '.index')
if [ "$sid" = "$focused" ]; then
  ICON_COLOR=$RED
else
  ICON_COLOR=$COMMENT
fi

# ── Build the app-icon strip for this space ──────────────────────────────────
icons=""
while read -r app; do
  [ -z "$app" ] && continue
  __icon_map "$app"
  icons+="${icon_result}"
done < <(yabai -m query --windows --space "$sid" 2>/dev/null | jq -r '.[].app')

if [ -n "$icons" ]; then
  sketchybar --animate tanh 5 --set "$NAME" \
    icon.color="$ICON_COLOR" label="$icons" label.drawing=on
else
  sketchybar --animate tanh 5 --set "$NAME" \
    icon.color="$ICON_COLOR" label.drawing=off
fi
