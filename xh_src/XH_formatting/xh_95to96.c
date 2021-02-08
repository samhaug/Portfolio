#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "/work/jeroen/inc/xhhead0.96.h"
#include "/work/jeroen/inc/xhhead0.95.h"	/* XH format structures */

/* Reads the XH 0.95 version and writes XH 0.96 version */


main(argc,argv)
int argc;
char *argv[];
{
xhhed95	h_old;
xhhed  	h_new;

int 	icount=1;
int 	i, ierr;

int still_reading_data = 1;
float seism[XH_NPTS_95];

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
  if (fread(seism,sizeof(float),h_old.ndata_95,ifl) != h_old.ndata_95) {
    fprintf(stderr,"ERROR reading XH data stat=%s chan=%s\n",h_old.stnm_95,h_old.chan_95);
    fprintf(stderr,"h_old.ndata= %d\n", h_old.ndata_95);
    exit(-1);
  } 

  // Filling in the XH header for the 0.96 version
  h_new.version = 0.96;
  h_new.nhdr    = 1024;
  h_new.i12345678 = I_12345678;
  h_new.f12345678 = F_12345678;

  h_new.elat = h_old.elat_95;
  h_new.elon = h_old.elon_95;
  h_new.edep = h_old.edep_95;
  h_new.slat = h_old.slat_95;
  h_new.slon = h_old.slon_95;
  h_new.elev = h_old.elev_95;

  h_new.Mb   = h_old.magn_95;

  h_new.azim = h_old.azim_95;
  h_new.incl = h_old.incl_95;

  h_new.ot     = h_old.ot_95;
  h_new.tstart = h_old.tstart_95;

  h_new.ndata  = h_old.ndata_95;
  h_new.delta  = h_old.delta_95;
  h_new.tshift = h_old.tshift_95;
  h_new.maxamp = h_old.maxamp_95;
  h_new.qual   = h_old.qual_95;
  h_new.chid   = h_old.chid_95;

  for (i=0;i<NOCALPTS;i++) {
     h_new.pole[i].r = h_old.pole_95[i].r;
     h_new.pole[i].i = h_old.pole_95[i].i;
     h_new.zero[i].r = h_old.zero_95[i].r;
     h_new.zero[i].i = h_old.zero_95[i].i;
  }

  h_new.DS   = h_old.DS_95;
  h_new.A0   = h_old.A0_95;

  strcpy(h_new.evtcd,h_old.cmtcd_95);
  strcpy(h_new.cmtcd,h_old.cmtcd_95);
  strcpy(h_new.netw,h_old.netw_95);
  strcpy(h_new.stnm,h_old.stnm_95);
  strcpy(h_new.chan,h_old.chan_95);
  strcpy(h_new.rcomment,h_old.rcomment_95);
  strcpy(h_new.wavf,h_old.wavf_95);

  for (i=0;i<NPCKS;i++) {
    h_new.tpcks[i] = h_old.tpcks_95[i];
  }

  fprintf(stdout,"%-3d xh%4.2f %3.0fkm %-4s %-2s %-3s %d %3.0f %3.0f ",
         icount,h_old.version_95,h_old.edep_95,h_old.stnm_95,h_old.netw_95,h_old.chan_95,h_old.chid_95,h_old.azim_95,h_old.incl_95);
  fprintf(stdout,"%6d  %5.3f %s %d ",
         h_old.ndata_95,h_old.delta_95,h_old.wavf_95,h_old.qual_95);
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
fprintf(stderr,"Usage: xh_95to96 in_XH out_XH\n");
return(-1);
}
