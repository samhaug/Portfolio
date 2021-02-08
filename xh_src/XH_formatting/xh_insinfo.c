//
// xh_insinfo
//
// Take the info files (generated using the matlab scripts in Matlab/Lib_SH_SV or Lib_Z
// Reads XH and writes XH if the traveltime anomaly in the INFO file is not -999.9
// i.e. if quality is at least 1
//
// The pck from the info file is written into h.tpcks[n];
// the element n is specified by the -n option
// 
// Minor addition just for work on P wave picking in Research/Clustering ...!!!!!!
// I had worked on a window from [T5 - 120s] to [T5+120s]
// Previously, I had set T5 to be the P time for iasp91.
// The info shows pick times around 120 s.
// These are onset of the P wave.
// Here I put into the pck the following time: T5 + (infopck-120)
// Take this out when working on something else.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "xhhead.h"

main( argc, argv )
int   argc;
char       *argv[];
{
    float     data[XH_NPTS];
    float     anom, dt;
    int       index, ierr;
    int       all_is_well = 0, still_reading_data = 1;
    int       i=0, N;
    int	      q,npts;
    xhhed     h;
    FILE     *xh_in, *xh_out, *infofl, *fopen();

    char  INFO[130], OU;
    char  ss[50];
    char  chan[8], stnm[8], netw[8];

if (argc != 5) {
  usage();
  exit(-1);
}

// Input XH data file
if ((xh_in=fopen(argv[1],"r")) == NULL) {
     exit(-1);
}
// Output XH data file
if ((xh_out=fopen(argv[2],"w")) == NULL) {
     exit(-1);
}
sprintf(INFO,"%s.info", argv[1]);
// Input INFO file
if ((infofl=fopen(INFO, "r")) == NULL) {
    fprintf(stderr,"\nError opening %s\n",INFO);
    fprintf(stderr,"Exiting !! \n");
    exit(-1);
}

index = 2;
while ( ++index < argc && argv[index][0] == '-' ) {
  switch ( argv[index][1] ) {
     case 'n':
        // index N (h.tpcks[N]) for time pick
        if ( sscanf( argv[++index], "%d", &N ) != 1) {
            ierr = usage();
        }
        break;
     default:
        ierr = usage();
        exit(ierr);
  }
}

i=0;
// Loop over traces in XH and INFO files
while (still_reading_data) {
  i = i+1;
  if    (! xh_readhead(xh_in,&h)) {
     still_reading_data=0;
     break;
  } else {
     if (! xh_readdata(xh_in,h,data)) {
       still_reading_data=0;
       exit(-1);
     }
  }
  if (! xh_checkheader(h) )
    exit(-1);
    //fprintf(stdout, "XH: i= %d -%-5s- -%s- -%s-\n",i,h.stnm,h.chan,h.netw);

  // loop through INFO until you find a match between stnm/chan in INFO and XH
  rewind(infofl);
  while ( fgets(ss,48,infofl) != NULL) {
    sscanf(ss,"%*s %s %s %s %d %f %d %f", stnm,netw,chan,&npts,&dt,&q,&anom);
    // check that the info line corresponds to the correct trace
    if (checking(h,stnm,chan,netw) == 1) {
    //fprintf(stdout, "FOUND: -%-5s- -%s- n= %d anom= %5.2f\n",stnm,chan,N,anom);
      h.qual = q;
      h.tpcks[N] = anom;
      // temporary change (see top of page)
      h.tpcks[N] = h.tpcks[5] + (anom-120.);
      break;
    }
  }

  // Write data if h.qual>0
  if (h.qual>0 ) {
    fprintf(stdout, "Writing XH -%-5s- -%s- n= %d anom= %5.2f\n",h.stnm,h.chan,h.ndata,h.tpcks[N]);
    if (! xh_writehead(xh_out,h))
      exit(-1);
    if (! xh_writedata(xh_out,h,data))
      exit(-1);
  }
}
fclose(infofl);
exit( 0 );
} 

int usage()
{
fprintf(stderr,"\n");
fprintf(stderr,"Usage: xh_insinfo XH_in XH_out -n NPCK\n");
fprintf(stderr,"Writes the pick from the INFO file into h.tpcks[NPCK]\n");
fprintf(stderr,"READ COMMENTS ON TOP OF CODE\n");
fprintf(stderr,"\n");
return(-1);
}

int checking(h, stnm, chan, netw)
xhhed h;
char  chan[8], stnm[8], netw[8];
{

int foundit = 1;

if        (strncmp(h.stnm,stnm,4) != 0) {
//fprintf(stderr,"checking(): No match in stnm: -%s- -%s-\n", h.stnm,stnm);
  foundit = 0;
}
if (strncmp(h.chan,chan,3) != 0) {
//fprintf(stderr,"checking(): No match in chan: -%s- -%s-\n", h.chan,chan);
  foundit = 0;
}
if (strncmp(h.netw,netw,2) != 0) {
//fprintf(stderr,"checking(): No match in netw: -%s- -%s-\n", h.netw,netw);
  foundit = 0;
}

return(foundit);
}
