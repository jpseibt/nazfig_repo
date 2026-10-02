#!/usr/bin/env bash

#==================================================
# Config
#==================================================
NAZ_DRAWING_TABLET_DEVS=(
  "UGTABLET 6 inch PenTablet Pen stylus"
  "UGTABLET 6 inch PenTablet Pen eraser"
  "Wacom Intuos BT M Pen stylus"
  "Wacom Intuos BT M Pad pad"
)
NAZ_DRAWING_TABLET_PENS=(
  "UGTABLET 6 inch PenTablet Pen stylus"
  "Wacom Intuos BT M Pen stylus"
)

NAZ_PEN_BUTTONS=0
NAZ_PEN_BTN_2="button 3"
NAZ_PEN_BTN_3="key +super +shift o -shift -super"
NAZ_MAP_TO_OUTPUT=0
NAZ_TARGET_OUTPUT="eDP"


#==================================================
# Argument parsing
#==================================================
# NOTE: ${var:offset:length}
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --pen-buttons)
      NAZ_PEN_BUTTONS=1
      shift
      ;;
    --map-to-output)
      NAZ_MAP_TO_OUTPUT=1
      if [[ -n "$2" && "${2:0:1}" != "-" ]]; then
        NAZ_TARGET_OUTPUT="$2"
        shift
      fi
      shift
      ;;
    *)
      echo "_WARNING_: skipping invalid argument $1"
      shift
      ;;
  esac
done


#==================================================
# Run
#==================================================
XSETWACOM_DEVS=$(xsetwacom --list devices)

if [ "$NAZ_MAP_TO_OUTPUT" -eq 1 ]; then
  for DEV in "${NAZ_DRAWING_TABLET_DEVS[@]}"; do
    if [[ "$XSETWACOM_DEVS" == *"$DEV"* ]]; then
      xsetwacom --set "$DEV" MapToOutput $NAZ_TARGET_OUTPUT
      notify-send "DTablet Setup" "$DEV mapped to $NAZ_TARGET_OUTPUT."
    fi
  done
fi

if [ "$NAZ_PEN_BUTTONS" -eq 1 ]; then
  for DEV in "${NAZ_DRAWING_TABLET_PENS[@]}"; do
    if [[ "$XSETWACOM_DEVS" == *"$DEV"* ]]; then
      xsetwacom --set "$DEV" Button 2 "$NAZ_PEN_BTN_2"
      xsetwacom --set "$DEV" Button 3 "$NAZ_PEN_BTN_3"
      notify-send "DTablet Setup" "$DEV buttons set.\nButton 2: $NAZ_PEN_BTN_2\nButton 3: $NAZ_PEN_BTN_3"
    fi
  done
fi
