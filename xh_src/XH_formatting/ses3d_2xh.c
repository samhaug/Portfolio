//
// ses3d_2xh - Turn SAC into XH 
//
// Primarily used to write the ASCII from Andreas Fichtner SED3d simulations into XH 
// I am assuming that the instruments have already been taken out



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
    int	      ierr;
    int       jdebug = 1;
    int       i;
    xhhed     h;
    char      stnam[CHARSIZE];
    char      chnam[CHARSIZE];
    char      ss[120];
    char      text[20];
    char      location[3];
    char      ses3dfile[80];
    FILE     *ifl, *ofl, *fopen();


if (argc != 5) {
   ierr = usage();
   exit(ierr);
}
strcpy(ses3dfile,argv[1]);
if ((ofl = fopen(argv[2],"w")) == NULL) {
   ierr = usage();
   exit(ierr);
}
index = 2;
while ( ++index < argc && argv[index][0] == '-' ) {
  switch ( argv[index][1] ) {
     case 's':
        // station code
        if ( sscanf( argv[++index], "%s", stnam ) != 1) {
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
if (jdebug) {
  //fprintf(stdout,"\n-----ses3d_2xh()------\n");
  //fprintf(stdout,"ses3dfile= %s    stnam= %s\n", ses3dfile,stnam);
  fprintf(stdout,"%s ", ses3dfile);
}

// Fichtner network
strcpy(h.netw,"FI");
// stnam from command line
strcpy(h.stnm,stnam);

// Read the ASC file
if ((ifl = fopen(ses3dfile,"r")) == NULL) {
   ierr = usage();
   exit(ierr);
}
// line 1: component
fgets(ss,120,ifl);
sscanf(ss,"%s", text);
if        ( strncmp(text,"phi",3)   == 0) {
   strcpy(h.chan,"BHE");
   h.azim = 90.;
   h.incl = 90.;
   h.chid = 3;
} else if ( strncmp(text,"theta",5) == 0) {
   strcpy(h.chan,"BHN");
   h.azim = 0.;
   h.incl = 90.;
   h.chid = 2;
} else if ( strncmp(text,"r",1)     == 0) {
   strcpy(h.chan,"BHZ");
   h.azim = 0.;
   h.incl = 0.;
   h.chid = 1;
} else {
   fprintf(stderr,"Component --%s-- not recognized ...\n", text);
   exit(-1);
}
// line 2: number of samples
fgets(ss,120,ifl);
sscanf(ss,"%s %d", text, &h.ndata);
if        ( strncmp(text,"nt=",3)   == 0) {
} else {
   fprintf(stderr,"Number of samples --%s-- not recognized ...\n", text);
   exit(-1);
}
// line 3: deltat
fgets(ss,120,ifl);
sscanf(ss,"%s %f", text, &h.delta);
if        ( strncmp(text,"dt=",3)   == 0) {
} else {
   fprintf(stderr,"sampling time --%s-- not recognized ...\n", text);
   exit(-1);
}
// line 4 and 5 receiver location
fgets(ss,120,ifl);
sscanf(ss,"%s", text);
if        ( strncmp(text,"receiver",8)   == 0) {
} else {
   fprintf(stderr,"Receiver location --%s-- not recognized ...\n", text);
   exit(-1);
}
fgets(ss,120,ifl);
sscanf(ss,"%s %f %*s %f %*s %f", text, &h.slat, &h.slon, &h.elev);
// colatitude --> latitude
h.slat = 90. - h.slat;
// receiver depth is given so depth --> elevation
h.elev =  -h.elev;
if        ( strncmp(text,"x=",2)   == 0) {
} else {
   fprintf(stderr,"Receiver location --%s-- not recognized ...\n", text);
   exit(-1);
}
// line 6 and 7 source location
fgets(ss,120,ifl);
sscanf(ss,"%s", text);
if        ( strncmp(text,"source",6)   == 0) {
} else {
   fprintf(stderr,"Source location --%s-- not recognized ...\n", text);
   exit(-1);
}
fgets(ss,120,ifl);
sscanf(ss,"%s %f %*s %f %*s %f", text, &h.elat, &h.elon, &h.edep);
// colatitude --> latitude
h.elat = 90. - h.elat;
// depth in km
h.edep = h.edep/1000.;
if        ( strncmp(text,"x=",2)   == 0) {
} else {
   fprintf(stderr,"Source location --%s-- not recognized ...\n", text);
   exit(-1);
}

// READING THE DATA
for (i=0; i<h.ndata; i++) {
  fgets(ss,120,ifl);
  sscanf(ss,"%f", &seism[i]);
  // flip the N record
  if ( h.chid == 2 ) seism[i] = -seism[i];
}


if (jdebug) {
  //fprintf(stdout,"ot= %4d/%02d/%02d ", h.ot.yr,h.ot.mo,h.ot.day);
  //fprintf(stdout,"%02d:%02d:%5.2f\n",  h.ot.hr,h.ot.mn,h.ot.sec);
  //fprintf(stdout,"st= %4d/%02d/%02d ", h.tstart.yr,h.tstart.mo,h.tstart.day);
  //fprintf(stdout,"%02d:%02d:%5.2f\n",  h.tstart.hr,h.tstart.mn,h.tstart.sec);
  // From command line input:

  h.locc = 9;
  //fprintf(stdout,"--%s-- --%s--  --%s--Locc= %d\n",h.netw,h.stnm,h.chan,h.locc);
  //fprintf(stdout,"SRC: lat= %7.2f  lon= %7.2f=  dept= %7.2f  ", h.elat, h.elon, h.edep);
  //fprintf(stdout,"RCV: lat= %7.2f  lon= %7.2f=  elev= %7.2f  ", h.slat, h.slon, h.elev);
  fprintf(stdout,"SRC: lat= %7.2f  lon= %7.2f   ", h.elat, h.elon);
  fprintf(stdout,"RCV: lat= %7.2f  lon= %7.2f   ", h.slat, h.slon);
  fprintf(stdout,"\n");
  //fprintf(stdout,"DT= %5.2f N= %d\n",h.delta,h.ndata);
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
fprintf(stderr,"Usage: ses3d_2xh in_ses3d out_XH -s STNAME\n");
return(-1);
}
