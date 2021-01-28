#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <stdlib.h>
#include <time.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/stat.h>
#include <netinet/in.h>
#include <unistd.h>

#define SERVER_PORT 9872
#define MAX_EVENTS 3000
#define BACKLOG 10
#define MAX_COUNT 50000
#define MAX_BUF_SIZE 1024
#define MAX_FD_SIZE 1024
#define HEAD_MAX 1000
#define TALE 512

#define rdtsc_64(lower, upper) asm __volatile ("rdtsc" : "=a"(lower), "=d" (upper));

char array[100000][5000];

int datanum = 0;
int recvnum = 0;

void ackset(char *buf)
{
  int num = datanum - recvnum;
  memcpy(&buf[0], &num ,sizeof(num));
  int size = (int)array[num-1][0];
  memcpy(&buf[4], &size,sizeof(size));  
}

static void die(const char* msg)
{
  perror(msg);
  exit(EXIT_FAILURE);
}

static int listener;

static int setup_socket()
{
  int sock;
  struct sockaddr_in sin;

  if ((sock = socket(PF_INET, SOCK_STREAM, 0)) < 0) {
    die("socket");
  }

  int on =1;
  int ret;
  ret = setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on));

  memset(&sin, 0, sizeof sin);
  sin.sin_family = AF_INET;
  sin.sin_addr.s_addr = htonl(INADDR_ANY);
  sin.sin_port = htons(SERVER_PORT);

  if (bind(sock, (struct sockaddr *) &sin, sizeof sin) < 0) {
    close(sock);
    die("bind");
  }

  if (listen(sock, BACKLOG) < 0) {
    close(sock);
    die("listen");
  }

  return sock;
}

ssize_t writen(int fd,const void *vptr, size_t n)
{
  size_t nleft;
  ssize_t nwritten;
  const char *ptr;

  //現在の文字列の位置
  ptr = vptr;

  //残りの文字列の長さの初期化
  nleft = n;
  while (nleft > 0) {
    if ((nwritten = write(fd, ptr, nleft)) <= 0) {
      if (nwritten < 0 && errno == EINTR) {
	nwritten = 0;  // try again
      } else {
	return -1;
      }
    }
    nleft -= nwritten;
    ptr += nwritten;
  }
  return n;
}

ssize_t readn(int fd, void *buf, size_t count)
{
  int *ptr = buf;
  size_t nleft = count;
  ssize_t nread;

  while (nleft > 0) {
    if ((nread = read(fd, ptr, nleft)) < 0) {
      if (errno == EINTR)
        continue;
      else
        return -1;
    }
    if (nread == 0) {
      return count - nleft;
    }
    nleft -= nread;
    ptr += nread;
  }
  return count;
}
int send_msg(int length, int winsize,int fd)
{
  char buf[length + 20];
  unsigned int tsc_l, tsc_u;
  unsigned long int log_tsc;

  for(int i = 0; i< winsize ;i++){
    readn(fd, &buf, length + 20);
    rdtsc_64(tsc_l, tsc_u);
    log_tsc = (unsigned long int)tsc_u<<32 | tsc_l;

    memcpy(&array[datanum][0], buf,sizeof(buf));
    printf("buf%d\n",sizeof(buf));
    memcpy(&array[datanum][sizeof(buf)] ,&log_tsc ,sizeof(log_tsc));
    printf("tsc%d\n",sizeof(log_tsc));
    datanum++;	     
  }
  
  char ack[4] = "ack";
  writen(fd, ack, 4);
  printf("%s\n",ack);
  return 0;
}

int recv_msg(int fd, char *buf)
{
  unsigned int tsc_l, tsc_u;
  unsigned long int log_tsc;

  //int winsize = (int)buf[0];
  int winsize;
  memcpy(&winsize,&buf[0],4);
  printf("win%d\n",winsize);
  int size = (int)buf[4] * 1024;

  for(int i = 0; i< winsize ;i++){
    rdtsc_64(tsc_l, tsc_u);
    log_tsc = (unsigned long int)tsc_u<<32 | tsc_l;
    memcpy(&array[recvnum][size + 28],&log_tsc,sizeof(unsigned long int));
    writen(fd, &array[recvnum], size + 36);
    recvnum++;
  }
  char ack[4];
  readn(fd, ack, 4);
  printf("ack\n");
  return 0;
}

int analyze(char *data, int fd){
  int length = (int)data[0];
  int command = (int)data[4];
  int winsize = 0;

  memcpy(&winsize,&data[8],4);

  int res = 0;
  int num = 0;
  char ack[4] = "ack";
  char rack[8];

  switch (command){
  case 1 :
    writen(fd, ack, 4);
    printf("send\n");
    res = send_msg(length * 1024,winsize,fd);
    break;
  case 2 :
    ackset(rack);
    writen(fd, rack, 8);
    printf("recv\n");
    res = recv_msg(fd, rack);
    break;
  case 9 :
    res = 1;
    break;
  default:
    res = 0;
    break;
  }
  return res;
}

int main()
{
  printf("start\n");
  
  listener = setup_socket();
  struct sockaddr_in client_addr;
  socklen_t client_addr_len = sizeof client_addr;
  int fd;
  char buf[16];
  int res; 
  while (fd = accept(listener, (struct sockaddr *) &client_addr, &client_addr_len))
  {
    while (1){
    readn(fd, buf, 16);
    res = analyze(buf, fd);
    if(res)break;
    }
    printf("datanum%d\n",datanum);
  }
  
  return 0;
}
