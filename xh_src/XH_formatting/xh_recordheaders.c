//
// xh_recordheaders
//
// prepares the file RECORDHEADERS
// This list is used as input for QmXD
//
// J. Ritsema, Univ. Michigan, October 2006.


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <malloc.h>

#include "xhhead.h"
#include "ndk.h"
#include "time.h"

main( argc, argv )
int   argc;
char       *argv[];
{
    float     data[XH_NPTS];
    // Station burial ... not used ...
    float     stbur = 0.;
    int       still_reading_data = 1;
    int	      ierr;
    int       index;
    int       numsamp = 4096;
    int       jday;
    xhhed     h;
    cmthed    h_cmt;
    xh_time   tm1, tm2;
    FILE     *xhfl, *cmt, *fopen();

    char  CMTCATALOG[130];
    // CMT code
    char  code[7];

if (argc != 6) {
  ierr = usage();
  exit(ierr);
}

// XH data file
if ((xhfl=fopen(argv[1],"r")) == NULL) {
     ierr=usage();
     exit(-1);
}
index = 1;
while ( ++index < argc && argv[index][0] == '-' ) {
  switch ( argv[index][1] ) {
     case 'n':
        // number of samples
        if ( sscanf( argv[++index], "%d", &numsamp ) != 1) {
             usage(-1);
        }
        break;
     case 'c':
        // cmt code
        if ( sscanf( argv[++index], "%s", code ) != 1) {
             usage(-1);
        }
        break;
     default:
        ierr = usage();
        exit(ierr);
  }
}

// CMT catalog
sprintf(CMTCATALOG,"%s","/work/jeroen/Utils/CMT_catalog/cmt.bin");
if ((cmt = fopen(CMTCATALOG, "r"))==NULL) {
  fprintf(stderr,"\n\nError opening %s\n",CMTCATALOG);
  fprintf(stderr,"Exiting !! \n");
  exit(-1);
}
fread(&h_cmt,sizeof(h_cmt),1,cmt);
while (strncmp(h_cmt.evtcd,code,7) != 0) {
  fread(&h_cmt,sizeof(h_cmt),1,cmt);
}
// fprintf(stdout,"%c- %s %14s %04d/%02d/%02d %02d:%02d:%04.1f",
//                  h_cmt.cmtcddata,h_cmt.evtcd,h_cmt.cmtcd,
//                  h_cmt.cat.yr,h_cmt.cat.mo,h_cmt.cat.day,h_cmt.cat.hr,h_cmt.cat.mn,h_cmt.cat.sec);
// fprintf(stdout," lat= %6.2f lon= %7.2f H= %5.1f [%.3s]",
//                  h_cmt.cat.lat,h_cmt.cat.lon,h_cmt.cat.dep,h_cmt.depcnstr);
// fprintf(stdout," Mb= %3.1f ",h_cmt.mb);
// fprintf(stdout," %s\n",h_cmt.region);


// Loop over traces in xhfl
while (still_reading_data) {
  if    (! xh_readhead(xhfl,&h)) {
     still_reading_data=0;
     break;
  } else {
     if (! xh_readdata(xhfl,h,data)) {
       still_reading_data=0;
       exit(-1);
     }
     // check header
     if (! xh_checkheader(h) )
       exit(-1);
     // Make sure the recordings are for the CMT event defined by "CODE"
     if (strncmp(h.evtcd,code,7) != 0) {
       fprintf(stderr,"Error: CMT code in data --%.7s-- is not CODE --%.7s--\n", h.evtcd,code);
       exit(-1);
     }
     // Make sure the recordings have a dt = 1.0 s
     if (fabs(1.0-h.delta) > 0.00001) {
       fprintf(stderr,"Error: Deltat in data --%f-- is not 1 sec\n", h.delta);
       exit(-1);
     }
  }


  if (h.chan[2] == 'Z' && h.chid == 1) {
    // find the centroid time
    tm1.yr  = h.ot.yr;
    tm1.mo  = h.ot.mo;
    tm1.day = h.ot.day;
    tm1.hr  = h.ot.hr;
    tm1.mn  = h.ot.mn;
    tm1.sec = h.ot.sec;
    if (! timadd(tm1,h_cmt.centroid_time,&tm2))
      fprintf(stderr,"Error in timadd ...\n");
    if (! dat2jday(tm2.yr,tm2.mo,tm2.day,&jday))
      fprintf(stderr,"Error in tim2jday ...\n");

    // lhz
    fprintf(stdout,
      "%-8s %-5s LHZ      %8.4f %9.4f %6.1f %6.1f   0.0  -90.0       1.0000    %4d %04d %03d %02d %02d %6.3f\n",
        h.stnm,h.netw,h.slat,h.slon,h.elev,stbur,numsamp, tm2.yr,jday,tm2.hr,tm2.mn,tm2.sec);
    // lhe
    fprintf(stdout,
      "%-8s %-5s LHN      %8.4f %9.4f %6.1f %6.1f   0.0    0.0       1.0000    %4d %04d %03d %02d %02d %6.3f\n",
        h.stnm,h.netw,h.slat,h.slon,h.elev,stbur,numsamp, tm2.yr,jday,tm2.hr,tm2.mn,tm2.sec);
    // lhn
    fprintf(stdout,
      "%-8s %-5s LHE      %8.4f %9.4f %6.1f %6.1f  90.0    0.0       1.0000    %4d %04d %03d %02d %02d %6.3f\n",
        h.stnm,h.netw,h.slat,h.slon,h.elev,stbur,numsamp, tm2.yr,jday,tm2.hr,tm2.mn,tm2.sec);
  }
}

exit( 0 );
} 

int usage()
{
fprintf(stderr,"Usage: xh_recordheaders in_XH -n numsamp -c CMTcode\n");
return(-1);
}
