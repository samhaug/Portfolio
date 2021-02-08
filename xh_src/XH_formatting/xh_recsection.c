// xh_recsection.c     

//Prepares a record section for GMT

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "xhhead.h"

//#include "xh_functions.h"

int main( argc, argv )
int   argc;
char       *argv[];
{
int       ierr, index = 0, i, j=0, i1, i2, nlines;
int       still_reading_data = 1;

float     data[XH_NPTS];
float     ypos[XH_NPTS];
float     yneg[XH_NPTS];
float     scale = 1., scale0 = 1.;
float     gcarc_min, gcarc_max, gcarc_range, maxamp;
float     az_min, az_max;
float     gcarc, az, baz;

int       time;
int       tstep;

char      outnm[30];
FILE     *xhfl, *gmt, *fopen();
FILE     *xyfl, *posfl, *negfl;
xhhed     h;

int usage();

// file with traces
if ((xyfl = fopen("recsect.xy","w")) == NULL) {
   fprintf(stderr,"Error opening recsect.xy ...\n");
   exit(ierr);
}
if ((negfl = fopen("fillneg.xy","w")) == NULL) {
   fprintf(stderr,"Error opening fillneg.xy ...\n");
   exit(ierr);
}
if ((posfl = fopen("fillpos.xy","w")) == NULL) {
   fprintf(stderr,"Error opening fillpos.xy ...\n");
   exit(ierr);
}

// GMT script
if ((gmt = fopen("recsect.gmt","w")) == NULL) {
   fprintf(stderr,"Error opening recsect.gmt ...\n");
   exit(ierr);
}

if (argc != 10) {
  ierr = usage();
  exit( -1 );
}
if ((xhfl = fopen(argv[1],"r")) == NULL) {
   ierr = usage();
   exit(ierr);
}
index = 1;
while ( ++index < argc && argv[index][0] == '-' ) {
   switch ( argv[index][1] ) {
     case 'a':
        if ( sscanf( argv[++index], "%f", &az_min ) != 1 ||
             sscanf( argv[++index], "%f", &az_max ) != 1) {
           ierr = usage();
           exit( -1 );
        }
        break;
     case 'd':
        if ( sscanf( argv[++index], "%f", &gcarc_min ) != 1 ||
             sscanf( argv[++index], "%f", &gcarc_max ) != 1) {
           ierr = usage();
           exit( -1 );
        }
        break;
     case 's':
        if ( sscanf( argv[++index], "%f", &scale0 ) != 1) {
           ierr = usage();
           exit( -1 );
        }
        break;
     default:
        ierr = usage();
        exit( -1 );
   }
}
fprintf(gmt,"#!/bin/csh -f\n");
fprintf(gmt,"\n");
fprintf(gmt,"gmtset MEASURE_UNIT cm\n");
fprintf(gmt,"gmtset ANOT_FONT_SIZE 10\n");
fprintf(gmt,"gmtset LABEL_FONT_SIZE 14\n");
fprintf(gmt,"\n");
fprintf(gmt,"set fill = 0/0/0\n");
fprintf(gmt,"\n");
fprintf(gmt,"set proj = -JX12/20\n");


// total distance range
gcarc_range = gcarc_max - gcarc_min;
fprintf(stdout,"Dist_range= %f\n", gcarc_range);

i=0;
while ( still_reading_data ) {
  i++;
  if   (! xh_readhead(xhfl,&h)) {
    still_reading_data = 0;
    exit(0);
  } else {
    if (! xh_readdata(xhfl,h,data)) {
      still_reading_data = 0;
      exit(0);
    }
  }
  // check header
  if (! xh_checkheader(h) )
    exit(-1);

  if (i == 1) {
    time  = (int) h.ndata * h.delta;
    fprintf(gmt,"set reg  = -R%d/%d/%d/%d\n", 0, time, (int) gcarc_min,(int) gcarc_max);
    fprintf(gmt,"\n");
    // total time range
    tstep = 20;
    if (time > 100   && time <= 200  ) tstep = 20;
    if (time > 200   && time <= 1000 ) tstep = 50;
    if (time > 1000  && time <= 2000 ) tstep = 200;
    if (time > 2000  && time <= 10000) tstep = 500;
    fprintf(gmt,"set bord = -Ba%df%d/a2f1WeSn\n", tstep, tstep/2);
    fprintf(gmt,"\n");
    fprintf(gmt,"psxy fillneg.xy -m $proj $reg $bord -G$fill      -P -V -K >  plot.ps\n");
    fprintf(gmt,"psxy recsect.xy -m $proj $reg       -W0       -O -P -V    >> plot.ps\n");
    fprintf(gmt,"\n");
    fprintf(gmt,"ps2pdf plot.ps\n");
  }

  // give the trace a maximum amplitude of 1
  maxamp = 0.;
  for (i=0; i<h.ndata; ++i) {
     if (fabs(data[i]) >= maxamp) maxamp = fabsf(data[i]);
  }
  scale = 0.02*gcarc_range*scale0;
  for (i=0; i<h.ndata; ++i) 
     data[i] = data[i]/maxamp*scale;
  
  // Get distance (degrees)
  if (! distaz(h.slat,h.slon,h.elat,h.elon,&gcarc,&az,&baz)) {
     fprintf(stderr,"Error in distaz() %s\n", h.stnm);
     exit(-1);
  }

  // include only data in the selected gcarc range
  if( gcarc >= gcarc_min && gcarc <= gcarc_max &&
      az    >= az_min    && az    <= az_max) {
    fprintf(stdout,"Working on %s Dist= %7.2f Amp= %e\n",h.stnm,gcarc,maxamp);

    i1 = 0;
    i2 = h.ndata;
    fprintf(xyfl,">\n");
    fprintf(negfl,">\n");
    fprintf(posfl,">\n");
    // yneg is the same as data[] but all the positive values are 0
    if ( ! writenegval(data,yneg,h.ndata) )
      fprintf(stderr,"Check writenegval() ...\n");
    // ypos is the same as data[] but all the negative values are 0
    if ( ! writeposval(data,ypos,h.ndata) )
      fprintf(stderr,"Check writeposval() ...\n");

//  fprintf(stdout,"Sample range of plot: %d %d\n", i1, i2);
//  fprintf(stdout,"Sample range of plot: %d %d\n", i1, i2);
    if( i2 > h.ndata) i2=h.ndata;
    fprintf(negfl,"%f %f\n", i1*h.delta, gcarc);
    fprintf(posfl,"%f %f\n", i1*h.delta, gcarc);
    for (i=i1; i<i2; i++) {
       data[i] = data[i] + gcarc;
       yneg[i] = yneg[i] + gcarc;
       ypos[i] = ypos[i] + gcarc;
       if ( isinf(data[i]) ) {
          fprintf(stderr,"i= %d\n", i);
         exit(-1);
       }
       //fprintf(xyfl, "%f %f\n", i*h.delta-(gcarc*111.195/11.), data[i]);
       fprintf(xyfl, "%f %f\n", i*h.delta, data[i]);
       fprintf(negfl,"%f %f\n", i*h.delta, yneg[i]);
       fprintf(posfl,"%f %f\n", i*h.delta, ypos[i]);
    }
    fprintf(negfl,"%f %f\n", i2*h.delta, gcarc);
    fprintf(posfl,"%f %f\n", i2*h.delta, gcarc);
  }
}
/*  fprintf(stderr,"program %s, ntr = %d \n",progname,ntr); */
}

int usage()
{
fprintf(stderr,"Usage: xh_recsection XH_file -a az_min az_max -d dist_min_dist_max -s scale\n");
               return(-1);
}
