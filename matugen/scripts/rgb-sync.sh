#!/usr/bin/env bash
set -euo pipefail

colors="$HOME/.local/state/quickshell/generated/colors.json"
[ -f "$colors" ] || exit 0

src=$(jq -r '.source_color' "$colors" | tr -d '#')
[ -n "$src" ] && [ "$src" != "null" ] || exit 0

hex=$(python3 -c '
import colorsys, sys
h = sys.argv[1]
r, g, b = int(h[0:2], 16) / 255, int(h[2:4], 16) / 255, int(h[4:6], 16) / 255
hue, sat, val = colorsys.rgb_to_hsv(r, g, b)
sat = 0.4
val = 0.75
r, g, b = colorsys.hsv_to_rgb(hue, sat, val)
print("%02x%02x%02x" % (round(r * 255), round(g * 255), round(b * 255)))
' "$src")

command -v openrgb >/dev/null 2>&1 || exit 0
openrgb \
  -d "Apex" -m direct -c "$hex" \
  -d "M711" -m static -c "$hex" -b 100 \
  -d "TUF" -m static -c "$hex" \
  >/dev/null 2>&1 || true
