#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <time.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/ioctl.h>
#include <sys/shm.h>
#include <sys/stat.h>
#include <netinet/in.h>
#include <linux/sockios.h>
#include <netdb.h>
#include <stdlib.h>

#define rdtsc_64(lower, upper) asm __volatile ("rdtsc" : "=a"(lower), "=d" (upper));

#define PORT_NO 9872
#define MAX_COUNT 100000
#define MEM_SIZE 5000

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

void send_msg (char *host, int count, int len, int winsize)
{
  int msglen = len*1024;
  char buf[MEM_SIZE];
  char iddata[16];
  int fd = socket(AF_INET, SOCK_STREAM, 0);
  buf[msglen + 20] = '\0';

  if (fd < 0) {
    perror("socket\n");
    return;
  }

  struct hostent *hp;
  if ((hp = gethostbyname(host)) == NULL) {
    fprintf(stderr, "gethost error %s\n", host);
    close(fd);
    return;
  }

  struct sockaddr_in addr;
  memset(&addr, 0, sizeof(addr));
  addr.sin_family = AF_INET;
  addr.sin_port = htons(PORT_NO);
  memcpy(&addr.sin_addr, hp->h_addr, hp->h_length);

  //  char input = getchar();
  char input = 'a';

  for (int a = 0; a < msglen + 20; a++) {
	buf[a] = input;
  }
  
  int length = len;
  int command = 1;
  int dest = 3;
  int endnum = 9;
  char enddata[16];

  memcpy(&iddata[0],&length,sizeof(length));
  memcpy(&iddata[4],&command,sizeof(command));
  memcpy(&iddata[8],&winsize,sizeof(winsize));
  memcpy(&iddata[12],&dest,sizeof(dest));

  memcpy(&enddata[0],&len,sizeof(len));
  memcpy(&enddata[4],&endnum,sizeof(endnum));
  memcpy(&enddata[8],&winsize,sizeof(winsize));
  memcpy(&enddata[12],&dest,sizeof(dest));
  
  memcpy(&buf[0],&len,sizeof(len));
  memcpy(&buf[4],&command,sizeof(command));
  memcpy(&buf[8],&winsize,sizeof(winsize));
  
  while (1) {
	if (connect(fd, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
	  printf("sleep\n");
	  sleep(1);
	  continue;
	} else {
	  break;
	}
  }

  unsigned int tsc_l, tsc_u; //uint32_t
  unsigned long int log_tsc;

  for (int n = 0; n < (count / winsize); n++){
    writen(fd, iddata, sizeof(iddata));
    char ack[4];
    readn(fd, ack, 4);
   
    for (int i = 0; i < winsize; i++) {
      rdtsc_64(tsc_l, tsc_u);
      log_tsc = (unsigned long int)tsc_u<<32 | tsc_l;
      memcpy(&buf[msglen + 12], &log_tsc, sizeof(log_tsc));
      
      writen(fd, buf, msglen + 20);
    } 
    readn(fd, ack, 4);
  }
  writen(fd, enddata, sizeof(enddata));
  printf("close\n");
  if (close(fd) == -1) {
    printf("%d\n", errno);
  }
}

int main (int argc, char *argv[])
{
  printf("start\n");
  
  send_msg("localhost", atoi(argv[1]), atoi(argv[2]), atoi(argv[3]));
  printf("end\n");
  return 0;
}
