/*-----------------------------
 read SAC file
-----------------------------*/
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>

#include "xhhead.h"     /* XH format structures */
#include "time.h"       /* TIME structures */
#include "sac.h"        /* SAC format structures */

int xh_readsac(xh,seism,sacfile,useful)
xhhed     *xh;
float seism[];
char *sacfile;
int *useful;
{
struct   sac_header sh;
FILE 	*sacf, *fopen();
int 	 k;
xhhed     h;
xh_time   ts1, ts2;

// defaults:
strcpy(h.evtcd,"000000A");
h.version= X_VERSION;
if (sizeof(h) != X_HDRSIZE) {
  fprintf(stderr,"Inconsistent HEADER SIZE !!!!\n");
  h.nhdr= -99;
} else {
  h.nhdr= X_HDRSIZE;
}
strcpy(h.netw,"XX");
strcpy(h.wavf,"raw");
h.maxamp= 0.0;
h.tshift= 0.0;
h.qual = 0.;
strncpy(h.rcomment,"null",4);

h.DS= 0.0;
h.A0= 0.0;
for(k=0; k< NOCALPTS; ++k)
{
 h.pole[k].r= 0.0;
 h.pole[k].i= 0.0;
 h.zero[k].r= 0.0;
 h.zero[k].i= 0.0;
}

if ( (sacf=fopen(sacfile,"r")) == NULL) 
   fprintf(stderr,"Error opening %s\n", sacfile);
*useful = 1;

fread(&sh,sizeof(struct sac_header),1,sacf);
if (sh.depmax == 0.) *useful = 0;
if (sh.depmin == 0.) *useful = 0;
fread(&seism[0],sh.npts*sizeof(float),1,sacf);

/* ABSOLUTE BEGIN TIME */
h.tstart.yr = sh.nzyear;
k=jday2dat(sh.nzyear, sh.nzjday, &h.tstart.mo, &h.tstart.day);
h.tstart.hr = sh.nzhour;
h.tstart.mn = sh.nzmin;
h.tstart.sec = sh.nzsec*1.0 + sh.nzmsec/1000.;
/* Begin time added to fix FK synthetics ....*/
h.tstart.sec = h.tstart.sec + sh.b; 
                                                               
h.ot.yr=  (short)1970;
h.ot.mo=  (short)1;
h.ot.day= (short)1;
h.ot.hr=  (short)0;
h.ot.mn=  (short)0;
h.ot.sec=  0.0;
fprintf(stdout,"KKK nzyear = %d\n", sh.nzyear);
fprintf(stdout,"KKK beg = %f\n", sh.b);
if (h.tstart.yr < 1970) {
  h.tstart.yr=  (short)1970;
  h.tstart.mo=  (short)1;
  h.tstart.day= (short)1;
  h.tstart.hr=  (short)0;
  h.tstart.mn=  (short)0;
  h.tstart.sec=  0.0;
}
// copy tstart into ts1
if (! xh_copytime_ts(&ts1,h))
  fprintf(stderr,"Error in xh_copytime_ts()\n");
// add beg to ts1
if (! timadd(ts1,sh.b,&ts2))
  fprintf(stderr,"Error in xh_copytime_ts()\n");
fprintf(stdout,"begin time= %f\n", sh.b);
fprintf(stdout,"ts2 yr = %d/%d/%d %d:%d:%4.1f\n", ts2.yr,ts2.mo,ts2.day,ts2.hr,ts2.mn,ts2.sec);
h.tstart.yr=  ts2.yr;
h.tstart.mo=  ts2.mo;
h.tstart.day= ts2.day;
h.tstart.hr=  ts2.hr;
h.tstart.mn=  ts2.mn;
h.tstart.sec= ts2.sec;

/* SAMPLING INTERVAL, NUMBER OF POINTS */
h.delta = sh.delta;
h.ndata = sh.npts;

/* SOURCE and STATION info */
h.elat = sh.evla;
h.elon = sh.evlo;
h.edep = sh.evdp;
if (h.edep > 800.) {
  h.edep = h.edep / 1000.;
  fprintf(stdout,"SAC HEADER Depth= %9.1f --- dividing by 1000\n", sh.evdp);
}
h.slat = sh.stla;
h.slon = sh.stlo;
h.elev = sh.stel;
h.azim = sh.cmpaz;
h.incl = sh.cmpinc;

// fprintf(stdout," In xh_readsac() kstnm= --%s-- \n", sh.kstnm);

if (! iswhite(sh.kstnm, &k) ) {
  fprintf(stderr,"Error in iswhite() .... \n");
  return(0);
}
// fprintf(stdout," In xh_readsac() k= --%d-- \n", k);
if (k > 6) {
  fprintf(stderr,"SAC KSTNM Name %s too long ... \n", sh.kstnm);
  return(0);
}
if (k == 1) strncpy(h.stnm,sh.kstnm,1);
if (k == 2) strncpy(h.stnm,sh.kstnm,2);
if (k == 3) strncpy(h.stnm,sh.kstnm,3);
if (k == 4) strncpy(h.stnm,sh.kstnm,4);
if (k == 5) strncpy(h.stnm,sh.kstnm,5);
h.stnm[k] = '\0';

if (! iswhite(sh.kcmpnm, &k) ) {
  fprintf(stderr,"Error in iswhite() .... \n");
  return(0);
}
if (k > 6) {
  fprintf(stderr,"SAC KCMPNM Name %s too long ... \n", sh.kstnm);
  return(0);
}
if (k == 1) strncpy(h.chan,sh.kcmpnm,1);
if (k == 2) strncpy(h.chan,sh.kcmpnm,2);
if (k == 3) strncpy(h.chan,sh.kcmpnm,3);
if (k == 4) strncpy(h.chan,sh.kcmpnm,4);
if (k == 5) strncpy(h.chan,sh.kcmpnm,5);
h.chan[k] = '\0';

// strcpy(h.stnm,sh.kstnm);
// strcpy(h.chan,sh.kcmpnm);

h.chid = 0;
// EXCIT has LHL output; I prefer LHR ...
if ( h.chan[2] == 'L') h.chan[2] = 'R';

if  ( h.chan[2] != 'N' && h.chan[2] != 'E' && h.chan[2] != 'Z' && h.chan[2] != 'R' && h.chan[2] != 'T') {
  if        ( h.chan[2] == '1' || h.chan[2] == '5' ) {
     h.chan[2] = 'N';
  } else if ( h.chan[2] == '2' || h.chan[2] == '6' ) {
     h.chan[2] = 'E';
  } else {
     fprintf(stderr,"xh_readsac() ... Unknown CHANNEL: %s %s\n", h.stnm, h.chan);
     return(0);
  }
}

if ( strncmp(h.chan,"BHZ",3)==0 || strncmp(h.chan,"LHZ",3)== 0 ) h.chid = 1;
if ( strncmp(h.chan,"BHN",3)==0 || strncmp(h.chan,"LHN",3)== 0 ) h.chid = 2;
if ( strncmp(h.chan,"BHE",3)==0 || strncmp(h.chan,"LHE",3)== 0 ) h.chid = 3;
if ( strncmp(h.chan,"BHR",3)==0 || strncmp(h.chan,"LHR",3)== 0 ) h.chid = 4;
if ( strncmp(h.chan,"BHT",3)==0 || strncmp(h.chan,"LHT",3)== 0 ) h.chid = 5;

/* TIME PICKS */
if (fabs(sh.t0) > sh.delta) h.tpcks[0] = sh.t0;
if (fabs(sh.t1) > sh.delta) h.tpcks[1] = sh.t1;
if (fabs(sh.t2) > sh.delta) h.tpcks[2] = sh.t2;
if (fabs(sh.t3) > sh.delta) h.tpcks[3] = sh.t3;
if (fabs(sh.t4) > sh.delta) h.tpcks[4] = sh.t4;
if (fabs(sh.t5) > sh.delta) h.tpcks[5] = sh.t5;
if (fabs(sh.t6) > sh.delta) h.tpcks[6] = sh.t6;
if (fabs(sh.t7) > sh.delta) h.tpcks[7] = sh.t7;
if (fabs(sh.t8) > sh.delta) h.tpcks[8] = sh.t8;
if (fabs(sh.t9) > sh.delta) h.tpcks[9] = sh.t9;

// fprintf(stdout,"xh_readsac() %s.%s.%s %5.1f %6.1f\n",h.stnm,h.netw,h.chan,h.slat,h.slon);
// fprintf(stdout," %5.3f %d %s %5.1f %6.1f %3.0fkm\n",h.delta,h.ndata,h.evtcd,h.elat,h.elon,h.edep);

fclose(sacf);

*xh = h;

return(1);
}
