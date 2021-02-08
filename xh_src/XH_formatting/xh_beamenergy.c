#include "beamform.h"
#include <stdio.h>
#include <stdlib.h>


int main(int argc,char *argv[]){
    FILE *ifl;
    beamform beam_in;
    int ierr,i,j,k;
    float energy_sum;
    int tmin,tmax;
    int imin,imax;
    int itmin,itmax;
    int iimin,iimax;
    int ibmin,ibmax;

    if (argc != 6){
       ierr = usage();
       exit(ierr);
    }

    ifl = fopen(argv[1],"rb");
    fread(&beam_in,sizeof(beam_in),1,ifl);

    tmin = (int)(atof(argv[2]));
    tmax = (int)(atof(argv[3]));
    imin = (int)(atof(argv[4]));
    imax = (int)(atof(argv[5]));

    if ((tmin < 0) || (tmax > 2000)){
       fprintf(stdout,"Temporal bounds are off limits\n");
       exit(0);
    }
    if ((imin < beam_in.i_min) || (imax > beam_in.i_max)){
       fprintf(stdout,"incidence angle bounds are off limits\n");
       exit(0);
    }

    //ibmin = (int)((bmin-beam_in.baz_min)/(float)beam_in.baz_inc);
    ibmin=0;
    ibmax = (int)((beam_in.baz_max-beam_in.baz_min)/(float)beam_in.baz_inc);
    iimin = (int)((imin-beam_in.i_min)/(float)beam_in.i_inc);
    iimax = (int)((imax-beam_in.i_min)/(float)beam_in.i_inc);
    itmin = (int)(tmin/(float)beam_in.delta);
    itmax = (int)(tmax/(float)beam_in.delta);

    for (i=ibmin;i<ibmax;i++){
      energy_sum=0.0;
      for (j=iimin;j<iimax;j++){
        for (k=itmin;k<itmax;k++){
              energy_sum+=beam_in.dat2[i][j][k];
        } // for k
      } // for j
      fprintf(stdout,"%d %4.5f\n",beam_in.baz_min+(i*beam_in.baz_inc),energy_sum);
    } // for i

    return(0);
} // main

int usage(){
    fprintf(stdout,"\n");
    fprintf(stdout,"\n");
    fprintf(stdout,"USAGE: xh_beamenergy BEAMFILE_IN tmin tmax imin imax \n");
    fprintf(stdout,"BEAMFILE_IN is output binary file from xh_beamform or xh_3compbeamform\n");
    fprintf(stdout,"tmin/tmax: specify temporal bounds\n");
    fprintf(stdout,"imin/imax: specify incidence angle bounds\n");
    fprintf(stdout,"OUTPUT: sum of n-th root stack between time/inc bounds \n");
    fprintf(stdout,"        as function of backazimuth. \n");
    fprintf(stdout,"\n");
    return(0);
}





