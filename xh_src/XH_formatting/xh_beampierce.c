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
    int ibaz,iinc;
    float min=100; 

    if (argc != 4){
       ierr = usage();
       exit(ierr);
    }
    ifl = fopen(argv[1],"rb");
    fread(&beam,sizeof(beam),1,ifl);
    baz = atoi(argv[2]);
    inc = atoi(argv[3]);

    for (i=beam.baz_min;i<beam.baz_max;i+=beam.baz_inc){
        if (abs(baz-i) < min){
           min = abs(baz-i);
           ibaz = i;
        }   
    }
    //fprintf(stdout,"Requested baz: %d, Closest match: %d\n",baz,ibaz);
    min=100;

    for (i=beam.i_min;i<beam.i_max;i+=beam.i_inc){
        if (abs(inc-i) < min){
           min = abs(inc-i);
           iinc = i;
        }   
    }

    //fprintf(stdout,"Requested inc: %d, Closest match: %d\n",inc,iinc);
    iinc = (int)((float)iinc/(float)beam.i_inc);
    ibaz = (int)((float)ibaz/(float)beam.baz_inc);
    //fprintf(stdout,"%d %d\n",iinc,ibaz);

    for (j=0;j<beam.ndata;j++){
        fprintf(stdout,"%8.3f %8.6f %8.6f %8.6f\n",beam.delta*j,
                beam.dat1[ibaz][iinc][j],
                beam.dat2[ibaz][iinc][j],
                beam.dat3[ibaz][iinc][j]);
               // beam.dat4[ibaz][iinc][j],
               // beam.dat5[ibaz][iinc][j]);
        //fprintf(stdout,"%8.8f\n",beam.dat[ibaz][iinc][j]);
    }

}

int usage(){
    fprintf(stdout,"\n");
    fprintf(stdout,"USAGE: xh_beampierce BEAMFILE baz inc\n");
    fprintf(stdout,"BEAMFILE is output binary file from xh_beamform\n");
    fprintf(stdout,"baz: back azimuth\n");
    fprintf(stdout,"inc: incidence angle\n");
    fprintf(stdout,"\n");
    return(0);
}





