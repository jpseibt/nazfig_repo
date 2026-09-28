#!/usr/bin/env bash

# Drawing tablet devices:
#   "UGTABLET 6 inch PenTablet Pen stylus"
#   "UGTABLET 6 inch PenTablet Pen eraser"
#   "Wacom Intuos BT M Pad pad"
#   "Wacom Intuos BT M Pen stylus"

XSETWACOM_DEV_CMD=$(xsetwacom --list devices)

NAZ_DRAWING_TABLET_PENS=(
  "UGTABLET 6 inch PenTablet Pen stylus"
  "Wacom Intuos BT M Pen stylus"
)

for DEV in "${NAZ_DRAWING_TABLET_PENS[@]}"; do
  if [[ "$XSETWACOM_DEV_CMD" == *"$DEV"* ]]; then
    echo "$DEV"
    xsetwacom --set "$DEV" Button 2 "button 2"
    xsetwacom --set "$DEV" Button 3 "key +super +shift o -shift -super"
    notify-send "$DEV" "buttons assigned"
  fi
done
