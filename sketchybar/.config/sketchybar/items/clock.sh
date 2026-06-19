#!/usr/bin/env bash

COLOR="$MAGENTA"

sketchybar --add item clock right \
  --set clock update_freq=1 \
        icon="" \
        icon.padding_left=10 \
        icon.color="$COLOR" \
        label.color="$COLOR" \
        label.padding_right=5 \
        label.width=78 \
        align=center \
        background.height=26 \
        background.corner_radius="$CORNER_RADIUS" \
        background.padding_right=2 \
        background.border_width="$BORDER_WIDTH" \
        background.border_color="$COLOR" \
        background.color="$BAR_COLOR" \
        background.drawing=on \
        popup.align=right \
        click_script="sketchybar --set clock popup.drawing=toggle" \
        script="$PLUGIN_DIR/clock.sh"

# Popup rows (click the clock to toggle): full date + uptime.
sketchybar --add item clock.date popup.clock \
  --set clock.date icon="󰃭" icon.color="$MAGENTA" \
        label.color="$WHITE" label.align=left \
        icon.padding_left=10 label.padding_right=12 width=210 \
        background.drawing=off

sketchybar --add item clock.uptime popup.clock \
  --set clock.uptime icon="" icon.color="$CYAN" \
        label.color="$WHITE" label.align=left \
        icon.padding_left=10 label.padding_right=12 width=210 \
        background.drawing=off
