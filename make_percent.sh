#!/bin/bash
while read filename
do
echo $filename
ruby cal_percent.rb $filename >> logtest_per

done < log/latest_file.log

while read filename
do
    echo $filename

cat $filename | tail -n 1

done < logtest_per

