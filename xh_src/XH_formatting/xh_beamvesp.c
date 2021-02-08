#include "beamform.h"
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#define deg2rad M_PI/180.
int main(int argc,char *argv[]){
    FILE *ifl;
    beamform beam;
    int ierr,idx,i,j;
    float baz,time;
    int baz_num,i_num;
    int inc;

    if (argc != 3){
       ierr = usage();
       exit(ierr);
    }

    ifl = fopen(argv[1],"rb");
    fread(&beam,sizeof(beam),1,ifl);

    baz = atof(argv[2]);
    idx = (int)((float)baz/beam.baz_inc-(int)beam.baz_min);
    i_num=(int)((float)(beam.i_max-beam.i_min)/(float)beam.i_inc);
    for (i=0;i<i_num;i++){
        for (j=0;j<beam.ndata;j++){
            time = ((float)j*beam.delta);
            inc = (int)(beam.i_min + i*beam.i_inc);
            float p = (1/5.8)*sin(deg2rad*inc)*111.195;
            fprintf(stdout,"%8.4f %4d %8.5f %8.5f %8.5f %8.5f\n",time,inc,p,
                    beam.dat1[idx][i][j],
                    beam.dat2[idx][i][j],
                    beam.dat3[idx][i][j]);
        }
    }
}

int usage(){
    fprintf(stdout,"\n");
    fprintf(stdout,"USAGE: xh_beamvesp BEAMFILE baz\n");
    fprintf(stdout,"BEAMFILE is output binary file from xh_beamform or xh_3compbeamform\n");
    fprintf(stdout,"baz: back-azimuth from which to compte vespagram\n");
    fprintf(stdout,"\n");
    return(0);
}





