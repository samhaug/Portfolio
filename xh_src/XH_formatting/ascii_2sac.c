//
// ascii_2xh - Turns two-column ascii seismogram files into XH_format
//
// The sampling time "deltat" is assumed to be constant and will be
// determined from the time of the first two samples

// Now including Station/Event location and Station/Network name

//-------------------------------------
// See also axisem_2xh

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "xhhead.h"
#include "sac.h"        /* SAC format structures */


main(int argc, char *argv[]){
    float     seism[XH_NPTS];
    float     evdep, elat, elon, slat, slon, f1, f2, t, t0;
    int       index = 0;
    int	      ierr;
    int       jdebug = 1; // debugging flag (=0 if turned off)
    int       i;
    int       i1, i2;
    xhhed     h;
    char      netwk[CHARSIZE];
    char      stnam[CHARSIZE];
    char      chnam[CHARSIZE];
    char      ss[120];
    char      axifile[80];
    char      sacfile[80];
    float     *seism;
    float     delta,az,baz;
    struct    sac_header sh;
    FILE      *ifl, *osac, *fopen();

// setting default variables in the XH header

// command line must have 15 arguments
if (argc != 15) {
   ierr = usage();
   exit(ierr);
}
// argv[1] is ascii inpput file
// argv[2] is sac output file

if ((ifl = fopen(argv[1],"r")) == NULL) {
   ierr = usage();
   exit(ierr);
}
if ((osac = fopen(argv[2],"w")) == NULL) {
   ierr = usage();
   exit(ierr);
}

index = 2;
while ( ++index < argc && argv[index][0] == '-' ) {
  switch ( argv[index][1] ) {
     case 'h':
        // source depth
        if ( sscanf( argv[++index], "%f", &evdep ) != 1) {
            ierr = usage();
            exit(ierr);
        }
        break;
     case 'e':
        // event latitude and longitude
        if ( sscanf( argv[++index], "%f", &elat ) != 1) {
            ierr = usage();
            exit(ierr);
        }
        if ( sscanf( argv[++index], "%f", &elon ) != 1) {
            ierr = usage();
            exit(ierr);
        }
        break;
     case 's':
        // station latitude and longitude
        if ( sscanf( argv[++index], "%f", &slat ) != 1) {
            ierr = usage();
            exit(ierr);
        }
        if ( sscanf( argv[++index], "%f", &slon ) != 1) {
            ierr = usage();
            exit(ierr);
        }
        break;
     case 'c':
        // network, station and channel name
        //if ( sscanf( argv[++index], "%s %s %s", netwk, stnam, chnam ) != 1) {
        if ( sscanf( argv[++index], "%s", netwk ) != 1) {
            ierr = usage();
            exit(ierr);
        }
        if ( sscanf( argv[++index], "%s", stnam ) != 1) {
            ierr = usage();
            exit(ierr);
        }
        if ( sscanf( argv[++index], "%s", chnam ) != 1) {
            ierr = usage();
            exit(ierr);
        }
        break;
     default:
        ierr = usage();
        exit(ierr);
  }
}

if (! distaz(slat,slon,elat,elon,&delta,&az,&baz)){
  fprintf(stdout,"error with distaz\n");
  exit(-1);
}

// Event latitude and longitude
sh.evla = elat;
sh.evlo = elon;
// Event depth
sh.evdp = evdep;
// Station latitude and colatitude and longitude
sh.stla = slat;
sh.stlo = slon;
sh.gcarc = delta;

strcpy(sh.knetwk,netwk);
strcpy(sh.kstnm,stnam);


i=0;
while (fgets(ss,120,ifl) != NULL) {
  sscanf(ss,"%f %f", &t, &seism[i]);
  // first time sample is start time
  if (i == 0) {
     t0 = t;
     h.tshift = t0;
  }
  // sampling time
  if (i == 1) {
     sh.delta = t-t0;
  }
  if (i > 1) {
  //  fprintf(stdout,"Deltat in AXIsem at sample %d = %f\n", i, t - (i-1)*h.delta -t0 );
  }
  i=i+1;
}
// number of samples
h.ndata = i;


fclose(ifl);

fwrite(&sh,sizeof(struct sac_header),1,osac);
fwrite(&seism[0],sh.npts*sizeof(float),1,osac);

fclose(osac);
} 

int usage()
{
fprintf(stderr,"\n");
fprintf(stderr,"Convert two-column ascii seismogram to xh file\n");
fprintf(stderr,"\n");
fprintf(stderr,"Usage: ascii_2xh in_AXIsem out_XH -h EvDep -e eLat eLon -s sLat sLon -c NETW StNam CMP\n");
fprintf(stderr,"       CMP = Z, N, E\n");
return(-1);
}

