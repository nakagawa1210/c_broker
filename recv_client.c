#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/shm.h>
#include <sys/stat.h>
#include <netinet/in.h>
#include <netdb.h>
#include <stdlib.h>
#include <netinet/tcp.h>
#define rdtsc_64(lower, upper) asm __volatile ("rdtsc" : "=a"(lower), "=d" (upper));

#define CLOCK_HZ 2600000000.0
#define PORT_NO 9999
#define MAX_BUF_SIZE 5000
#define MAX_COUNT 200000

unsigned long int gettsc()
{
  unsigned int tsc_l, tsc_u; //uint32_t

  rdtsc_64(tsc_l, tsc_u);
  return (unsigned long int)tsc_u<<32 | tsc_l;
}

/* Read "n" bytes from a descriptor. */
ssize_t readn(int fd, void *buf, size_t count)
{
  char *ptr = buf;
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

void recv_msg(char *host, int port_no, int count)
{
  char buf[MAX_BUF_SIZE];
  uint64_t recv_time[MAX_COUNT][4];
  int datanum = 0;
  int size = 0;
  int fd = socket(AF_INET, SOCK_STREAM, 0);
  unsigned long int tsc; //uint64_t

  uint64_t end = 0;

  if (fd < 0) {
    perror("socket");
    return;
  }

  struct hostent *hp;
  if  ((hp = gethostbyname(host)) == NULL) {
    fprintf(stderr, "gethost error %s\n", host);
    close(fd);
    return;
  }

  struct sockaddr_in addr;
  memset(&addr, 0, sizeof(addr));
  addr.sin_family = AF_INET;
  addr.sin_port = htons(port_no);
  memcpy(&addr.sin_addr, hp->h_addr, hp->h_length);

  int len = 1;
  int command = 2;
  int winsize = 3;
  int dest = 4;
  int endnum = 9;
  char iddata[16];
  char enddata[16];

  memcpy(&iddata[0],&len,sizeof(len));
  memcpy(&iddata[4],&command,sizeof(command));
  memcpy(&iddata[8],&winsize,sizeof(winsize));
  memcpy(&iddata[12],&dest,sizeof(dest));

  memcpy(&enddata[0],&len,sizeof(len));
  memcpy(&enddata[4],&endnum,sizeof(endnum));
  memcpy(&enddata[8],&winsize,sizeof(winsize));
  memcpy(&enddata[12],&dest,sizeof(dest));
  
  while (1) {     
    if (connect(fd, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
	  sleep(1);
      continue;
    } else {
      break;
    }
  }

  int on=1;
  int ret;
	ret = setsockopt(fd, IPPROTO_TCP, TCP_NODELAY, &on, sizeof(on));

  unsigned long int log_tsc;
  char setdata[8];
  int flag = 0;
  char ack[4];
  char endack[4];
  
  memcpy(&ack[0],&flag,sizeof(flag));
  flag = 1;
  memcpy(&endack[0],&flag,sizeof(flag));
  
  writen(fd, iddata, sizeof(iddata));
  readn(fd, setdata, 8);
  memcpy(&size,&setdata[0],4);
  memcpy(&winsize,&setdata[4],4);
  size = size * 1024;

  while(1) {
    for (int i = 0;i < winsize; i++){
      readn(fd, buf, size + 36);
      log_tsc = gettsc();
      memcpy(&recv_time[datanum][0], &buf[size +12], sizeof(unsigned long int));
      memcpy(&recv_time[datanum][1], &buf[size +20], sizeof(unsigned long int));
      memcpy(&recv_time[datanum][2], &buf[size +28], sizeof(unsigned long int));
      memcpy(&recv_time[datanum][3], &log_tsc, sizeof(unsigned long int));
      datanum++;
    }
    if(datanum == count)break;
    writen(fd, ack, sizeof(ack));
  }
  writen(fd, endack, sizeof(endack));
  //writen(fd, enddata, sizeof(enddata));
  
//	rdtsc_64(tsc_l, tsc_u);
//	log_tsc[3][count] = (unsigned long int)tsc_u<<32 | tsc_l;
//	memcpy(&log_tsc[0][count], buf, sizeof(unsigned long int));
//	memcpy(&log_tsc[1][count], buf + sizeof(unsigned long int), sizeof(unsigned long int));
//	memcpy(&log_tsc[2][count], buf + 2 * sizeof(unsigned long int), sizeof(unsigned long int));
//	count++;
//  }
//
//  unsigned long int start;
//
//  start = log_tsc[0][0];
//
  printf("num,send,svr_in,svr_out,recv\n");
  for (int i = 0; i < count; i++) {
    printf("%d,%lf,%lf,%lf,%lf\n",i,
	   (recv_time[i][0]) / CLOCK_HZ,
	   (recv_time[i][1]) / CLOCK_HZ,
	   (recv_time[i][2]) / CLOCK_HZ,
	   (recv_time[i][3]) / CLOCK_HZ);
      }
  
  if (close(fd) == -1) {
    printf("%d\n", errno);
  }
  
  return;
}

int main(int argc, char *argv[])
{
  if (argc < 2){
    printf("augument\n");
    return 0;
  }
  recv_msg("localhost", atoi(argv[1]),atoi(argv[2]) );
  
  return 0;
}
