#!/usr/bin/env bash
# macOS 14+/26 redacts the SSID from CLI tools, so we report connected/off
# based on whether the Wi-Fi interface has an IP.

WIFI_DEV=$(networksetup -listallhardwareports 2>/dev/null \
  | awk '/Wi-Fi|AirPort/{getline; print $2; exit}')
WIFI_DEV=${WIFI_DEV:-en0}

IP=$(ipconfig getifaddr "$WIFI_DEV" 2>/dev/null)

if [ -n "$IP" ]; then
  sketchybar --set "$NAME" icon="" label="Wi-Fi"
else
  sketchybar --set "$NAME" icon="" label="off"
fi
