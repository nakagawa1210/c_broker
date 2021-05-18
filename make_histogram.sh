#!/bin/bash
while read filename
do
ruby cal_latency.rb log/$filename
ruby cal_diff.rb log/$filename

echo make $filename.csv
    gnuplot -persist <<-EOFMarker
    set datafile separator ","
    set xlabel '(sec)'
    set terminal png
    set output "log/graph/$filename-sndlatency.png"
    plot "log/$filename.latency" using 1:2 with boxes notitle
    set terminal png
    set output "log/graph/$filename-svrlatency.png"
    plot "log/$filename.latency" using 1:3 with boxes notitle
    set terminal png
    set output "log/graph/$filename-rcvlatency.png"
    plot "log/$filename.latency" using 1:4 with boxes notitle
    set terminal png
    set output "log/graph/$filename-alllatency.png"
    plot "log/$filename.latency" using 1:5 with boxes notitle
EOFMarker
    
done < log/latest_file.latelog

:>| log/latest_file.latelog
