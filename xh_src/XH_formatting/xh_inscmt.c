#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"		// XH   structures
#include "ndk.h"		// CMT  structure
#include "time.h"		// TIME structure

// Inserts CMT info into the XH header

int main(argc,argv)
int argc;
char *argv[];
{
xhhed 	h;
int 	icount=1;
int 	i, ierr;
int npoles, nzeros;
int century=1900;

int still_reading_data = 1;
int fill_cmtheader();

cmthed  cmt;
char region[54];
char evtcode[8];
char infile[80];

float seism[XH_NPTS];
float tdiff;

xh_time t1, t2;

FILE *ifl, *ofl, *fopen();

int usage();

if(argc != 5) usage();
if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     return(ierr);
}
if ((ofl = fopen(argv[2],"w")) == NULL) {
     ierr = usage();
     return(ierr);
}
if (strncmp(argv[3],"-c",2) != 0) {
     ierr = usage();
     return(ierr);
} else {
  ierr = iswhite(argv[4],&i);
  if (i != 7) {
     ierr = usage();
     return(ierr);
  }
  strcpy(evtcode,argv[4]);
}

/*-- GET CMT info ------------------- */
memset(region,0,sizeof(region));
if (! fill_cmtheader(evtcode,&cmt)) {
  fprintf(stderr,"CMT: %s not in CMT.bin ...\n",evtcode);
  exit(-1);
}
strcpy(region,cmt.region);

while (still_reading_data) {
  if   (! xh_readhead(ifl,&h)) {
    still_reading_data = 0;
    exit(0);
  } else {
    if (! xh_readdata(ifl,h,seism))
      exit(0);
  }
  // check header
  if (! xh_checkheader(h) )
    exit(-1);

  if (icount == 1) {
    // Warn if CMT has already been set
    // The default value from RDSEED is 000000A
    if (strncmp(h.evtcd,"000000A",7) != 0) {
      fprintf(stdout,"\nWarning !!!  Previously, %s was set.\n",h.evtcd);
      fprintf(stdout,"Now we are using         %s ...\n",evtcode);
    }
  }
  h.elat = cmt.centroid_lat;
  h.elon = cmt.centroid_lon;
  h.edep = cmt.centroid_dep;
  h.Mb = cmt.mb;
  h.Ms = cmt.ms;
  h.Mw = (log10(cmt.M0) + cmt.expo -26. + 9.9)/1.5;

  // catalog time (PDE)
  t1.yr  = cmt.cat.yr;
  t1.mo  = cmt.cat.mo;
  t1.day = cmt.cat.day;
  t1.hr  = cmt.cat.hr;
  t1.mn  = cmt.cat.mn;
  t1.sec = cmt.cat.sec;
  // add centroid time shift 
  timadd(t1,cmt.centroid_time,&t2);
  h.ot.yr  = t2.yr;
  h.ot.mo  = t2.mo;
  h.ot.day = t2.day;
  h.ot.hr  = t2.hr;
  h.ot.mn  = t2.mn;
  h.ot.sec = t2.sec;
  
//h.ot.yr  = cmt.cat.yr;
//h.ot.mo  = cmt.cat.mo;
//h.ot.day = cmt.cat.day;
//h.ot.hr  = cmt.cat.hr;
//h.ot.mn  = cmt.cat.mn;
//h.ot.sec = cmt.cat.sec;

  strcpy(h.cmtcd,cmt.cmtcd);
  strcpy(h.evtcd,cmt.evtcd);
  if (icount == 1) {
    fprintf(stdout,"%s %04d/%02d/%02d ",
            cmt.evtcd,cmt.cat.yr,cmt.cat.mo,cmt.cat.day);
    fprintf(stdout,"%02d:%02d:%04.1f",
            cmt.cat.hr,cmt.cat.mn,cmt.cat.sec);
    fprintf(stdout," %s H=%3.0fkm Mb=%3.1f Ms=%3.1f Mw=%3.1f\n",
            region,cmt.cat.dep,h.Mb,h.Ms,h.Mw);
  }
  icount++;
  // Warn if h.tstart-h.ot is more than 6 hours
  if (! xh_TsT0_diff(h,&tdiff))
    exit(-1);
  if (fabs(tdiff) > 6.*3600.)
    fprintf(stdout,"Warning !!! ot-tstart > 6 hours %s %s ...\n",h.stnm,h.chan);
  // WRITE XH header and data
  if (! xh_writehead(ofl,h))
    exit(-1);
  if (! xh_writedata(ofl,h,seism)) 
    exit(-1);
} // while 

fclose (ifl);
fclose (ofl);
}

int usage()
        {
        fprintf(stderr,"Usage: xh_inscmt in_XHfile out_XHfile -c CMT\n");
        return(-1);
}
