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
    FILE     *ifl, *ofl, *fopen();

// setting default variables in the XH header
if (! xh_setdefaults(&h)){
   fprintf(stderr,"Error xh_setdefaults() ...\n");
   exit(-1);
}

// command line must have 15 arguments
if (argc != 15) {
   ierr = usage();
   exit(ierr);
}
// argv[1] is ascii inpput file
// argv[2] is XH output file
strcpy(axifile,argv[1]);
if ((ofl = fopen(argv[2],"w")) == NULL) {
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
// Event latitude and longitude
h.elat = elat;
h.elon = elon;
// Event depth
h.edep = evdep;

// Station latitude and colatitude and longitude
h.slat = slat;
h.slon = slon;

strcpy(h.netw,netwk);
strcpy(h.stnm,stnam);

// Channel name must be 'Z', 'N', or 'E'
if        (strcmp(chnam,"Z") == 0) {
   strcpy(h.chan,"BHZ");
   h.chid = 1;
} else if (strcmp(chnam,"N") == 0) {
   strcpy(h.chan,"BHN");
   h.chid = 2;
} else if (strcmp(chnam,"E") == 0) {
   strcpy(h.chan,"BHE");
   h.chid = 3;
} else {
   ierr = usage();
   exit(ierr);
}

if (jdebug) {
  fprintf(stdout,"\n-----ascii_2xh()------\n");
  fprintf(stdout,"chnam= %s h.chan= %s\n", chnam, h.chan);
  fprintf(stdout,"%s ", axifile);
}

// AxiSEM network code
// strcpy(h.netw,"AX");

// -------------------------------------
//
// READING THE DATA
//

if ((ifl = fopen(axifile,"r")) == NULL) {
   ierr = usage();
   exit(ierr);
}
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
     h.delta = t-t0;
  }
  if (i > 1) {
  //  fprintf(stdout,"Deltat in AXIsem at sample %d = %f\n", i, t - (i-1)*h.delta -t0 );
  }
  i=i+1;
}
// number of samples
h.ndata = i;


if (jdebug) {
  fprintf(stdout,"ot= %4d/%02d/%02d ", h.ot.yr,h.ot.mo,h.ot.day);
  fprintf(stdout,"%02d:%02d:%5.2f\n",  h.ot.hr,h.ot.mn,h.ot.sec);
  fprintf(stdout,"st= %4d/%02d/%02d ", h.tstart.yr,h.tstart.mo,h.tstart.day);
  fprintf(stdout,"%02d:%02d:%5.2f\n",  h.tstart.hr,h.tstart.mn,h.tstart.sec);

  fprintf(stdout,"--%s-- --%s--  --%s-- Locc= %d\n",h.netw,h.stnm,h.chan,h.locc);
  fprintf(stdout,"elat= %7.2f elon= %7.2f=  dept= %7.2f\n", h.elat, h.elon, h.edep);
  fprintf(stdout,"slat= %7.2f slon= %7.2f=  elev= %7.2f  ", h.slat, h.slon, h.elev);
  fprintf(stdout,"\n");
  fprintf(stdout,"DT= %8.4f N= %d\n",h.delta,h.ndata);
}

// WRITE XH header and data
 if (! xh_writehead(ofl,h))
   exit (-1);
 if (! xh_writedata(ofl,h,seism))
   exit (-1);

fclose(ifl);
fclose(ofl);
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

