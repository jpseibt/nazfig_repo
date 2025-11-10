#!/bin/bash

CURRENT_LAYOUT=$(xkblayout-state print %s)

case $CURRENT_LAYOUT in
    "us")
        setxkbmap -layout br
	;;
    "br")
        setxkbmap -layout us
	;;
    *)
        # Default to 'us'
        setxkbmap -layout us
esac
