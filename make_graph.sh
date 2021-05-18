#!/bin/bash
while read filename
do
echo make $filename.csv
    gnuplot -persist <<-EOFMarker
    set datafile separator ","
    set xlabel 'Count'
    set ylabel 'Sec'
    set terminal png
    set output "log/graph/$filename-snd.png"
    plot "log/$filename.csv" every ::1 using 1:2
    set terminal png
    set output "log/graph/$filename-svr.png"
    plot "log/$filename.csv" every ::1 using 1:3
    set terminal png
    set output "log/graph/$filename-rcv.png"
    plot "log/$filename.csv" every ::1 using 1:4
    set terminal png
    set output "log/graph/$filename-all.png"
    plot "log/$filename.csv" every ::1 using 1:5
EOFMarker
    
done < log/latest_file.log

:>| log/latest_file.log
