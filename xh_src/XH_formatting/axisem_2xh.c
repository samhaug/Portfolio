//
// axisem_2xh - Turns AxiSEM ascii from Tarje
// Nissen-Meyer's AxiSEM simulations into XH format

// The sampling time "deltat" is assumed to be constant and will be
// determined from the time of the first two samples



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
    float     evdep, elat, slat, colat, f1, f2, t, t0;
    int       index = 0;
    int	      ierr;
    int       jdebug = 1; // debugging flag (=0 if turned off)
    int       i;
    int       i1, i2;
    xhhed     h;
    char      stnam[CHARSIZE];
    char      chnam[CHARSIZE];
    char      ss[120];
    char      axifile[80];
    FILE     *ifl, *ofl, *fopen();


// setting default variables in the XH header
if (! xh_setdefaults(&h)) {
  fprintf(stderr,"Error xh_setdefaults() ...\n");
  exit(-1);
}

// Turn on the debugger (print statements)
jdebug = 1;

// command line must have 11 arguments
if (argc != 11) {
   ierr = usage();
   exit(ierr);
}
// argv[1] is AXIsem inpput file
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
        // event latitude
        if ( sscanf( argv[++index], "%f", &elat ) != 1) {
            ierr = usage();
            exit(ierr);
        }
        break;
     case 's':
        // station latitude
        if ( sscanf( argv[++index], "%f", &slat ) != 1) {
            ierr = usage();
            exit(ierr);
        }
        break;
     case 'c':
        // channel name
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
h.elon =  0.;
// Event depth
h.edep = evdep;

// Station latitude and colatitude and longitude
h.slat = slat;
h.slon =  0.;
colat = 90.-slat;
// If -90<slat<90 then 0<colat<180
if (colat > 180. || colat < 0.) {
   ierr = usage();
   exit(ierr);
}

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

// The station name will have 7 characters and have the form NNN_NNN.
// It is based on the colatitude:
// For example,
// colat =   9.23     --> stnam = 009_230
// colat =  29.2      --> stnam = 029_200
// colat = 129.4138   --> stnam = 129_414
f1 = floorf(colat);
i1 = (int) f1;
f2 = rintf((colat-f1)*1000.);
i2 = (int) f2;
sprintf(stnam,"%03d_%03d",i1,i2);
// copy stnam into header
strcpy(h.stnm,stnam);


if (jdebug) {
  fprintf(stdout,"\n-----axisem_2xh()------\n");
  fprintf(stdout,"chnam= %s h.chan= %s\n", chnam, h.chan);
  fprintf(stdout,"colat= %f f1= %f f2= %f i1= %d i2= %d\n", colat, f1,f2, i1, i2);
  fprintf(stdout,"%s ", axifile);
}

// AxiSEM network code
strcpy(h.netw,"AX");

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


fprintf(stdout,"axifile= %s   stnam= %s chnam= %s chid= %d\n", axifile,h.stnm,h.chan,h.chid);
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
fprintf(stderr,"Usage: axisem_2xh in_AXIsem out_XH -h EvDep -e eLat -s sLat -c ChName\n");
fprintf(stderr,"       -90 < Lat < 90\n");
fprintf(stderr,"       ChName = Z, N, E\n");
return(-1);
}
