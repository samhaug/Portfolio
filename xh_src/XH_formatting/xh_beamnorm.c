#include "beamform.h"
#include <stdio.h>
#include <stdlib.h>


int main(int argc,char *argv[]){
    FILE *ifl,*ofl;
    beamform beam_in;
    int ierr,i,j,k;
    float maxlevel;
    int baz_lim,i_lim;
    int tmin,tmax;
    int imin,imax;
    int bmin,bmax;
    int itmin,itmax;
    int iimin,iimax;
    int ibmin,ibmax;

    if (argc != 9){
       ierr = usage();
       exit(ierr);
    }

    ifl = fopen(argv[1],"rb");
    ofl = fopen(argv[2],"wb");
    fread(&beam_in,sizeof(beam_in),1,ifl);

    tmin = (int)(atof(argv[3]));
    tmax = (int)(atof(argv[4]));
    imin = (int)(atof(argv[5]));
    imax = (int)(atof(argv[6]));
    bmin = (int)(atof(argv[7]));
    bmax = (int)(atof(argv[8]));

    if ((tmin < 0) || (tmax > 2000)){
       fprintf(stdout,"Temporal bounds are off limits\n");
       exit(0);
    }
    if ((imin < beam_in.i_min) || (imax > beam_in.i_max)){
       fprintf(stdout,"incidence angle bounds are off limits\n");
       exit(0);
    }
    if ((bmin < beam_in.baz_min) || (bmax > beam_in.baz_max)){
       fprintf(stdout,"back-azimuth bounds are off limits\n");
       exit(0);
    }

    ibmin = (int)((bmin-beam_in.baz_min)/(float)beam_in.baz_inc);
    ibmax = (int)((bmax-beam_in.baz_min)/(float)beam_in.baz_inc);
    iimin = (int)((imin-beam_in.i_min)/(float)beam_in.i_inc);
    iimax = (int)((imax-beam_in.i_min)/(float)beam_in.i_inc);
    itmin = (int)(tmin/(float)beam_in.delta);
    itmax = (int)(tmax/(float)beam_in.delta);

    maxlevel=0.0;
    for (i=ibmin;i<ibmax;i++){
      for (j=iimin;j<iimax;j++){
        for (k=itmin;k<itmax;k++){
            if (beam_in.dat2[i][j][k] > maxlevel){
                maxlevel = beam_in.dat2[i][j][k];
            }
         } // for k
       } // for j
     } // for i


    printf("baz min: %d\n",beam_in.baz_min);
    printf("baz max: %d\n",beam_in.baz_max);
    printf("i min: %d\n",beam_in.i_min);
    printf("i max: %d\n",beam_in.i_max);
    baz_lim = (int)((beam_in.baz_max-beam_in.baz_min)/(float)beam_in.baz_inc);
    i_lim = (int)((beam_in.i_max-beam_in.i_min)/(float)beam_in.i_inc);
    for (i=0;i<baz_lim;i++){
      for (j=0;j<i_lim;j++){
        for (k=0;k<beam_in.ndata;k++){
              beam_in.dat2[i][j][k] *= 1./maxlevel;
        }
      }
    }

    fwrite(&beam_in,sizeof(beam_in),1,ofl);

    return(0);
} // main

int usage(){
    fprintf(stdout,"\n");
    fprintf(stdout,"\n");
    fprintf(stdout,"USAGE: xh_beamnorm BEAMFILE_IN BEAMFILE_OUT tmin tmax imin imax bmin bmax\n");
    fprintf(stdout,"BEAMFILE_IN is output binary file from xh_beamform or xh_3compbeamform\n");
    fprintf(stdout,"BEAMFILE_OUT is the beamfile normalized on maximum amplitude within bounds\n");
    fprintf(stdout,"tmin/tmax: specify temporal bounds\n");
    fprintf(stdout,"imin/imax: specify incidence angle bounds\n");
    fprintf(stdout,"bmin/bmax: specify back azimuth bounds\n");
    fprintf(stdout,"\n");
    return(0);
}





