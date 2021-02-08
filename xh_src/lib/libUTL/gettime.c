// Get the P wave travel time from 
// /work/jeroen/my_src/TravelTimeTables/tt.iasp91.P.bin

// The bin-file tt.iasp91.P.bin has traveltimes of P
// for 10-km depth interval (0,10,20,30,...,680,690,700)
// and 1-deg distance interval (1,2,3,4,...,178,179,180).

#include <stdio.h>
#include <string.h>
#include <math.h>
#include <sys/file.h>

#include "TTtable.h"

int gettime(Sdepth,gcarc,Phas_time,phase)
float Sdepth,gcarc,*Phas_time;
char  phase[];
{

tthed tt;

FILE 		*fopen(), *ifl;
char            ss[120], outfile[30];
char            model[20];
int             i=0;
int             ndist;
float           Tdepth=-10.,t1,t2,dz,dg;
float           dist1[180],time1[180],rayp1[180];
float           dist2[180],time2[180],rayp2[180];

sprintf(ss,"/geo/home/jritsema/Utils/TauP_calculations/TravelTimeTables/tt.iasp91.%s.bin",phase);
if ( Sdepth > 700. ) {
    fprintf(stderr,"gettime() SourceDepth  too large ...\n");
    return(0);
}
if ( gcarc > 180. ) {
    fprintf(stderr,"gettime() GCARC is  too large ...\n");
    return(0);
}
if ( (ifl=fopen(ss,"r")) == NULL) {
    fprintf(stderr,"ERROR reading Traveltime table ...\n");
    return(0);
}

while (Sdepth>Tdepth) {
  // header
  int bRead = fread(&tt,1,TT_HDRSIZE,ifl);
  if (bRead != TT_HDRSIZE) {
    fprintf(stderr,"ERROR reading tt header ...\n");
    return(0);
  }
  Tdepth = tt.depth;
  if (fread(dist2,sizeof(float),tt.ndist,ifl) != tt.ndist) {
    fprintf(stderr,"ERROR reading TT data [dist] ...\n");
    fprintf(stderr,"ttndist= %d ...\n", tt.ndist);
    return(0);
  }
  if (fread(time2,sizeof(float),tt.ndist,ifl) != tt.ndist) {
    fprintf(stderr,"ERROR reading TT data [time] ...\n");
    return(0);
  }
  if (fread(rayp2,sizeof(float),tt.ndist,ifl) != tt.ndist) {
    fprintf(stderr,"ERROR reading TT data [rayp] ...\n");
    return(0);
  }
  if(Sdepth>Tdepth) {
    for(i=0;i<180;i++) time1[i]=time2[i];
    for(i=0;i<180;i++) rayp1[i]=rayp2[i];
    for(i=0;i<180;i++) dist1[i]=dist2[i];
   } else {
    i = floor(gcarc); 
    dg = gcarc-1.*i;
    dz = Tdepth-Sdepth;
    t1 = time1[i] + dg*(time1[i+1]-time1[i]);
    t2 = time2[i] + dg*(time2[i+1]-time2[i]);
    *Phas_time = t2 + dz/10.*(t1-t2);
   }
} // while

return(1);
}
