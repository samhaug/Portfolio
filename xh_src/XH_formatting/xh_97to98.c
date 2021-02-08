#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <sys/param.h>
#include "xhhead97m.h"
#include "xhhead.h"	/* XH format structures */

// #include "xh_functions.h"


/* Reads the XH 0.97 version and writes XH 0.98 version */


int main(argc,argv)
    int argc;
    char *argv[];
    {
    xhhed97	h97;
    xhhed  	h98;

int 	icount=1;
int 	i, ierr;

int still_reading_data = 1;
float seism[XH_NPTS];

FILE *ifl, *ofl, *fopen();

int bRead;
int usage();

//int xh_checkheader97();

if ((ifl = fopen(argv[1],"r")) == NULL) {
   ierr = usage();
   return(ierr);
}
if ((ofl = fopen(argv[2],"w")) == NULL) {
   ierr = usage();
   return(ierr);
}

while (still_reading_data) {
  if   (! xh_readhead97(ifl,&h97)) {
    still_reading_data = 0;
    exit(0);
  } else {
    if (! xh_readdata97(ifl,h97,seism)) {
      still_reading_data = 0;
      exit(0);
    }
  }
  // check header:
  if (! xh_checkheader97(h97) )
      exit(-1);


//fprintf(stdout,"XH97 version= %f\n", h97.version);
//fprintf(stdout,"XH97 elat= %f elon= %f edep= %f\n",h97.elat,h97.elon,h97.edep);
  // Filling in the XH header for the 0.98 version
  h98.version = 0.98;
  h98.nhdr    = 1024;
  h98.i12345678 = I_12345678;
  h98.f12345678 = F_12345678;
//fprintf(stdout,"XH97 slat= %f slon= %f elev= %f\n",h97.slat,h97.slon,h97.elev);

  h98.elat = h97.elat;
  h98.elon = h97.elon;
  h98.edep = h97.edep;
  h98.slat = h97.slat;
  h98.slon = h97.slon;
  h98.elev = h97.elev;

  h98.Mb   = h97.Mb;
  h98.Ms   = h97.Ms;
  h98.Mw   = h97.Mw;

  h98.azim = h97.azim;
  h98.incl = h97.incl;

  h98.ot.yr      = h97.ot.yr;
  h98.ot.mo      = h97.ot.mo;
  h98.ot.day     = h97.ot.day;
  h98.ot.hr      = h97.ot.hr;
  h98.ot.mn      = h97.ot.mn;
  h98.ot.sec     = h97.ot.sec;
//fprintf(stdout,"XH97 OT= %d/%d/%d\n",h97.ot.yr,h97.ot.mo,h97.ot.day);
  h98.tstart.yr  = h97.tstart.yr;
  h98.tstart.mo  = h97.tstart.mo;
  h98.tstart.day = h97.tstart.day;
  h98.tstart.hr  = h97.tstart.hr;
  h98.tstart.mn  = h97.tstart.mn;
  h98.tstart.sec = h97.tstart.sec;
//fprintf(stdout,"XH97 TS= %d:%d:%f\n",h97.tstart.hr,h97.tstart.mn,h97.tstart.sec);

  h98.ndata  = h97.ndata;
  h98.delta  = h97.delta;
  h98.tshift = h97.tshift;
  h98.maxamp = h97.maxamp;
  h98.qual   = h97.qual;
  h98.chid   = h97.chid;
  h98.locc   = h97.locc;
//fprintf(stdout,"XH97 Ndata= %d locc= %d\n",h97.ndata, h97.locc);

  for (i=0;i<NOCALPTS;i++) {
     h98.pole[i].r = h97.pole[i].r;
     h98.pole[i].i = h97.pole[i].i;
     h98.zero[i].r = h97.zero[i].r;
     h98.zero[i].i = h97.zero[i].i;
  }

  h98.DS   = h97.DS;
  h98.A0   = h97.A0;

  strcpy(h98.evtcd,h97.evtcd);
  strcpy(h98.cmtcd,h97.cmtcd);
  strcpy(h98.netw,h97.netw);
  strcpy(h98.stnm,h97.stnm);
  strcpy(h98.chan,h97.chan);
  strcpy(h98.rcomment,h97.rcomment);
  strcpy(h98.wavf,h97.wavf);
//fprintf(stdout,"XH97 cmt= %s stnm= %s chann= %s\n",h97.evtcd, h97.stnm, h97.chan);
//fprintf(stdout,"XH97 cmt= %s stnm= %s chann= %s wavf= %s\n",h97.evtcd,h97.stnm,h97.chan,h97.wavf);
//fprintf(stdout,"XH97 rcomment= %s\n",h97.rcomment);

  for (i=0;i<20;i++) {
    h98.tpcks[i] = h97.tpcks[i];
    h98.flt[i]   = h97.flt[i];
    h98.intg[i]  = h97.intg[i];
//  fprintf(stdout,"XH97 i=%2d tpcks= %f\n",i,h97.tpcks[i]);
//  fprintf(stdout,"XH97 i=%2d flt= %f\n",i,h97.flt[i]);
//  fprintf(stdout,"XH97 i=%2d intg= %d\n",i,h97.intg[i]);
  }
  

//  fprintf(stdout,"%-3d xh%4.2f %3.0fkm %s %s %s %d %3.0f %3.0f ",
//       icount,h97.version,h97.edep,h97.stnm,h97.netw,h97.chan,h97.chid,h97.azim,h97.incl);
//  fprintf(stdout,"%6d  %5.3f %s %d ",
//       h97.ndata,h97.delta,h97.wavf,h97.qual);
//  fprintf(stdout,"\n");  
  icount++;

  if (! xh_writehead(ofl,h98))
      exit(-1);
  if (! xh_writedata(ofl,h98, seism))
    exit(-1);

} // while

fclose(ifl);
}

int usage(flnm)
char *flnm;
{
fprintf(stderr,"Usage: xh_97to98 in_XH out_XH\n");
return(-1);
}
