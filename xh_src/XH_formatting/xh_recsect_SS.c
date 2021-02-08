#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include "xhhead.h"		// XH   structures

// Generates a record section of stacked data

// Assumes:
// (-) that the traces have the same sampling frequency DT
// (-) that DT == 1
// (-) that h.chid == 1
// (-) h.tpcks[4] is the SS time

#define NZREC 400
#define NSAMP 1001
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
int     do_next_data = 0;
int     i_useful = 0;

int     still_reading_data = 1;
float   data[XH_NPTS];
float   stack[NSAMP][NDIST];
int     count[NDIST];
float   gcdist, az, baz;

char    xhname[80], outname[80];
FILE   *xhfl, *ofl, *fopen();

int usage();

// Command line input
if(argc != 3) {
     ierr = usage();
     exit(-1);
}
if ((xhfl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     exit(-1);
}

for(j=0;j<NDIST;j++) {
  count[j] = 0;
  for(i=0;i<NSAMP;i++) 
    stack[i][j] = 0.;
}


// Get XH file from the list ...
while (! do_next_data) {
  if   (! xh_readhead(xhfl,&h)) {
    do_next_data = 1;
    break;
  } else {
    if (! xh_readdata(xhfl,h,data)) {
      do_next_data = 1;
      exit(0);
    }
  }
  // check header
  if (! xh_checkheader(h) )
    exit(-1);
  // only T component waveforms
  if (h.chid != 5) {
    fprintf(stderr,"Record %s %s - chid= %d ...\n", h.stnm,h.chan,h.chid);
    exit(-1);
  }
  // Make sure that h.tpcks[4] (= Handpick time) is defined
  if (h.tpcks[4] <= 0.) {
    fprintf(stderr,"Record %s %s - SS= %f ...\n", h.stnm,h.chan,h.tpcks[4]);
    exit(-1);
  }
  // Epicentral distance - only okay for D>85
  i_useful = 0;
  if (! distaz(h.slat,h.slon,h.elat,h.elon,&gcdist,&az,&baz))
     exit(-1);
  if (gcdist > 85.)
     i_useful = 1;
  i_gcdist = (int) rintf(gcdist) - 85;
  fprintf(stdout,"cmt= %s stnm= %4s dist= %5.1f i_dist= %d i_useful= %d tpcks4= %f\n",
     h.evtcd,h.stnm,gcdist,i_gcdist,i_useful, h.tpcks[4]);

  if ( i_useful ) {
    count[i_gcdist] = count[i_gcdist] + 1;
    for(i=0;i<NSAMP;i++) {
      stack[i][i_gcdist] = stack[i][i_gcdist] + data[i];
    }
    // fprintf(stdout,"stnm= %s data_800= %5.3f stack_800= %5.3f\n",
    //     h.stnm,data[800],stack[800][i_gcdist]);
    // fprintf(stdout,"gcdist= %4.1f i_gcdist= %d count= %d stack_800= %5.3f\n",
    //     gcdist,i_gcdist,count[i_gcdist],stack[800][i_gcdist]);
  }
}
fprintf(stdout,"closing %s\n", xhname);
fclose (xhfl);

if (( ofl = fopen("recsect.count","w")) == NULL)
  fprintf(stderr,"Error opening recsect.count\n");
for (j=0;j<NDIST;j++)
  fprintf(ofl,"%d %d\n", j+85, count[j]);
fclose(ofl);

for (j=0;j<NDIST;j++) {
  sprintf(outname,"%s.%00d", argv[2], j+85);
  fprintf(stdout,"outname= --%s--", outname);
  if ((ofl = fopen(outname,"w")) == NULL) 
    fprintf(stderr,"Error opening %s\n", outname);
  fprintf(stdout,"j= %d count= %d\n", j, count[j]);
  for (i=0;i<NSAMP;i++) {
    if (count[j]>0) {
      fprintf(ofl,"%6.1f %7.3f\n", i*1.-800., stack[i][j]/count[j]);
    } else {
      fprintf(ofl,"%6.1f %7.3f\n", i*1.-800., 0.);
    }
  }
  fclose(ofl);
}

}

int usage()
{
fprintf(stderr,"Usage: xh_recsect XH_file OUT_file \n");
return(-1);
}

