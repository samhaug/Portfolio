#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"		// XH   structures

// inserts the quality into the XH header

main(argc,argv)
int argc;
char *argv[];
{
xhhed 	h;
int 	icount=1;
int 	i, ierr;
int     qual;
char    ss[20];

int still_reading_data = 1;
float seism[XH_NPTS];

FILE *ifl, *ofl, *fopen();

int usage();


if(argc != 5) usage();
if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     exit(ierr);
}
if ((ofl = fopen(argv[2],"w")) == NULL) {
     ierr = usage();
     exit(ierr);
}
if (strncmp(argv[3],"-q",2) != 0) {
     ierr = usage();
  // reading header
     exit(ierr);
} else {
  qual = atoi(argv[4]);
}
  // reading waveform

      still_reading_data = 0;
      exit(0);
    }
  }
  // check header
  if (! xh_checkheader(h) )
    exit(-1);


  // set the quality factor 
  h.qual = qual;


  // writing header
  if (! xh_writehead(ofl,h))
    exit (-1);
  // writing data
  if (! xh_writedata(ofl,h,seism)) 
    exit (-1);

  icount++;
} // while

fclose (ifl);
fclose (ofl);
}

int usage()
        {
        fprintf(stderr,"Usage: xh_insqual in_XHfile out_XHfile -q QUAL\n");
        return(-1);
}
