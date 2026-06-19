#!/usr/bin/env bash

# One pill per macOS Desktop (yabai space). The pill's ICON is its keybind tag
# (1 I C B D G …); its LABEL shows the app icons of the windows on that space
# (rendered with sketchybar-app-font). Grouped in a bracket with a coloured
# border, just like the reference design.

# tag for a space label → the key you press for it (alt-<tag>)
space_tag() {
  case "$1" in
    main) echo "1" ;; term) echo "I" ;; code) echo "C" ;; web) echo "B" ;;
    chat) echo "D" ;; ai) echo "G" ;; design) echo "O" ;;
    two) echo "2" ;; three) echo "3" ;; five) echo "5" ;; six) echo "6" ;;
    seven) echo "7" ;; eight) echo "8" ;; nine) echo "9" ;;
    *) echo "$2" ;;
  esac
}

# Custom event fired by yabai signals whenever the windows on a space change.
sketchybar --add event space_windows

for sid in $(yabai -m query --spaces | jq -r '.[].index'); do
  lbl=$(yabai -m query --spaces --space "$sid" | jq -r '.label')
  tag=$(space_tag "$lbl" "$sid")

  sketchybar --add space space.$sid left \
    --set space.$sid \
          associated_space=$sid \
          icon="$tag" \
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
          click_script="yabai -m space --focus $sid" \
          script="$PLUGIN_DIR/space.sh" \
    --subscribe space.$sid space_change mouse.clicked space_windows
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
