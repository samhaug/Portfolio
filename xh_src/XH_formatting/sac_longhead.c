//
// sac_longhead - quickly dump information about a sac file
//

// S.M. Haugland 2019 Mines


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "xhhead.h"

main( argc, argv )
int   argc;
char       *argv[];
{
    float     seism[XH_NPTS];
    int       index = 0, j,nstns=0;
    int       still_reading_data = 1;
    int       useful;
    int	      ierr;
    int       jdebug = 1;
    int       locc;
    int       k;
    xhhed     h;
    char      location[3];
    char      sacfile[80];
    char      ret_pzfile[80];
    char      std_pzfile[80];
    char      opt_pzfile[80];
    float     az,baz,delta;
    FILE     *ifl, *ofl, *fopen();


if (argc == 1) {
   ierr = usage();
   exit(ierr);
}
strcpy(sacfile,argv[1]);

index = 2;
while ( ++index < argc && argv[index][0] == '-' ) {
  switch ( argv[index][1] ) {
     case 'l':
        // location code
        if ( sscanf( argv[++index], "%d", &locc ) != 1) {
            ierr = usage();
            exit(ierr);
        }
        break;
     default:
        ierr = usage();
        exit(ierr);
  }
}

if (! xh_setdefaults(&h)) {
  fprintf(stderr,"Error xh_setdefaults() ...\n");
  exit(-1);
}

// Read SAC file
if (! xh_readsac_silent(&h,seism,sacfile,&useful)) {
  fprintf(stderr,"error running xh_readsac() ...\n");
  exit(-1);
}

if (! distaz(h.slat,h.slon,h.elat,h.elon,&delta,&az,&baz)){
  fprintf(stdout,"error with distaz\n");
  exit(-1);
}

if (jdebug) {
  fprintf(stdout,"%5s%5s %5.2f %4.2f %5.2f %5.2f %5.2f %5.2f %5.2f\n",h.netw,h.stnm,h.edep,h.elat,h.elon,h.slat,h.slon,delta,az);
}
}


int usage(){
fprintf(stderr,"Usage: sac_longhead in_SAC\n");
return(-1);
}
