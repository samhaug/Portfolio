#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"		// XH   structures

// Inserts BDSN instrument response

main(argc,argv)
int argc;
char *argv[];
{
xhhed 	h;
int 	icount=1;
int 	i, ierr;
int     npoles, nzeros;

int still_reading_data = 1;
float seism[XH_NPTS];

char infile[80];
FILE *ifl, *ofl, *fopen();

int usage();

if(argc != 3) usage("");
if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     return(ierr);
}
if ((ofl = fopen(argv[2],"w")) == NULL) {
     ierr = usage();
     return(ierr);
}

while (still_reading_data) {
  if   (! xh_readhead(ifl,&h)) {
    still_reading_data = 0;
    exit(0);
  } else {
    if (! xh_readdata(ifl,h,seism))
      exit(0);
  }
  // check header
  if (! xh_checkheader(h) )
    exit(-1);

  // BDSN Instrument Response Info: */
  if (strncmp(h.netw,"BK",2) == 0 &&
       lrint(h.pole[0].r) <= 0 &&
       lrint(h.zero[0].r) <= 0 )  {
       // fprintf(stdout,"INSRT resp: %s %s %s\n",h.netw,h.stnm,h.chan);
    if (! xh_bdsnresp(&h) ) {
      fprintf(stderr,"Error running xh_bdsnresp() ...\n");
      exit(-1);
    }
  }
  // WRITE XH header and data
  if (! xh_writehead(ofl,h))
    exit(-1);
  if (! xh_writedata(ofl,h,seism)) 
    exit(-1);
} // while 

fclose (ifl);
fclose (ofl);
}

int usage()
        {
        fprintf(stderr,"Usage: xh_insBDSN_response in_XHfile out_XHfile\n");
        return(-1);
}
