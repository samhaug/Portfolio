#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"		// XH   structures

// Inserts waveform type into the XH header

main(argc,argv)
int argc;
char *argv[];
{
xhhed 	h;
int 	index, ierr;
int     jdebug=0;
char    ss[20];
char    wavf[8];

int still_reading_data = 1;
float seism[XH_NPTS];

FILE *ifl, *ofl, *fopen();

int usage();


if(argc == 1) usage();
if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     exit(ierr);
}
if ((ofl = fopen(argv[2],"w")) == NULL) {
     ierr = usage();
     exit(ierr);
}
index = 2;
while ( ++index < argc && argv[index][0] == '-' ) {
  switch ( argv[index][1] ) {
     case 'w':
        // network code
        if ( sscanf( argv[++index], "%s", wavf ) != 1) {
            ierr = usage();
            exit(ierr);
        }
        break;
  }
}

while (still_reading_data) {
  if   (! xh_readhead(ifl,&h)) {
    still_reading_data = 0;
    exit(0);
  } else {
    if (! xh_readdata(ifl,h,seism)) {
      still_reading_data = 0;
      exit(0);
    }
  }
  // check header
  if (! xh_checkheader(h) )
    exit(-1);

  sprintf(h.wavf,"%s", wavf);
  if (jdebug)
    fprintf(stdout,"inserting WAVF=%s into: %s %s %s\n", wavf, h.netw,h.stnm,h.chan);
  if (! xh_writehead(ofl,h))
    exit (-1);
  if (! xh_writedata(ofl,h,seism)) 
    exit (-1);

} // while

fclose (ifl);
fclose (ofl);
}

int usage()
        {
        fprintf(stderr,"Usage: xh_inswavf in_XHfile out_XHfile -w WAVF\n");
        return(-1);
}
