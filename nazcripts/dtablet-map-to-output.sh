#!/usr/bin/env bash

#==================================================
# Config
#==================================================
NAZ_TARGET_OUTPUT="eDP"
NAZ_DRAWING_TABLET_DEVS=(
  "UGTABLET 6 inch PenTablet Pen stylus"
  "UGTABLET 6 inch PenTablet Pen eraser"
  "Wacom Intuos BT M Pen stylus"
  "Wacom Intuos BT M Pad pad"
)

#==================================================
# Argument parsing
#==================================================
if [[ "$#" -gt 0 ]]; then
    NAZ_TARGET_OUTPUT=$1
fi

#==================================================
# Run
#==================================================
# Loop through the connected devices and map them to the target output
XSETWACOM_DEV_CMD=$(xsetwacom --list devices)

for DEV in "${NAZ_DRAWING_TABLET_DEVS[@]}"; do
  if [[ "$XSETWACOM_DEV_CMD" == *"$DEV"* ]]; then
    echo "$DEV"
    xsetwacom --set "$DEV" MapToOutput $NAZ_TARGET_OUTPUT
    notify-send "$DEV" "mapped to $NAZ_TARGET_OUTPUT"
  fi
done
