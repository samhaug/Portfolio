//
// ah_2xh - Turn AH into XH 
// WORKS ONLY FOR AH DATA PRODUCED BY HENDRIK
// USES SPECIAL STATION NAMES
//

#include <stdio.h>
#include <string.h>
#include <math.h>
#include <rpc/rpc.h>
#include <rpc/xdr.h>
#include <malloc.h>
#include "xhhead.h"
#include "ahhead.h"

extern int xdr_gethead( ), xdr_getdata( ), xdr_putrecord( ), mkdatspace( );

main( argc, argv )
int   argc;
char       *argv[];
{
    float     seism[XH_NPTS];
    float    *data;
    int       index = 0,i,j,k,nstns=0;
    int       still_reading_data = 1;
    int	      ierr;
    int       ntr=0;
    xhhed     xh;
    ahhed     ah;
    XDR       xdrs_in;
    FILE     *ifl, *ofl, *fopen();

    char      dum[4];


if (argc == 3) {
  if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     exit(ierr);
  }
  if ((ofl = fopen(argv[2],"w")) == NULL) {
     ierr = usage();
     exit(ierr);
  }
} else {
  ierr = usage();
  exit(ierr);
}
xdrstdio_create( &xdrs_in, ifl, XDR_DECODE );

while ( xdr_gethead( &ah, &xdrs_in ) == 1 ) {
   fprintf(stdout,"ah_2xh(): NEW TRACE ntr= %d\n", ntr);

   if ( ( data = (float *)mkdatspace( &ah ) ) == (float *)NULL ) {
      fprintf( stderr, "ERROR: memory allocation for trace %d.\n", ntr + 1 );
      exit( -1 );
   }
   if( xdr_getdata( &ah, (char *)data, &xdrs_in ) == -1 ) {
      fprintf( stderr, "ERROR: can't read trace %d.\n", ntr + 1 );
      exit( -1 );
   }

   fprintf(stdout,"ah_2xh(): STATION= -%s- CHAN= -%s-\n",ah.station.code,ah.station.chan);
   // setting deafult values
   if (! xh_setdefaults(&xh) )
     fprintf(stderr,"Error running xh_setdefaults()\n");

   fprintf(stdout,"ah_2xh(): STATION= -%s- CHAN= -%s-\n",ah.station.code,ah.station.chan);

   // Copying data
   for(k=0; k< ah.record.ndata; k++) 
      seism[k] = data[k];

   // Copying stationname name
   if (! iswhite(ah.station.code, &k) ) {
     fprintf(stderr,"Error in isunderscore() .... \n");
     exit(0);
   }
   if (k < 6) {
     strcpy(xh.stnm,ah.station.code);
   } else {
     fprintf(stderr,"AH KSTNM= --%s-- length= %d ... \n", ah.station.code, k);
     exit(0);
   }
   // Copying channel name
   if (! iswhite(ah.station.chan, &k) ) {
     fprintf(stderr,"Error in iswhite() .... \n");
     exit(0);
   }
   if (k < 4) {
     strcpy(xh.chan,ah.station.chan);
   } else {
     fprintf(stderr,"AH CHANM Name %s too long ... \n", ah.station.chan);
     exit(0);
   }

   if (strncmp(xh.chan,"BHZ",3) == 0) xh.chid=1;
   if (strncmp(xh.chan,"LHZ",3) == 0) xh.chid=1;
   if (strncmp(xh.chan,"VHZ",3) == 0) xh.chid=1;
   if (strncmp(xh.chan,"BHN",3) == 0) xh.chid=2;
   if (strncmp(xh.chan,"LHN",3) == 0) xh.chid=2;
   if (strncmp(xh.chan,"VHN",3) == 0) xh.chid=2;
   if (strncmp(xh.chan,"BHE",3) == 0) xh.chid=3;
   if (strncmp(xh.chan,"LHE",3) == 0) xh.chid=3;
   if (strncmp(xh.chan,"VHE",3) == 0) xh.chid=3;
   if (strncmp(xh.chan,"BHR",3) == 0) xh.chid=4;
   if (strncmp(xh.chan,"LHR",3) == 0) xh.chid=4;
   if (strncmp(xh.chan,"VHR",3) == 0) xh.chid=4;
   if (strncmp(xh.chan,"BHL",3) == 0) xh.chid=4;
   if (strncmp(xh.chan,"LHL",3) == 0) xh.chid=4;
   if (strncmp(xh.chan,"VHL",3) == 0) xh.chid=4;
   if (strncmp(xh.chan,"BHT",3) == 0) xh.chid=5;
   if (strncmp(xh.chan,"LHT",3) == 0) xh.chid=5;
   if (strncmp(xh.chan,"VHT",3) == 0) xh.chid=5;
   xh.slat = ah.station.slat;
   xh.slon = ah.station.slon;
   xh.elev = ah.station.elev;
   
   xh.elat = ah.event.lat;
   xh.elon = ah.event.lon;
   xh.edep = ah.event.dep;
   
   // trace start time time
   xh.tstart.yr  = ah.record.abstime.yr;
   xh.tstart.mo  = ah.record.abstime.mo;
   xh.tstart.day = ah.record.abstime.day;
   xh.tstart.hr  = ah.record.abstime.hr;
   xh.tstart.mn  = ah.record.abstime.mn;
   xh.tstart.sec = ah.record.abstime.sec;
   
   // origin time
   xh.ot.yr  = ah.event.ot.yr;
   xh.ot.mo  = ah.event.ot.mo;
   xh.ot.day = ah.event.ot.day;
   xh.ot.hr  = ah.event.ot.hr;
   xh.ot.mn  = ah.event.ot.mn;
   xh.ot.sec = ah.event.ot.sec;
   
   xh.ndata  = ah.record.ndata;
   xh.delta  = ah.record.delta;
   
   for(i=0; i<NOCALPTS; i++) {
     xh.pole[i].r = ah.station.cal[i].pole.r;
     xh.pole[i].i = ah.station.cal[i].pole.i;
     xh.zero[i].r = ah.station.cal[i].zero.r;
     xh.zero[i].i = ah.station.cal[i].zero.i;
   }
   
   xh.DS     = ah.station.DS;
   xh.A0     = ah.station.A0;
   
   
   fprintf(stdout,"%d: --%s--%s--%s-- %5.1f %6.1f",ntr+1,xh.stnm,xh.netw,xh.chan,xh.slat,xh.slon);
   fprintf(stdout," %5.3f %d locc= %d\n",xh.delta,xh.ndata,xh.locc);
   
   
   // WRITE XH header and data
   if (! xh_writehead(ofl,xh)) {
     fprintf(stderr,"Error writing XH head ...\n");
     exit (-1);
   }
   if (! xh_writedata(ofl,xh,seism)) {
     fprintf(stderr,"Error writing XH data ...\n");
     exit (-1);
   }
   
   ntr++;
   } 
fclose(ofl);
exit( 0 );
}

int usage()
{
fprintf(stderr,"Usage: ah_2xh in_AH out_AH\n");
return(-1);
}
