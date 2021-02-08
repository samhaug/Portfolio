#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include "xhhead.h"		// XH   structures

// Determines the time closest to h.tpcks[3]
// where the waveform has a maximum value.
// Used to align the PP waveforms from the PP data files

// Assumes:
// (-) that the traces been synchronized with xh_synch
// (-) that the traces have the same sampling frequency
// (-) that h.chid == 1

#define NZREC 400
#define NSAMP 1000

main(argc,argv)
int argc;
char *argv[];
{
xhhed 	h;
int     index;
int 	icount=1;
int 	i,k, ierr;
int     i_pck, i_win, i_slp, i_max1, i_max2, i_pol1, i_pol2;
int     i_rec=0;

int     still_reading_data = 1;
float   data[XH_NPTS];
float   win;

char    infile[80];
FILE   *ifl, *ofl, *fopen();

int usage();

// Command line input
if(argc != 5) {
     ierr = usage();
     exit(-1);
}
if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     exit(-1);
}
if ((ofl = fopen(argv[2],"w")) == NULL) {
     ierr = usage();
     exit(-1);
}
index = 2;
while ( ++index < argc && argv[index][0] == '-' ) {
  switch ( argv[index][1] ) {
     case 'w':
        // search window length
        if ( sscanf( argv[++index], "%f", &win ) != 1) {
             ierr = usage();
        }
        break;
     default:
        ierr = usage();
        exit(ierr);
  }
}


while (still_reading_data) {
  if   (! xh_readhead(ifl,&h)) {
    still_reading_data = 0;
    exit(-1);
  } else {
    if (! xh_readdata(ifl,h,data)) {
      still_reading_data = 0;
      exit(-1);
    }
  }
  // check header
  if (! xh_checkheader(h) )
    exit(-1);
  // only Z component waveforms
  if (h.chid != 1) {
    fprintf(stderr,"Record %s %s -- chid [=%d] != 1 ...\n", h.stnm,h.chan,h.chid);
    exit(-1);
  }
  // Make sure that h.tpcks[3] (= Handpick time) is defined
  if (h.tpcks[3] <= 0.) {
    fprintf(stderr,"Record %s %s -- Handpick  time [=%f] not valid ...\n", h.stnm,h.chan,h.tpcks[3]);
    exit(-1);
  }
  // Sample for the handpick PP time
  i_pck = h.tpcks[3]/h.delta; 

  // [-win,+win] search window -- break as soon as maximum is found
  i_win = lrintf(win/h.delta);

  fprintf(stdout,"============================================\n");
  fprintf(stdout,"stnm= %s i_pck= %d\n", h.stnm,i_pck);
  fprintf(stdout,"i_win= %d \n", i_win);

  i_max1 = -1; 
  i_max2 = -1; 
  i_pol1 =  0;
  i_pol2 =  0;
  // beginning 1 sample to the left of i_pck
  // first determine the slope of the waveform
  i_slp = slope(data[i_pck-1],data[i_pck]);
  fprintf(stdout,"A10 beginning i_slp= %d\n",i_slp);

  // go to the right and determine when the slope change.
  // here, you reached a maximum or minimum in data
  for (i=i_pck; i<i_pck+i_win; i++) {
    fprintf(stdout,"------------\n");
    fprintf(stdout,"A12 i= %d i_slp= %d\n",i,i_slp);
    fprintf(stdout,"A13 v1= %e v2= %e\n",data[i],data[i+1]);
    if ( slope(data[i],data[i+1]) != i_slp) {
      i_max1 = i;
      if        (i_slp == -1) {
        i_pol1 = -1;
      } else if (i_slp ==  1) {
        i_pol1 =  1;
      }
      fprintf(stdout,"A-- i= %d i_max1= %d i_pol1= %d\n", i,i_max1,i_pol1);
      break;
    }
  }
  fprintf(stdout,"A19 i= %d i_max1= %d i_pol1= %d\n", i,i_max1,i_pol1);

  fprintf(stdout,"\n");
  // beginning 1 sample to the right of i_pck
  // first determine the slope of the waveform
  i_slp = slope(data[i_pck],data[i_pck+1]);
  fprintf(stdout,"A10 beginning i_slp= %d\n",i_slp);

  // go to the left and determine when the slope change.
  // here, you reached a maximum or minimum in data
  for (i=i_pck;i>i_pck-i_win;i--) {
    fprintf(stdout,"------------\n");
    fprintf(stdout,"B12 i= %d i_slp= %d\n",i,i_slp);
    fprintf(stdout,"B13 v1= %e v2= %e\n",data[i-1],data[i]);
    if ( slope(data[i-1],data[i]) != i_slp) {
      i_max2 = i;
      if        (i_slp == -1) {
        i_pol2 = -1;
      } else if (i_slp ==  1) {
        i_pol2 =  1;
      }
      fprintf(stdout,"B-- i= %d i_max2= %d\n", i, i_max2);
      break;
    }
  }
  fprintf(stdout,"B29 i= %d i_max2= %d\n", i, i_max2);

  if        ( i_max1 == -1  )  { 
    if ( i_max2 != -1) {
      h.tpcks[3] = i_max2*h.delta;
      h.tpcks[4] = i_pol2*1.;
    } else {
      fprintf(stderr,"Record %s %s -- i_max1=i_max2=-1\n", h.stnm,h.chan);
      h.qual = -1;
    }
  } else if ( i_max2 == -1  )  {
    if ( i_max1 != -1) {
      h.tpcks[3] = i_max1*h.delta;
      h.tpcks[4] = i_pol1*1.;
    } else {
      fprintf(stderr,"Record %s %s -- i_max1=i_max2=-1\n", h.stnm,h.chan);
      h.qual = -1;
    }
  } else {
    // Two nearby maxima
    if ( fabs(data[i_max1]) > fabs(data[i_max2])) {
      h.tpcks[3] = i_max1*h.delta;
      h.tpcks[4] = i_pol1*1.;
    } else {
      h.tpcks[3] = i_max2*h.delta;
      h.tpcks[4] = i_pol2*1.;
    }
  }
  fprintf(stdout,"-%s- i_pck= %d imax1= %d imax2= %d v_1= %e v_2= %e ",
         h.stnm,i_pck,i_max1,i_max2,fabs(data[i_max1]),fabs(data[i_max2]));
  fprintf(stdout,"nwpck= %6.1f pol= %f\n", h.tpcks[3], h.tpcks[4]);
    

  // WRITE XH header and data
  if (! xh_writehead(ofl,h))
    exit(-1);
  if (! xh_writedata(ofl,h,data)) 
    exit(-1);
}

fclose (ifl);
fclose (ofl);
}


int slope(v1,v2)
float v1,v2;
{
  int i_slp = 0;

  if ( v2>v1 ) i_slp =  1;
  if ( v2<v1 ) i_slp = -1;
  fprintf(stdout,"slope() v1= %e v2= %e slp= %d\n",v1,v2,i_slp);
  return(i_slp);
}



int usage()
        {
        fprintf(stderr,"Usage: xh_Palignment in_XH out_XH -w WIN\n");
        return(0);
}
