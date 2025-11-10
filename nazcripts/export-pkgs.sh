#/bin/bash

DIR=${1:-.}  # If no $1, assign '.'
DIR=${DIR%/} # Strip the last '/' if it exists

# Create directory to store the lists 
mkdir -p $DIR/pkglist

# Get list of installed packages
pacman -Qqen > $DIR/pkglist/official.txt
pacman -Qqem > $DIR/pkglist/aur.txt 

echo "Number of packages:"
wc --lines $DIR/pkglist/official.txt
wc --lines $DIR/pkglist/aur.txt
