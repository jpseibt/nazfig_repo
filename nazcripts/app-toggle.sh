#!/bin/bash

APP=$1

# Pattern matches the window WM_CLASS and i3 instance
case "$APP" in
    ""|-h|--help)
        echo "Usage: app-toggle.sh <application_nickname>"
        echo "nicknames: chromium, gemini, monkeytype, pinta, spotify, vial, whatsapp"
        exit 0
        ;;
    chromium)
        PATTERN="chromium"
        LAUNCH_CMD="chromium"
        ;;
    monkeytype)
        PATTERN="monkeytype.com"
        LAUNCH_CMD="chromium --app=https://monkeytype.com"
        ;;
    gemini)
        PATTERN="gemini.google.com__app"
        LAUNCH_CMD="chromium --app=https://gemini.google.com/app"
        ;;
    whatsapp)
        PATTERN="web.whatsapp.com"
        LAUNCH_CMD="chromium --app=https://web.whatsapp.com"
        ;;
    vial)
        PATTERN="Vial"
        LAUNCH_CMD="/home/naz/.local/bin/vial"
        ;;
    pinta)
        PATTERN="pinta"
        LAUNCH_CMD="pinta"
        ;;
    spotify)
        PATTERN="spotify"
        LAUNCH_CMD="spotify"
        ;;
    *)
        echo "Error: Invalid application nickname: $APP"
        exit 1
esac

# Toggle logic
if wmctrl -lx | grep -Eq "^[[:alnum:]]+[[:blank:]]+[[:digit:]]+[[:blank:]]+$PATTERN"; then
    i3-msg "[instance=\"$PATTERN\"] focus"
else
    $LAUNCH_CMD &
fi
