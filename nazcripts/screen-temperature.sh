#!/bin/bash

HOUR=$(date +%H)

case $HOUR in
    18)
        sct 6000
        ;;
    19)
        sct 5500
        ;;
    20)
        sct 5000
        ;;
    21)
        sct 4500
        ;;
    22|23|00|01|02|03)
        sct 3500
        ;;
    4)
        sct 4500
        ;;
    5)
        sct 5500
        ;;
    6)
        sct 6000
        ;;
    *)
        sct
        ;;
esac
