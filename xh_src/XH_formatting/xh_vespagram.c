#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <complex.h>
#include <sys/param.h>
#include "xhhead.h"	/* XH format structures */

/* Makes vespagram for GMT plotting via radon transform*/
/* Reads the header of an XH file and prints out some information */

// Maximum of 3000 traces, each trace can 1.82 hours at an 10Hz samp_rate max.
// 65536 is a power of 2 so the Radix2 transform method can be used
// MAXP is the max number of slownesses values allowed

#define MAXTRACE 1000
#define MAXSAMP 8000
#define MAXP 100

int usage();
int fuck(float real[], float imag[], int num);

int Radon_inverse(int it, int iDelta, int ip, float t[MAXSAMP], 
                  float delta[MAXTRACE], float M_real[MAXTRACE][MAXSAMP], float p[MAXP], 
                  float weights[MAXTRACE], float ref_dist, float hyperparam, int Ident[MAXP][MAXP],
                  float complex R[MAXTRACE][MAXSAMP]);

int main(int argc,char *argv[]){
  xhhed 	h;
  int ntrace,ip;
  int still_reading_data = 1;
  int ierr;
  float seism[XH_NPTS];
  float gcarc,az,baz;
  char infile[80];
  char lat, lon;
  char region[23];
  FILE *inf;
  float pmin,pmax,pinc,ref_dist,hyperparam;
  char out[3];
  int ii,jj,iDelta,it,iw;
  int distaz();
  static int Ident[MAXP][MAXP] = {0};
  static float M_real[MAXTRACE][MAXSAMP] = {0};
  static float delta[MAXTRACE] = {0};
  static float t[MAXSAMP] = {0};
  static float p[MAXP] = {0};
  static float weights[MAXTRACE] = {0};
  static float complex R[MAXTRACE][MAXSAMP] = {0};

  for (ii=0;ii<MAXTRACE;ii++){
    weights[ii] = 1;
  }
  for (ii=0;ii<MAXP;ii++){
    Ident[ii][ii] = 1;
  }

  if(argc != 8) {
     ierr = usage();
     exit(ierr);
  }
  if ((inf = fopen(argv[1],"r")) == NULL) {
     fprintf(stdout,"Something wrong with XH_IN\n");
     exit(-1);
  }

  // P_MIN
  if (!strncmp(argv[2],"D",1)){
     pmin=0.0;
  } else {
     pmin=atoi(argv[2]); 
  }
  // P_MAX
  if (!strncmp(argv[3],"D",1)){
     pmax=10.1;
  } else {
     pmax=atoi(argv[3]); 
  }
  // P_INC
  if (!strncmp(argv[4],"D",1)){
     pinc=0.1;
  } else {
     pinc=atoi(argv[4]); 
  }
  // REF_DIST
  if (!strncmp(argv[5],"D",1)){
     ref_dist=1000.;
  } else {
    ref_dist=atoi(argv[5]); 
  }
  // HYPERPARAMETER
  if (!strncmp(argv[6],"D",1)){
     hyperparam=5e2;
  } else {
     hyperparam=atoi(argv[6]); 
  }
  // output
  //if (!strncmp(argv[7],"D",1)){
  //   strcpy(out,"GMT");
  //} else {
  //   strcpy(out,argv[7]);
  //}

  // Make input data matrix and input gcarc vector
  iDelta=0;
  while (still_reading_data){
    if (! xh_readhead(inf,&h)){
      still_reading_data = 0;
    } 
    else {	
      if (! xh_readdata(inf,h,seism)) {
        still_reading_data = 0;
      }
      // check header
      if (! xh_checkheader(h)) exit(-1);

      for (jj=0;jj<h.ndata;jj++){
        M_real[iDelta][jj] = seism[jj];
      }
      // Get distance (degrees)
      distaz(h.slat,h.slon,h.elat,h.elon,&gcarc,&az,&baz);
      delta[iDelta] = gcarc;
      iDelta++;
    }
  } // while
  fclose(inf);
  fflush(stdout);

  //Make identity matrix and slowness vector
  ip=ceil((pmax-pmin)/pinc);
  if (ip > MAXP){
    fprintf(stdout,"Too many slowness values.\n");
    fprintf(stdout,"Increase p_inc or adjust p_min/p_max \n");
    exit(-1);
  }

  else{
    for (ii=0;ii<ip;ii++){
      p[ii]=pmin+(ii*pinc);
    }
  }

  //Make input time vector
  it = h.ndata;
  for (ii=0;ii<h.ndata;ii++){
    t[ii]=ii*h.delta;
  }

  // Start the inverse Radon transform
  

  Radon_inverse(it,iDelta,ip,t,delta,M_real,p,weights,ref_dist,hyperparam,Ident,R);

  return(1);
}

int Radon_inverse(int it, int iDelta, int ip, float t[MAXSAMP], 
                  float delta[MAXTRACE], float M_real[MAXTRACE][MAXSAMP], 
                  float p[MAXP], 
                  float weights[MAXTRACE], float ref_dist, 
                  float hyperparam, int Ident[MAXP][MAXP],
                  float complex R[MAXTRACE][MAXSAMP]){
    /*This function inverts move-out data to the Radon domain given the inputs:
     -it       -- length of time axis.
     -iDelta   -- Number of traces.
     -ip       -- length of slowness axis (number of discrete p values).
     -iw       -- length of wieght axis (must be same as iDelta).
     -t        -- vector of time axis.
     -delta    -- vector of distance axis.
     -M_real   -- matrix of move-out data, ordered
                  size(M_real)==[length(delta),length(t)].
     -p        -- vector of slowness axis you would like to invert to.
     -weights  -- weighting vector that determines importance of each trace.
                  set vector to ones for no preference.
     -ref_dist -- reference distance the path-function will shift about.
     -hyperparameter, trade-off between fitting the data and chosen damping.

     Output radon domain is ordered size(R)==[length(p),length(t)].
     Known limitations:
     - Assumes evenly sampled time axis.
     - Assumes move-out data isn't complex.
  
     Modified by Samuel M Haugland from the following referenced code:
          Schultz, R., Gu, Y. J., 2012. Flexible, inversion-based Matlab 
          implementation of the Radon Transform.  Computers and
          Geosciences [In Preparation]
          An, Y., Gu, Y. J., Sacchi, M., 2007. Imaging mantle
          discontinuities using least-squares Radon transform.
          Journal of Geophysical Research 112, B10303.
     Author: R. Schultz, 2012
     This program is free software: you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published
     by the Free Software Foundation, either version 3 of the License, or
     any later version.
     This program is distributed in the hope that it will be useful,
     but WITHOUT ANY WARRANTY; without even the implied warranty of
     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
     GNU General Public License for more details: http://www.gnu.org/licenses/
     */

     int ii,jj,kk;
     static float complex Rfft[MAXP][MAXSAMP];
     static float complex A[MAXTRACE][MAXP],
     static float complex AtA[MAXP][MAXP];
     static float complex AtM[MAXP][1];
     float dF = 1./(t[0]-t[1]);
     static float Dist_array[MAXTRACE];
     // four1 transform needs arrays of 2*MAXSAMP with real/imag pairs
     static float Mfft[MAXTRACE][2*MAXSAMP] = {{0.0}};
     static float W[MAXTRACE][MAXTRACE]     = {{0.0}};
     static float Tshift[MAXTRACE][MAXP]    = {{0.0}};

     // define weight matrix W and Mfft
     for (ii=0;ii<iDelta;ii++){
       W[ii][ii] = weights[ii];
       for (jj=0;jj<MAXSAMP;jj++)
        Mfft[ii][jj*2] = M_real[jj];
        four1(Mfft[ii],MAXSAMP,1);
     }

     for (ii=0;ii<iDelta;ii++){
       for (jj=0;jj<ip;jj++){
          Tshift[ii][jj] = p[ip];
       }
     }

     for (ii=0;ii<iDeltap;ii++){
       for (kk=0;kk<ip;kk++){
          Tshift[ii][kk] *= Dist_array[ii];
       }
     }
     
     //loop through each frequency
     for (ii=0;ii<MAXSAMP;ii++){

       // Make time-shift matrix, A
       f = ((float)ii/(MAXSAMP*2))*dF;
       for (jj=0;jj<iDelta;jj++){
         for (kk=0;kk<ip;kk++){
           A[jj][kk] = exp((0+2*I)*M_PI*f*Tshit[jj][kk])
         }
       }
     }


  return(1);
}

int fuck(float real[], float imag[], int num){
   int ii;
   for (ii=0;ii<num;ii++){
      fprintf(stdout,"%f %f\n",real[ii],imag[ii]);
   }
   return(1);
}


int usage(){
   fprintf(stdout,"\n");
   fprintf(stdout,"xh_vespagram uses the Radon transform to make vespagram.\n");
   fprintf(stdout,"\n");
   fprintf(stdout,"Default usage :\n");
   fprintf(stdout,"xh_vespagram XH_IN p_min p_max p_inc ref_dist hyper OUTPUT:\n");
   fprintf(stdout,"\n");
   fprintf(stdout,"XH_IN         : input xh file\n");
   fprintf(stdout,"p_min/p_max   : slowness min/max values (defaults 0/10)\n");
   fprintf(stdout,"p_inc         : slowness incriment (default 0.1)\n");
   fprintf(stdout,"ref_dist      : reference distance (deg) (default to mean distance)\n");
   fprintf(stdout,"hyper         : Inversion hyperparameter (default 5e2)\n");
   fprintf(stdout,"OUTPUT        : Output file type GMT(default) or CSV\n");
   fprintf(stdout,"\n");
   fprintf(stdout,"Any of these values other than XH_IN may be set to D to use default setting.\n");
   fprintf(stdout,"\n");
   return(-1);
}



