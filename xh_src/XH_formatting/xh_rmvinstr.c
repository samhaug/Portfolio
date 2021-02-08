#include <stdio.h>
#include <string.h>
#include <math.h>
#include <malloc.h>
#include "xhhead.h"
#include "Complex.h"

// ------------------------------------------------------------
// Removes instrument response

// Convolves seismogram from "raw" to "vel".
// Requires that h.wavf == "raw";

main(argc,argv)
int argc;
char *argv[];
{
xhhed h;
float f[XH_NPTS],fvel[XH_NPTS];
FILE *ifl, *ofl, *terra_log, *iris_log, *fopen();

int i, j;
int ierr;
int still_reading_data = 1;
int keep_this_record   = 1;
int npol=0, nzer=0;

int usage();

if(argc != 3) {
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
terra_log = fopen("TERRA_response.log","w");
iris_log  = fopen("IRIS_response.log","w");

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
  // fprintf(stdout,"Working on %s %s %s with WAVF=%s\n",h.cmtcd,h.netw,h.stnm,h.wavf);
  // check header:
  if (! xh_checkheader(h) )
      exit(-1);
  // Skip this record if it is NOT a "raw" seismogram
  if ( strncmp(h.wavf,"raw",3) != 0) {
    fprintf(stdout,"Not using %s %s %s because WAVF=%s is not RAW\n",
       h.cmtcd,h.netw,h.stnm,h.wavf);
    keep_this_record = 0;
  }

  // Check the number of poles/zeroes
  if (keep_this_record) {
    // detrend the data
    if (! xh_detrend(f,h.ndata)) exit(-1);

    npol = xh_float2int(h.pole[0].r);
    nzer = xh_float2int(h.zero[0].r);
    // fprintf(stdout,"%s %s %s npol= %d nzer= %d\n",h.cmtcd,h.netw,h.stnm,npol,nzer);
    if ( npol<=0 && nzer<=0 ) {
      if ( strncmp(h.netw,"CI",2) != 0) {
        // fprintf(stdout,"Response unknown. Skipping: %s %s %s\n",h.cmtcd,h.netw,h.stnm);
        keep_this_record = 0;
      } else {
        // fprintf(stdout,"TriNET data: %s %s %s\n",h.cmtcd,h.netw,h.stnm);
        if ( ! xh_trinetresp(terra_log,h,f,fvel) )
          keep_this_record = 0;
      }
    } else {
      // fprintf(stdout,"SEED data: %s %s %s\n",h.cmtcd,h.netw,h.stnm);
      if (! xh_irisresp(iris_log,h,f,fvel) )
        keep_this_record = 0;
    }
  }

  if (keep_this_record) {
    // New record is now a VELOCITY record
    strcpy(h.wavf,"vel");
    /* WRITE XH header and data */
    if (! xh_writehead(ofl,h))
      exit(-1);
    if (! xh_writedata(ofl,h,fvel))
      exit(-1);
  }
} // while

fclose(ifl);
fclose(ofl);
exit (0);
}

int usage()
{
        fprintf(stderr,"Usage: xh_rmvinstr in_XHfile out_XHfile\n");
        return(-1);
}
