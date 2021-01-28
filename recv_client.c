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
#define rdtsc_64(lower, upper) asm __volatile ("rdtsc" : "=a"(lower), "=d" (upper));

#define CLOCK_HZ 2600000000.0
#define PORT_NO 9872
#define MAX_BUF_SIZE 5000
#define MAX_COUNT 1000

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

void recv_msg(char *host, int count)
{
  printf("recv\n");
  char buf[MAX_BUF_SIZE];
  uint64_t recv_time[MAX_COUNT][4];
  int datanum = 0;
  int size = 0;
  int fd = socket(AF_INET, SOCK_STREAM, 0);

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
  addr.sin_port = htons(PORT_NO);
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
  printf("con\n");

  unsigned int tsc_l, tsc_u; //uint32_t
  unsigned long int tsc; //uint64_t
  unsigned long int log_tsc;
  char ack[4] = "ack";
  char setdata[8];
  
  while(1) {
    writen(fd, iddata, sizeof(iddata));
    readn(fd, setdata, 8);
    
    memcpy(&winsize,&setdata[0],4);
    //winsize = (int)setdata[0];
    size = (int)setdata[4];

    size = size * 1024;
    printf("win%d\n",winsize);
    printf("siz%d\n",size);
    
    for (int i = 0;i < winsize; i++){
      readn(fd, buf, size + 36);
      rdtsc_64(tsc_l, tsc_u);
      log_tsc = (unsigned long int)tsc_u<<32 | tsc_l;
      memcpy(&recv_time[datanum][0], &buf[size +12], sizeof(unsigned long int));
      memcpy(&recv_time[datanum][1], &buf[size +20], sizeof(unsigned long int));
      memcpy(&recv_time[datanum][2], &buf[size +28], sizeof(unsigned long int));
      memcpy(&recv_time[datanum][3], &log_tsc, sizeof(unsigned long int));
      datanum++;
      }
    writen(fd, ack, 4);
    printf("ack\n");
    if(datanum == count)break;
  }
  writen(fd, enddata, sizeof(enddata));
  printf("close\n");
	
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
  for (int i = 0; i < count; i++) {
    printf("%lf, %lf, %lf, %lf\n",
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
  printf("start\n");
  
  recv_msg("localhost", atoi(argv[1]));
  
  printf("prd_time, recv_time, send_time, cons_time, prd2cons_time, prd2recv_time, recv2send_time, send2cons_time\n");
  return 0;
}
