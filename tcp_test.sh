#!/bin/bash
if [ -x  $HOME/.rbenv/bin/rbenv ]; then
    # rbenv
    PATH=$HOME/.rbenv/bin:$PATH
    eval "$(rbenv init -)"
    RUBY_DISPATCHER="rbenv"
fi

cd "$(dirname "$0")"

TIME=$(date "+%Y%m%d_%H%M")

echo start $3$1_$2_$TIME.log $(date "+%M:%S")

./server $5 > log/$3$1_$2_$TIME.lenlog &
SRVID=$!
sleep 1
./recv_client $5 $1 > log/$3$1_$2_$TIME.log &
RECVID=$!
sleep 1
./send_client $5 $1 $2 $4 &

while(true)
do
    if [ $(ps -p $RECVID | wc -l) = "1" ]; then
    break
    fi
    sleep 1
done

echo end $3$1_$2_$TIME.log $(date "+%M:%S")

kill $SRVID

ruby cal.rb log/$3$1_$2_$TIME.log $2

echo $3$1_$2_$TIME.log >> log/latest_file.log
echo $3$1_$2_$TIME.mulog >> log/latest_file.mulog
echo $3$1_$2_$TIME.lenlog >> log/latest_file.latelog
