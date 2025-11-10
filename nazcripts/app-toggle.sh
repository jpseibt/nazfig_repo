#!/bin/bash

if [ -z $1 ]; then
    echo "Usage: app-toggle.sh <application_nickname>"
    echo "nicknames: gemini, pinta, vial, whatsapp"
    exit 1
fi

# Since the instance names aren't consistent, the cases are separated
APP=$1

case "$APP" in
    gemini)
        WMCTRL_PATTERN="Google Gemini"
        I3_PATTERN="gemini.google.com__app"
        LAUNCH_CMD="chromium --app=https://gemini.google.com/app"
        ;;
    whatsapp)
        WMCTRL_PATTERN="web.whatsapp.com"
        I3_PATTERN="web.whatsapp.com"
        LAUNCH_CMD="chromium --app=https://web.whatsapp.com"
        ;;
    vial)
        WMCTRL_PATTERN="Vial"
        I3_PATTERN="Vial"
        LAUNCH_CMD="/home/naz/.local/bin/vial"
        ;;
    pinta)
        WMCTRL_PATTERN="Pinta"
        I3_PATTERN="pinta"
        LAUNCH_CMD="pinta"
        ;;
    *)
        echo "Error: Invalid application nickname: $APP"
        exit 1
esac

# Toggle logic
if wmctrl -l | grep "$WMCTRL_PATTERN"; then
    i3-msg "[instance=\"$I3_PATTERN\"] focus"
else
    $LAUNCH_CMD &
fi
