#!/bin/bash

FILES_LEN=$(find $1 -maxdepth 1 -type f | wc -l)

i=0
mkdir -p $1/renamed

for file in $1/*; do
    if [[ -f "$file" ]]; then
        # Get file extension
	extension="${file##*.}"
        cp $file $1/renamed/$i.$extension
	((++i))
    fi
done

echo finished
