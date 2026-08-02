#!/usr/bin/env bash

source "$HOME/.config/sketchybar/variables.sh"
source "$HOME/.config/sketchybar/icon_map.sh"

sid="${NAME#space.}"

# ── Highlight the focused workspace (ask AeroSpace) ──────────────────────────
focused=$(aerospace list-workspaces --focused 2>/dev/null)
if [ "$sid" = "$focused" ]; then
  ICON_COLOR=$RED
else
  ICON_COLOR=$COMMENT
fi

# ── Build the app-icon strip for this workspace ──────────────────────────────
icons=""
while read -r app; do
  [ -z "$app" ] && continue
  __icon_map "$app"
  icons+="${icon_result}"
done < <(aerospace list-windows --workspace "$sid" --format '%{app-name}' 2>/dev/null)

if [ -n "$icons" ]; then
  sketchybar --animate tanh 5 --set "$NAME" \
    icon.color="$ICON_COLOR" label="$icons" label.drawing=on
else
  sketchybar --animate tanh 5 --set "$NAME" \
    icon.color="$ICON_COLOR" label.drawing=off
fi
