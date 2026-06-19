#!/usr/bin/env bash
# macOS 14+/26 redacts the SSID from CLI tools (needs Location Services), so we
# report connected/off based on whether the Wi-Fi interface has an IP.
source "$HOME/.config/sketchybar/colors.sh"

# Find the Wi-Fi device (usually en0), fall back to en0.
WIFI_DEV=$(networksetup -listallhardwareports 2>/dev/null \
  | awk '/Wi-Fi|AirPort/{getline; print $2; exit}')
WIFI_DEV=${WIFI_DEV:-en0}

IP=$(ipconfig getifaddr "$WIFI_DEV" 2>/dev/null)

if [ -n "$IP" ]; then
  sketchybar --set "$NAME" icon="" icon.color=$BLUE label="Wi-Fi"
else
  sketchybar --set "$NAME" icon="" icon.color=$SUBTLE label="off"
fi
