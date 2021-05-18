#!/bin/bash
while read filename
do
echo make $filename
    gnuplot -persist <<-EOFMarker
    set datafile separator ","
    set xlabel 'Count'
    set terminal png
    set output "log/graph/$filename.png"
    plot [][0:40000]"log/$filename" using 1:2 with lines
EOFMarker
    
done < log/latest_file.latelog
