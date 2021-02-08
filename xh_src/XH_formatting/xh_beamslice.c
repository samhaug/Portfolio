#include "beamform.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc,char *argv[]){
    FILE *ifl;
    beamform beam;
    int ierr,idx,i,j;
    float time;
    int baz_num,i_num;
    int baz,inc;

    if (argc != 3){
       ierr = usage();
       exit(ierr);
    }

    ifl = fopen(argv[1],"rb");
    fread(&beam,sizeof(beam),1,ifl);
    time = atof(argv[2]);
    idx = (int)(time/beam.delta);
    baz_num=(int)((float)(beam.baz_max-beam.baz_min)/(float)beam.baz_inc);
    i_num=(int)((float)(beam.i_max-beam.i_min)/(float)beam.i_inc);
    for (i=0;i<baz_num;i++){
        for (j=0;j<i_num;j++){
            baz = (int)(beam.baz_min + i*beam.baz_inc);
            inc = (int)(beam.i_min + j*beam.i_inc);
            fprintf(stdout,"%4d %4d %8.4f %8.4f %8.4f\n",baz,inc,
                    beam.dat1[i][j][idx],
                    beam.dat2[i][j][idx],
                    beam.dat3[i][j][idx]);
                  //  beam.dat4[i][j][idx],
                  //  beam.dat5[i][j][idx]);
        }
    }

}

int usage(){
    fprintf(stdout,"\n");
    fprintf(stdout,"USAGE: xh_beamslice BEAMFILE time\n");
    fprintf(stdout,"BEAMFILE is output binary file from xh_beamform or xh_3compbeamform\n");
    fprintf(stdout,"time: Time in seconds at which to return baz/inc beamforming data\n");
    fprintf(stdout,"\n");
    return(0);
}





