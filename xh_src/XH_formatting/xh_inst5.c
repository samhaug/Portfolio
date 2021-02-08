#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <malloc.h>
#include "xhhead.h"
#include "DComplex.h"

#define NPTS 262144

// ------------------------------------------------------------
// insert t5

main(argc,argv)
int argc;
char *argv[];
{
xhhed h;
float f[NPTS];
FILE *ifl, *ofl, *fopen();

int i,k;
int ierr;
int index;
int still_reading_data = 1;

int NFFT = XH_NPTS;
int fact;

float t5;

int usage();

if(argc != 5) {
   ierr = usage();
   exit(ierr);
}
if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     return(ierr);
}
if ((ofl = fopen(argv[2],"w")) == NULL) {
     ierr = usage();
     return(ierr);
}

index = 2;
while ( ++index < argc && argv[index][0] == '-' ) {
  switch ( argv[index][1] ) {
     case 't':
        // number of samples
        if ( sscanf( argv[++index], "%f", &t5 ) != 1) {
            ierr = usage();
        }
        break;
     default:
        ierr = usage();
        return(ierr);
  }
}

while (still_reading_data) {
  if   (! xh_readhead(ifl,&h)) {
    still_reading_data = 0;
    exit(0);
  } else {
    if (! xh_readdata(ifl,h,f)) {
      still_reading_data = 0;
      exit(0);
    }
  }
  // check header:
  if (! xh_checkheader(h) )
      exit(-1);
  
  h.tpcks[5] = t5;
  
  /* WRITE XH header and data */
  if (! xh_writehead(ofl,h))
     exit(-1);
  if (! xh_writedata(ofl,h,f))
     exit(-1);
} // while
  
fclose(ifl);
fclose(ofl);
exit (0);
}

int usage()
{
  fprintf(stderr,"Usage: xh_inst5 in_XHfile out_XHfile -t T5\n");
  return(-1);
}
