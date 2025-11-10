#!/bin/bash

[ -z $1 ] && echo "No wallpapers directory specified." && exit 1

WALLPAPERS_DIR=$1
FILE_COUNT=$(find $WALLPAPERS_DIR -maxdepth 1 -type f | wc -l)

[ 0 -eq $FILE_COUNT ] && echo "Empty directory." && exit 1

# Get a number between 0 and the number of files in the directory
NUM=$(($RANDOM % $FILE_COUNT))

# Assign the image as the wallpaper
if [[ -f $WALLPAPERS_DIR/$NUM.png ]]; then
    feh --bg-fill $WALLPAPERS_DIR/$NUM.png
    echo "Wallpaper $NUM selected."
elif [[ -f $WALLPAPERS_DIR/$NUM.jpg ]]; then
    feh --bg-fill $WALLPAPERS_DIR/$NUM.jpg
    echo "Wallpaper $NUM selected."
else
    echo "Error: file $NUM.png or $NUM.jpg not found."; exit 1
fi
