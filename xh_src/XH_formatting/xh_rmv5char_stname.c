/*
  xh_bugfix - selects data from XH file
  excluded the 5+ char stations from XH file
  Fixes an original mistake (in LH data processing) in writing station names for
  station names with 5 or more characters
*/

#include <stdio.h>
#include <string.h>
#include <math.h>
#include "/work/jeroen/inc/xhhead.h"

main( argc, argv )
int   argc;
char       *argv[];
{
    float     seism[XH_NPTS];
    int       index = 0, i,j,nstns=0;
    int       still_reading_data = 1;
    int       keep_this_station  = 0;
    int	      ierr;
    xhhed     h;
    char      kstations[200][6],sacfile[80];
    FILE     *ifl, *ofl, *fopen();

if (argc != 3)
    ierr = usage();
if ((ifl = fopen(argv[1],"r")) == NULL) {
    ierr = usage();
    exit(ierr);
}
if ((ofl = fopen(argv[2],"w")) == NULL) {
    ierr = usage();
    exit(ierr);
}

// Loop over traces on stdin
while (still_reading_data) {
  if    (! xh_readhead(ifl,&h)) {
     exit(-1);
  } else {
     if (! xh_readdata(ifl,h,seism))
       exit(-1);
     if ( h.stnm[3] == '\0' && isalnum(h.stnm[2]) > 0) {
       // fprintf(stdout,"AAA Writing data for --%s-- --%s--\n",h.stnm,h.chan);
       // fprintf(stdout,"ch1- %d %d %d %d %d %d\n",
       //       isalpha(h.stnm[0]),
       //       isalpha(h.stnm[1]),
       //       isalpha(h.stnm[2]),
       //       isalpha(h.stnm[3]),
       //       isalpha(h.stnm[4]),
       //       isalpha(h.stnm[5]));
        // WRITE XH header and data
        if (! xh_writehead(ofl,h))
          exit(-1);
        if (! xh_writedata(ofl,h,seism))
          exit(-1);
     } else if ( h.stnm[4] == '\0' && isalnum(h.stnm[3]) > 0) {
        // WRITE XH header and data
        if (! xh_writehead(ofl,h))
          exit(-1);
        if (! xh_writedata(ofl,h,seism))
          exit(-1);
     }
  }
} // while

fclose(ifl);
exit( 0 );
} 

int usage()
{
fprintf(stderr,"Usage: xh_rmv5char_stname in_XH out_XH  ... \n");
return(-1);
}
