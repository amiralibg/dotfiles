#!/usr/bin/env bash

# One pill per AeroSpace workspace. The pill's ICON is the workspace name, which
# is also its keybind (alt-<name>); its LABEL shows the app icons of the windows
# in that workspace (rendered with sketchybar-app-font). Grouped in a bracket
# with a coloured border.
#
# AeroSpace uses a single native macOS space, so we do NOT set associated_space
# (pills are always visible). Workspace names ARE the tags (1 I C B D G O …),
# so no name→tag lookup is needed.

# Fired from aerospace.toml `exec-on-workspace-change` (see config).
sketchybar --add event aerospace_workspace_change

for sid in $(aerospace list-workspaces --all); do
  sketchybar --add item space.$sid left \
    --set space.$sid \
          icon="$sid" \
          icon.font="$FONT:Bold:13.0" \
          icon.padding_left=0 \
          icon.padding_right=0 \
          label.font="$APP_FONT:Regular:15.0" \
          label.padding_left=8 \
          label.padding_right=0 \
          label.y_offset=0 \
          label.drawing=off \
          background.padding_left=8 \
          background.padding_right=12 \
          update_freq=5 \
          click_script="aerospace workspace $sid" \
          script="$PLUGIN_DIR/space.sh" \
    --subscribe space.$sid aerospace_workspace_change front_app_switched mouse.clicked
done

# Bracket the whole spaces block with a rounded, bordered frame.
sketchybar --add bracket spaces '/space\..*/' \
  --set spaces background.border_width="$BORDER_WIDTH" \
        background.border_color="$RED" \
        background.corner_radius="$CORNER_RADIUS" \
        background.color="$BAR_COLOR" \
        background.height=26 \
        background.drawing=on

# Small gap between the spaces block and the front-app pill.
sketchybar --add item spacer.2 left \
  --set spacer.2 background.drawing=off label.drawing=off icon.drawing=off width=8
