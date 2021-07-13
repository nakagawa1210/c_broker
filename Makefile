.PHONY: all clean

all: server send_client recv_client
#recv

#mybroker

send_client: send_client.c
	gcc send_client.c -o send_client
recv_client: recv_client.c
	gcc recv_client.c -o recv_client
server: server.c
	gcc server.c -pthread -o server

clean:
	rm -f send_client recv_client server
