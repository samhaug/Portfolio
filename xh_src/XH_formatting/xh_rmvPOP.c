/*
  xh_rmvPOP - selects data from XH file
  and removes POP? stations from XH file
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
     if ( strncmp(h.stnm,"POP",3) != 0){
        // WRITE XH header and data
        if (! xh_writehead(ofl,h))
          exit(-1);
        if (! xh_writedata(ofl,h,seism))
          exit(-1);
    } // end if "POP"
  }
} // while

fclose(ifl);
exit( 0 );
} 

int usage()
{
fprintf(stderr,"Usage: xh_rmvPOP in_XH out_XH ... \n");
return(-1);
}
