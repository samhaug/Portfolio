#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <malloc.h>
#include "xhhead.h"

// ------------------------------------------------------------
// Compares the headers two XH files

main(argc,argv)
int argc;
char *argv[];
{
xhhed h1, h2;
float f[XH_NPTS];
FILE *fl1, *fl2, *fopen();

int k=0;
int i_stnm1, i_stnm2, i_netw1, i_netw2;
int ierr;
int fine = 1;
int still_reading_data = 1;

int usage();

if(argc != 3) {
   ierr = usage();
   exit(ierr);
}
if ((fl1 = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     return(ierr);
}
if ((fl2 = fopen(argv[2],"r")) == NULL) {
     ierr = usage();
     return(ierr);
}

while (still_reading_data) {
  if   (! xh_readhead(fl1,&h1)) {
    still_reading_data = 0;
    exit(0);
  } else {
    if (! xh_readdata(fl1,h1,f)) {
      still_reading_data = 0;
      exit(0);
    }
  }
  if (!  xh_readhead(fl2,&h2)) {
    fprintf(stderr,"Error in readhead() file 2 ..\n");
    exit(0);
  }
  if (!  xh_readdata(fl2,h2,f)) {
    fprintf(stderr,"Error in readhdata) file 2 ..\n");
    exit(0);
  }
  k=k+1;
  // check header:
  if (! xh_checkheader(h1) )
      exit(-1);
  if (! xh_checkheader(h2) )
      exit(-1);
  i_stnm1 = iswhite(h1.stnm);
  i_stnm2 = iswhite(h2.stnm);
  i_netw1 = iswhite(h1.netw);
  i_netw2 = iswhite(h2.netw);
    
  if (i_stnm1 != i_stnm2)                      fine = 0;
  if (i_netw1 != i_netw2)                      fine = 0;

  if (h1.ndata != h2.ndata)                    fine = 0;
  if (h1.chid != h2.chid)                      fine = 0;
  if ( strncmp(h1.evtcd,h2.evtcd,7) != 0)      fine = 0;
  if ( strncmp(h1.netw,h2.netw,i_netw1)  != 0) fine = 0;
  if ( strncmp(h1.stnm,h2.stnm,i_stnm1)  != 0) fine = 0;
  if ( strncmp(h1.chan,h2.chan,3)        != 0) fine = 0;
  if (! fine) {
    fprintf(stdout,"i= %d %s --%s--%s--%s-- id=%d n=%d ",k,h1.evtcd,h1.netw,h1.stnm,h1.chan,h1.chid,h1.ndata);
    fprintf(stdout," %s --%s--%s--%s-- id=%d n=%d\n",      h2.evtcd,h2.netw,h2.stnm,h2.chan,h2.chid,h2.ndata);
    exit(0);
  }

} // while
  
fclose(fl1);
fclose(fl2);
exit (0);
}

int usage()
{
  fprintf(stderr,"Usage: xh_decim in_XHfile out_XHfile -t newDT (s)\n");
  return(-1);
}
