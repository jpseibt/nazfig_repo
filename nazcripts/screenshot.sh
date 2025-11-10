#!/bin/bash

FILE_NAME=$(date +"%Y%m%d_%H-%M-%S")_screenshot.png
SCREENSHOTS_PATH=~/Pictures/screenshots

# Create the screenshots directory if it does not exist
[ -d "$SCREENSHOTS_PATH" ] || mkdir "$SCREENSHOTS_PATH"

# Notification expiration time in milliseconds
EXTIME=10000

# The first arg could be for region select
scrot -q 100 $1 -F $SCREENSHOTS_PATH/$FILE_NAME &&
{
    ACTION=$(notify-send --expire-time=$EXTIME --action=clip "Screenshot saved to $SCREENSHOTS_PATH/$FILE_NAME" "(press ACTION to copy to clipboard)")
    # Copy image to clipboard if notify action returned a non empty string
    [ -z $ACTION ] || xclip -selection clipboard -target image/png -in "$SCREENSHOTS_PATH/$FILE_NAME"
}
