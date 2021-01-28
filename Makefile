all: svr send recv
#recv

#mybroker

send: send_client.c
	gcc send_client.c -o send_client -std=gnu99
recv: recv_client.c
	gcc recv_client.c -o recv_client -std=gnu99
svr: server.c
	gcc server.c -pthread -o server -std=gnu99
