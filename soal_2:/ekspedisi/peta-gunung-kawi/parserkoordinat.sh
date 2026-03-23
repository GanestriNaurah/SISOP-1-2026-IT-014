#!/bin/bash

grep '"coordinates"' gsxtrack.json | \
sed 's/[][]//g; s/"coordinates"://g' | \
awk -F',' '{
    gsub(/ /,"",$0)
    printf "node_%03d,Point%d,%s,%s\n", NR, NR, $2, $1
}' > titik-penting.txt
