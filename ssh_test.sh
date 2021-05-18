#!/bin/bash

if [ "$1" = "" ] ; then
    MIN=1
else
    MIN=$1
fi
if [ "$2" = "" ] ; then
    MAX=100000
else
    MAX=$2
fi

make

echo rsync
rsync --delete --archive ~/c_broker/ nakagawa@hsc1.swlab.cs.okayama-u.ac.jp:c_broker

if [ $MIN -le 100000 ] && [ $MAX -ge 100000 ]; then
    ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 1 ssh_tcp_win100000_ 100000 10000
    ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 2 ssh_tcp_win100000_ 100000 10001
    ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 4 ssh_tcp_win100000_ 100000 10002
    
fi

if [ $MIN -le 50000 ] && [ $MAX -ge 50000 ]; then
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 1 ssh_tcp_win50000_ 50000 10004
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 2 ssh_tcp_win50000_ 50000 10005
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 4 ssh_tcp_win50000_ 50000 10006
fi

if [ $MIN -le 20000 ] && [ $MAX -ge 20000 ]; then
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 1 ssh_tcp_win20000_ 20000 10007
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 2 ssh_tcp_win20000_ 20000 10008
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 4 ssh_tcp_win20000_ 20000 10009
fi

if [ $MIN -le 10000 ] && [ $MAX -ge 10000 ]; then
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 1 ssh_tcp_win10000_ 10000 10010
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 2 ssh_tcp_win10000_ 10000 10011
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 4 ssh_tcp_win10000_ 10000 10012
fi

if [ $MIN -le 5000 ] && [ $MAX -ge 5000 ]; then
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 1 ssh_tcp_win5000_ 5000 10013
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 2 ssh_tcp_win5000_ 5000 10014
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 4 ssh_tcp_win5000_ 5000 10015
fi

if [ $MIN -le 2000 ] && [ $MAX -ge 2000 ]; then
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 1 ssh_tcp_win2000_ 2000 10016
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 2 ssh_tcp_win2000_ 2000 10017
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 4 ssh_tcp_win2000_ 2000 10018
fi

if [ $MIN -le 1000 ] && [ $MAX -ge 1000 ]; then
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 1 ssh_tcp_win1000_ 1000 10019
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 2 ssh_tcp_win1000_ 1000 10020
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 4 ssh_tcp_win1000_ 1000 10021
fi

if [ $MIN -le 500 ] && [ $MAX -ge 500 ]; then
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 1 ssh_tcp_win500_ 500 10022
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 2 ssh_tcp_win500_ 500 10023
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 4 ssh_tcp_win500_ 500 10024
fi

if [ $MIN -le 200 ] && [ $MAX -ge 200 ]; then
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 1 ssh_tcp_win200_ 200 10025
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 2 ssh_tcp_win200_ 200 10026
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 4 ssh_tcp_win200_ 200 10027
fi

if [ $MIN -le 100 ] && [ $MAX -ge 100 ]; then
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 1 ssh_tcp_win100_ 100 10028
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 2 ssh_tcp_win100_ 100 10029
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 4 ssh_tcp_win100_ 100 10030
fi

if [ $MIN -le 50 ] && [ $MAX -ge 50 ]; then
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 1 ssh_tcp_win50_ 50 10031
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 2 ssh_tcp_win50_ 50 10032
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 4 ssh_tcp_win50_ 50 10033
fi

if [ $MIN -le 20 ] && [ $MAX -ge 20 ]; then
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 1 ssh_tcp_win20_ 20 10034
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 2 ssh_tcp_win20_ 20 10035
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 4 ssh_tcp_win20_ 20 10036
fi

if [ $MIN -le 10 ] && [ $MAX -ge 10 ]; then
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 1 ssh_tcp_win10_ 10 10037
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 2 ssh_tcp_win10_ 10 10038
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 4 ssh_tcp_win10_ 10 10039
fi

if [ $MIN -le 5  ] && [ $MAX -ge 5  ]; then
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 1 ssh_tcp_win5_ 5 10040
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 2 ssh_tcp_win5_ 5 10041
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 4 ssh_tcp_win5_ 5 10042
fi

if [ $MIN -le 2  ] && [ $MAX -ge 2  ]; then
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 1 ssh_tcp_win2_ 2 10043
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 2 ssh_tcp_win2_ 2 10044
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 4 ssh_tcp_win2_ 2 10045
fi

if [ $MIN -le 1  ] && [ $MAX -ge 1  ]; then
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 1 ssh_tcp_win1_ 1 10046
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 2 ssh_tcp_win1_ 1 10047
ssh nakagawa@hsc1.swlab.cs.okayama-u.ac.jp c_broker/tcp_test.sh 100000 4 ssh_tcp_win1_ 1 10048
fi

echo rsync
rsync --delete --archive nakagawa@hsc1.swlab.cs.okayama-u.ac.jp:c_broker/log/ log/

