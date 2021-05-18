#!/bin/bash
ruby cal_timestamp.rb $1

FILENAME=${1%.*} 
PUTNAME=${1#*/}


gnuplot -persist <<-EOFMarker
set datafile separator ","
plot "$FILENAME.timelog" using 1:3
replot "$FILENAME.timelog" using 2:4
set terminal png
set output "log/graph/$PUTNAME-timelog.png"
replot
EOFMarker

