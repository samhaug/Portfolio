// xh_findmax 

// Find the maximum amplitude of a trace around tpcks[i_phs]
// in the widow [i_phs-w1, i_phs+w2]

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "xhhead.h"
 
main(argc,argv)
int argc;
char *argv[];
{
xhhed h;
FILE *ifl, *ofl, *fopen();

int i;
int index;
int ierr;
int still_reading_data = 1;
int i_phs;
int i0, i1, i2, i_max;
int look_for_min=0;

float w1, w2;
float d_max;
float data[XH_NPTS];

int usage();

if (argc < 8) {
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
     case 'i':
        // index of the phase around which we should look for a maximum/minimum
        if ( sscanf( argv[++index], "%d", &i_phs ) != 1) {
            ierr = usage();
        }
        break;
     case 'n':
        // if we are looking for a minimum
        look_for_min = 1;
        break;
     case 'w':
        // window
        if ( sscanf( argv[++index], "%f", &w1 ) != 1) {
            ierr = usage();
        }
        if ( sscanf( argv[++index], "%f", &w2 ) != 1) {
            ierr = usage();
        }
        break;
     default:
        ierr = usage();
        exit(ierr);
  }
}

while (still_reading_data) {
  if   (! xh_readhead(ifl,&h)) {
    still_reading_data = 0;
    exit(0);
  } else {
    if (! xh_readdata(ifl,h,data)) {
      still_reading_data = 0;
      exit(0);
    }
  }
  // check header:
  if (! xh_checkheader(h) )
      exit(-1);
  fprintf(stdout,"%s %-4s %2s %3s %f",h.cmtcd,h.stnm,h.netw,h.chan,h.delta);

  // Make sure that h.tpcks[i_phs] is defined
  if (h.tpcks[i_phs] <= 0.) {
    fprintf(stderr,"Record %s %s -- Handpick  time [=%f] not valid ...\n", h.stnm,h.chan,h.tpcks[4]);
    exit(-1);
  }
  i0 = (int) (h.tpcks[i_phs])   /h.delta;
  i1 = (int) (h.tpcks[i_phs]-w1)/h.delta;
  i2 = (int) (h.tpcks[i_phs]+w2)/h.delta;

  fprintf(stdout,"stnm= %s i_PHS= %d max= %e\n", h.stnm,i_phs, data[i0]);
  fprintf(stdout,"i1--i2= %d--%d look_for_min= %d\n", i1, i2, look_for_min);

  i_max = i1;
  d_max = data[i1];
  for (i=i1; i<i2; i++) {
    if (look_for_min) {
      if (data[i] < d_max) {
        i_max = i;
        d_max = data[i];
      }
    } else {
      if (data[i] > d_max) {
        d_max = data[i];
        i_max = i;
      }
    }
  }
  fprintf(stdout,"d_max= %e i_max= %d\n", d_max, i_max);

//Put new SStime in XH-header
  h.tpcks[9] = i_max*h.delta;

  /* WRITE XH header and data */
  if (! xh_writehead(ofl,h))
    exit(-1);
  if (! xh_writedata(ofl,h,data))
    exit(-1);
} // while

fclose(ifl);
fclose(ofl);
}

int usage()
{
  fprintf(stderr,"\n");
  fprintf(stderr,"Usage: xh_findmax in_XHfile out_XHfile [-n] -i i_PHS -w W1 W2\n");
  fprintf(stderr,"        option -n if looking for minimum value\n");
  fprintf(stderr,"\n");
  return(-1);
}
