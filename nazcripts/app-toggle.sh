#!/bin/bash

APP=$1

# NOTE: `i3-msg -t get_tree` to search for a pattern
# Pattern matches the i3 criteria type and value
case "$APP" in
  ""|-h|--help)
    echo "Usage: app-toggle.sh <application_nickname>"
    printf "nicknames: \n\tbtop \n\tcalendar \n\tchromium \n\tgemini \n\tmilton \n\tmonkeytype \n\tneovide \n\tpinta \n\tqualculate \n\trnote \n\tspotify \n\tthunar \n\tvial \n\twhatsapp\n"
    exit 0
    ;;
  btop)
    CRITERIA_TYPE="window_role"
    CRITERIA_VALUE="btop"
    LAUNCH_CMD="$TERMINAL --role=btop --disable-server -T btop -x btop"
    ;;
  calendar)
    CRITERIA_TYPE="instance"
    CRITERIA_VALUE="calendar.google.com__calendar"
    LAUNCH_CMD="chromium --app=https://calendar.google.com/calendar"
    ;;
  chromium)
    CRITERIA_TYPE="instance"
    CRITERIA_VALUE="chromium"
    LAUNCH_CMD="chromium"
    ;;
  gemini)
    CRITERIA_TYPE="instance"
    CRITERIA_VALUE="gemini.google.com__app"
    LAUNCH_CMD="chromium --app=https://gemini.google.com/app"
    ;;
  milton)
    CRITERIA_TYPE="instance"
    CRITERIA_VALUE="Milton"
    LAUNCH_CMD="milton"
    ;;
  monkeytype)
    CRITERIA_TYPE="instance"
    CRITERIA_VALUE="monkeytype.com"
    LAUNCH_CMD="chromium --app=https://monkeytype.com"
    ;;
  neovide)
    CRITERIA_TYPE="instance"
    CRITERIA_VALUE="neovide"
    LAUNCH_CMD="neovide"
    ;;
  pinta)
    CRITERIA_TYPE="instance"
    CRITERIA_VALUE="pinta"
    LAUNCH_CMD="pinta"
    ;;
  qalculate)
    CRITERIA_TYPE="instance"
    CRITERIA_VALUE="qalculate-gtk"
    LAUNCH_CMD="qalculate-gtk"
    ;;
  rnote)
    CRITERIA_TYPE="instance"
    CRITERIA_VALUE="rnote"
    LAUNCH_CMD="rnote"
    ;;
  spotify)
    CRITERIA_TYPE="instance"
    CRITERIA_VALUE="spotify"
    LAUNCH_CMD="spotify"
    ;;
  thunar)
    CRITERIA_TYPE="instance"
    CRITERIA_VALUE="thunar"
    LAUNCH_CMD="thunar"
    ;;
  vial)
    CRITERIA_TYPE="instance"
    CRITERIA_VALUE="Vial"
    LAUNCH_CMD="/home/naz/.local/bin/vial"
    ;;
  whatsapp)
    CRITERIA_TYPE="instance"
    CRITERIA_VALUE="web.whatsapp.com"
    LAUNCH_CMD="chromium --app=https://web.whatsapp.com"
    ;;
  *)
    echo "Error: Invalid application nickname: $APP"
    exit 1
esac

# Toggle logic
if i3-msg "[$CRITERIA_TYPE=\"$CRITERIA_VALUE\"] focus" | grep -q '"success":false'; then
  $LAUNCH_CMD &
fi
