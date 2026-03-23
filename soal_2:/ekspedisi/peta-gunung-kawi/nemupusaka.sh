#!/bin/bash

awk -F',' '
NR==1 {x1=$3; y1=$4}
NR==3 {x2=$3; y2=$4}
END {
    print "Koordinat pusat:"
    print (x1+x2)/2, (y1+y2)/2
}' titik-penting.txt > posisipusaka.txt
