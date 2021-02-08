#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <sys/param.h>
#include "/geo/home/jritsema/inc/xhhead0.97.h"

// Rewrites the head to fix "loose" characters in the strings


main(argc,argv)
int argc;
char *argv[];
{
xhhed	h_old;
xhhed  	h_new;

int 	icount=1;
int 	i, ierr;

int still_reading_data = 1;
float seism[XH_NPTS];

FILE *ifl, *ofl, *fopen();

int bRead;
int usage();

if ((ifl = fopen(argv[1],"r")) == NULL) {
   ierr = usage();
   return(ierr);
}
if ((ofl = fopen(argv[2],"w")) == NULL) {
   ierr = usage();
   return(ierr);
}

while (still_reading_data) {
  bRead = fread(&h_old,1,1024,ifl);
  if (bRead != 1024) {
    if (bRead != 0) {
      fprintf(stderr,"xh_readhead() error ... bRead= %d\n", bRead);
    } else {
      fprintf(stdout,"EOF reached ... \n");
    }
    exit(-1);
  }
  if ( fabsf(h_old.version-0.97) > 0.01) {
    fprintf(stderr,"FILE version of XH-file (=%f) is not 0.97 ... \n", h_old.version);
    exit(-1);
  }

  if (fread(seism,sizeof(float),h_old.ndata,ifl) != h_old.ndata) {
    fprintf(stderr,"ERROR reading XH data stat=%s chan=%s\n",h_old.stnm,h_old.chan);
    fprintf(stderr,"h_old.ndata= %d\n", h_old.ndata);
    exit(-1);
  } 

  // Filling in the XH header for the 0.97 version
  h_new.version = 0.97;
  h_new.nhdr    = 1024;
  h_new.i12345678 = I_12345678;
  h_new.f12345678 = F_12345678;

  h_new.elat = h_old.elat;
  h_new.elon = h_old.elon;
  h_new.edep = h_old.edep;
  h_new.slat = h_old.slat;
  h_new.slon = h_old.slon;
  h_new.elev = h_old.elev;

  h_new.Mb   = h_old.Mb;
  h_new.Ms   = h_old.Ms;
  h_new.Mw   = h_old.Mw;

  h_new.azim = h_old.azim;
  h_new.incl = h_old.incl;

  h_new.ot     = h_old.ot;
  h_new.tstart = h_old.tstart;

  h_new.ndata  = h_old.ndata;
  h_new.delta  = h_old.delta;
  h_new.tshift = h_old.tshift;
  h_new.maxamp = h_old.maxamp;
  h_new.qual   = h_old.qual;
  h_new.chid   = h_old.chid;
  h_new.locc   = 9;

  for (i=0;i<NOCALPTS;i++) {
     h_new.pole[i].r = h_old.pole[i].r;
     h_new.pole[i].i = h_old.pole[i].i;
     h_new.zero[i].r = h_old.zero[i].r;
     h_new.zero[i].i = h_old.zero[i].i;
  }

  h_new.DS   = h_old.DS;
  h_new.A0   = h_old.A0;

  strcpy(h_new.evtcd,h_old.evtcd);
  strcpy(h_new.cmtcd,h_old.cmtcd);
  strcpy(h_new.netw,h_old.netw);
  strcpy(h_new.stnm,h_old.stnm);
  strcpy(h_new.chan,h_old.chan);
  strcpy(h_new.rcomment,h_old.rcomment);
  strcpy(h_new.wavf,h_old.wavf);

  for (i=0;i<20;i++) {
    h_new.tpcks[i] = h_old.tpcks[i];
    h_new.flt[i]   = h_old.flt[i];
    h_new.intg[i]  = h_old.intg[i];
  }
  

  fprintf(stdout,"%-3d xh%4.2f %3.0fkm -%s- -%s- -%s- %d %3.0f %3.0f ",
       icount,h_old.version,h_old.edep,h_old.stnm,h_old.netw,h_old.chan,h_old.chid,h_old.azim,h_old.incl);
  fprintf(stdout,"%6d  %5.3f -%s- %d ",
       h_old.ndata,h_old.delta,h_old.wavf,h_old.qual);
  fprintf(stdout,"\n");  
  icount++;

  if (! xh_writehead(ofl,h_new))
      exit(-1);
  if (! xh_writedata(ofl,h_new, seism))
    exit(-1);

} // while

fclose(ifl);
}

int usage(flnm)
char *flnm;
{
fprintf(stderr,"Usage: xh_2xh in_XH out_XH\n");
return(-1);
}
