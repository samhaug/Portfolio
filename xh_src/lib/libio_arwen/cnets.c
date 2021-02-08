#include <errno.h>       /* obligatory includes */
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/wait.h>
#include <netinet/in.h>
#include <netdb.h>


#include <fcntl.h>
#include <unistd.h>

#define MAXHOSTNAME 256

int call_socket(char *hostname, unsigned short portnum)
{ struct sockaddr_in sa;
  struct hostent     *hp;
  int a, s;
  if ((hp= gethostbyname(hostname)) == NULL) { /* do we know the host's */
    errno= ECONNREFUSED;                       /* address? */
    return(-1);                                /* no */
  }
  memset(&sa,0,sizeof(sa));
  memcpy((char *)&sa.sin_addr,hp->h_addr,hp->h_length);     /* set address */
  sa.sin_family= hp->h_addrtype;
  sa.sin_port= htons((u_short)portnum);
  if ((s= socket(hp->h_addrtype,SOCK_STREAM,0)) < 0)     /* get socket */
    return(-1);
  if (connect(s,(struct sockaddr *)&sa,sizeof sa) < 0) { /* connect */
    close(s);
    return(-1);
  }
  return(s);
}

int establish(unsigned short portnum)
{ char   myname[MAXHOSTNAME+1];
  int    s; char yes='1';
  struct sockaddr_in sa;
  struct hostent *hp;
  memset(&sa, 0, sizeof(struct sockaddr_in)); /* clear our address */
  gethostname(myname, MAXHOSTNAME);           /* who are we? */
  hp= gethostbyname(myname);                  /* get our address info */
  if (hp == NULL)                             /* we don't exist !? */
    return(-1);
  sa.sin_family= hp->h_addrtype;              /* this is our host address */
  sa.sin_port= htons(portnum);                /* this is our port number */
  if ((s= socket(AF_INET, SOCK_STREAM, 0)) < 0) /* create socket */
    return(-1);
  if(setsockopt(s,SOL_SOCKET,SO_REUSEADDR,&yes,sizeof(int)) == -1) {
    perror("setsockopt"); exit(1);}
  if (bind(s,(struct sockaddr *)&sa,sizeof(struct sockaddr_in)) < 0) {
    close(s);
    return(-1);                               /* bind address to socket */
  }
  listen(s, 10);                               /* max # of queued connects */
  return(s);
}

void fireman(int dummy)
{
  while (waitpid(-1, NULL, WNOHANG) > 0)
    ; 
}


int get_connection(int s)
{ int t;                  /* socket of connection */
  if ((t = accept(s,NULL,NULL)) < 0) { /* accept connection if there is one */
    return(-1);}
  return(t);
}


int read_data(int s,     /* connected socket */
              char *buf, /* pointer to the buffer */
              int n      /* number of characters (bytes) we want */
             )
{ int bcount; /* counts bytes read */
  int br;     /* bytes read this pass */

  bcount= 0;
  br= 0;
  while (bcount < n) {             /* loop until full buffer */
    if ((br= read(s,buf,n-bcount)) > 0) {
      bcount += br;                /* increment byte counter */
      buf += br;                   /* move buffer ptr for next read */
    }
    else if (br < 0)               /* signal an error to the caller */
      return(-1);
  }
  return(bcount);
}
