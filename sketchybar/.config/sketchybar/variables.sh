#!/usr/bin/env bash

# ── Color palette — Tokyonight Night ─────────────────────────────────────────
BLACK=0xff24283b
WHITE=0xffa9b1d6
MAGENTA=0xffbb9af7
BLUE=0xff7aa2f7
CYAN=0xff7dcfff
GREEN=0xff9ece6a
YELLOW=0xffe0af68
ORANGE=0xffff9e64
RED=0xfff7768e
BAR_COLOR=0xff1a1b26
COMMENT=0xff565f89
TRANSPARENT=0x00000000

# General bar colors
ICON_COLOR=$WHITE
LABEL_COLOR=$WHITE

# ── Fonts (verified installed) ───────────────────────────────────────────────
# Text/icons: MesloLGS Nerd Font  ·  App glyphs: sketchybar-app-font
FONT="MesloLGS Nerd Font"
APP_FONT="sketchybar-app-font"

# ── Dirs ─────────────────────────────────────────────────────────────────────
ITEM_DIR="$HOME/.config/sketchybar/items"
PLUGIN_DIR="$HOME/.config/sketchybar/plugins"

# ── Geometry ─────────────────────────────────────────────────────────────────
PADDINGS=3
CORNER_RADIUS=8
BORDER_WIDTH=2
SHADOW=on

POPUP_BORDER_WIDTH=2
POPUP_CORNER_RADIUS=11
POPUP_BACKGROUND_COLOR=$BLACK
POPUP_BORDER_COLOR=$COMMENT
