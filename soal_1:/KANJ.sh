#!/bin/bash

data=$1
pilihan=$2

if [ "$pilihan" = "a" ]; then
	awk -F, 'NR>1 {jumlah++} END {print "Total penumpang ada", jumlah}' $data
elif [ "$pilihan" = "b" ]; then
	awk -F, 'NR>1 {print $3}' $data | sort | uniq | wc -l
elif [ "$pilihan" = "c" ]; then
	awk -F, 'NR==2 {max=$2; nama=$1} NR>1 {
						if ($2 > max) {
							max=$2
							nama=$1
						}
					}
					END {
						print "Penumpang tertua:", nama, "-", max, "tahun"
					}' $data
elif [ "$pilihan" = "d" ]; then
	awk -F, 'NR>1 {sum+=$2; n++} END {print "Rata-rata umur sekitar", int(sum/n)}' $data
elif [ "$pilihan" = "e" ]; then
	awk -F, 'NR>1 && $3=="Business" {n++} END {print "Business class ada", n}' $data
else
	echo "input salah"
fi
