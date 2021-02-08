/*-----------------------------
 write out new SAC file
-----------------------------*/
#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdlib.h>
#include <sys/param.h>

#include "xhhead.h"     /* XH format structures */
#include "sac.h"        /* SAC format structures */
#include "time.h"       /* TIME format structures */

int xh_writesac(xh,seism,sacfile)
char sacfile[80];
float *seism;
xhhed     xh;
{
struct   sac_header sh;
xh_time  ts, ot;
FILE 	*osac, *fopen();
int 	 k;

ot.yr  = xh.ot.yr;
ot.mo  = xh.ot.mo;
ot.day = xh.ot.day;
ot.hr  = xh.ot.hr;
ot.mn  = xh.ot.mn;
ot.sec = xh.ot.sec;
ts.yr  = xh.tstart.yr;
ts.mo  = xh.tstart.mo;
ts.day = xh.tstart.day;
ts.hr  = xh.tstart.hr;
ts.mn  = xh.tstart.mn;
ts.sec = xh.tstart.sec;

fprintf(stdout,"xh_writesac() sacfile = ---%s---\n", sacfile);
fprintf(stdout,"xh_writesac() sacheadersize = ---%ld---\n", sizeof(sh));

if ( (osac=fopen(sacfile,"w")) == NULL) 
   fprintf(stderr,"Error opening %s\n", sacfile);

/* set some sac header defaults */
sh = sac_null;
sh.internal4 = 6;
sh.internal5 = 0;
sh.internal6 = 0;
sh.iftype = ITIME;
sh.idep = IUNKN;
sh.iztype = IB;
sh.ievtyp = IUNKN;
sh.leven = TRUE;
sh.lpspol = FALSE;
sh.lcalda = TRUE;
sh.unused27 = FALSE;
sh.lovrok   = TRUE;

/* BEGIN TIME, SAMPLING INTERVAL, NUMBER OF POINTS */
// sh.b     = xh.tshift;
sh.b     = 0.;
sh.delta = xh.delta;
sh.npts  = xh.ndata;

/* ABSOLUTE BEGIN TIME */
sh.nzyear = xh.tstart.yr;
k=dat2jday(ts.yr, ts.mo, ts.day ,&sh.nzjday);
sh.nzhour = xh.tstart.hr;
sh.nzmin  = xh.tstart.mn;
sh.nzsec  = floor(xh.tstart.sec);
sh.nzmsec = floor( 1000*(xh.tstart.sec-sh.nzsec) );

/* EARTHQUAKE ORIGIN TIME */
if (! timdif(ot,ts,&sh.o) ) fprintf(stderr,"Error running TIMDIF ...\n");

/* SOURCE and STATION info */
sh.evla   = xh.elat;
sh.evlo   = xh.elon;
sh.evdp   = xh.edep;
sh.stla   = xh.slat;
sh.stlo   = xh.slon;
sh.stel   = xh.elev;
sh.cmpaz  = xh.azim;
sh.cmpinc = xh.incl;
strcpy(sh.kstnm,xh.stnm);
strcpy(sh.kcmpnm,xh.chan);

/* TIME PICKS */
// See ~/inc/xhhead.h
// P pick
if (fabs(xh.tpcks[0]) > sh.delta) sh.t1 = xh.tpcks[0];
// S pick
if (fabs(xh.tpcks[5]) > sh.delta) sh.t2 = xh.tpcks[5];
// ScS pick
if (fabs(xh.tpcks[7]) > sh.delta) sh.t3 = xh.tpcks[7];
// SKS pick
if (fabs(xh.tpcks[8]) > sh.delta) sh.t4 = xh.tpcks[8];
// SKKS pick
if (fabs(xh.tpcks[9]) > sh.delta) sh.t5 = xh.tpcks[9];

// if (fabs(xh.tpcks[5]) > sh.delta) sh.t5 = xh.tpcks[5];
// if (fabs(xh.tpcks[6]) > sh.delta) sh.t6 = xh.tpcks[6];
// if (fabs(xh.tpcks[7]) > sh.delta) sh.t7 = xh.tpcks[7];
// if (fabs(xh.tpcks[8]) > sh.delta) sh.t8 = xh.tpcks[8];

// Put quality factor in T9
// sh.t9 = xh.qual;


//fprintf(stdout,"CMT: %s H=%4.0fkm %4s %3s loc= %6.2f %7.2f\n",xh.evtcd,sh.evdp,sh.kstnm,sh.kcmpnm,sh.stla,sh.stlo);
//fprintf(stdout,"     %4d/%02d/%02d %02d:%02d:%05.2f",xh.tstart.yr,xh.tstart.mo,xh.tstart.day,xh.tstart.hr,xh.tstart.mn,xh.tstart.sec);
//fprintf(stdout,"   O= %8.1fs\n", sh.o);

fwrite(&sh,sizeof(struct sac_header),1,osac);
fwrite(&seism[0],sh.npts*sizeof(float),1,osac);

fclose(osac);

return(1);
}
