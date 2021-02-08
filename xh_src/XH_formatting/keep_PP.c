#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include "xhhead.h"		// XH   structures

// Genberates a record section of stacked data

// Assumes:
// (-) that the traces have the same sampling frequency DT
// (-) that DT == 1
// (-) that h.chid == 1
// (-) h.tpcks[3] is the PP time

#define NZREC 400
#define NSAMP 601
#define NDIST 110

main(argc,argv)
int argc;
char *argv[];
{
xhhed 	h;
int     index;
int 	icount=1;
int 	i,j,k, ierr;
int     i_rec=0, i_gcdist;
int     do_next_event = 0;
int     i_useful = 0;

int     still_reading_data = 1;
float   data[XH_NPTS];
float   stack[NSAMP][NDIST];
int     count[NDIST];
float   gcdist, az, baz;

char    xhname[80];
FILE   *xhfl, *ofl, *lstfl, *fopen();

int usage();

// Command line input
if(argc != 3) {
     ierr = usage();
     exit(-1);
}
if ((lstfl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     exit(-1);
}
if ((ofl = fopen(argv[2],"w")) == NULL) {
     ierr = usage();
     exit(-1);
}

for(j=0;j<NDIST;j++) {
  count[j] = 0;
  for(i=0;i<NSAMP;i++) 
    stack[i][j] = 0.;
}


// Get XH file from the list ...
while ( fscanf(lstfl,"%s",xhname) != EOF ) {
  fprintf(stdout,"New event= %s\n", xhname);
  do_next_event = 0;
  if ( (xhfl = fopen(xhname,"r")) == NULL ) {
    fprintf(stderr,"Cannot open XH-file --%s-- ...\n", xhname);
    exit(-1);
  }
  while (! do_next_event) {
    if   (! xh_readhead(xhfl,&h)) {
      do_next_event = 1;
      break;
    } else {
      if (! xh_readdata(xhfl,h,data)) {
        do_next_event = 1;
        exit(0);
      }
    }
    // check header
    if (! xh_checkheader(h) )
      exit(-1);
    // only Z component waveforms
    if (h.chid != 1) {
      fprintf(stderr,"Record %s %s - chid= %d ...\n", h.stnm,h.chan,h.chid);
      exit(-1);
    }
    // Make sure that h.tpcks[3] (= Handpick time) is defined
    if (h.tpcks[3] <= 0.) {
      fprintf(stderr,"Record %s %s - PP= %f ...\n", h.stnm,h.chan,h.tpcks[3]);
      exit(-1);
    }
    // Epicentral distance - only okay for D>85
    i_useful = 0;
    if (! distaz(h.slat,h.slon,h.elat,h.elon,&gcdist,&az,&baz))
       exit(-1);
    if (gcdist > 85.)
       i_useful = 1;
    i_gcdist = lrintf(gcdist) - 85;
    //fprintf(stdout,"cmt= %s stnm= %s dist= %5.1f i_dist= %d i_useful= %d\n",
      // h.evtcd,h.stnm,gcdist,i_gcdist,i_useful);

    if ( i_useful ) {
      count[i_gcdist] = count[i_gcdist] + 1;
      for(i=0;i<NSAMP;i++) {
        stack[i][i_gcdist] = stack[i][i_gcdist] + data[i];
      }
      fprintf(stdout,"stnm= %s data_450= %5.3f stack_450= %5.3f\n",
          h.stnm,data[450],stack[450][i_gcdist]);
      fprintf(stdout,"gcdist= %4.1f i_gcdist= %d count= %d stack_450= %5.3f\n",
          gcdist,i_gcdist,count[i_gcdist],stack[450][i_gcdist]);
    }
  }
  fprintf(stdout,"closing %s\n", xhname);
  fclose (xhfl);
}

for (j=0;j<NDIST;j++) 
  fprintf(ofl,"dist= %d count= %d\n", j+85, count[j]);
for (j=0;j<NDIST;j++) {
  fprintf(stdout,"j= %d count= %d\n", j, count[j]);
  for (i=0;i<NSAMP;i++) {
    if (count[j]>0) {
      fprintf(ofl,"%6.1f %7.3f\n", i*1., stack[i][j]/count[j]);
//     fprintf(stdout,"%6.1f %d %7.3f\n", i*1., count[j], stack[i][j]/count[j]);
    } else {
      fprintf(ofl,"%6.1f %7.3f\n", i*1., 0.);
    }
  }
}

}

int usage()
{
fprintf(stderr,"Usage: xh_recsect XH_list OUTFILE \n");
return(-1);
}

