#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
/*
    connect_rays looks for instersections between points on the incoming ray
    calculated by incoming_ray_coords and a lookup table of rays emerging from 
    the source.

    Samuel Haugland September 2020
*/
int usage();

int main(int argc, char *argv[]){
  double indist,inrad,intime,time,outtime,outdep,indep;
  double evla,evlo,stla,stlo,baz,inc,outrad,outdist;
  double lat1,lon1,lat2,lon2;
  double phi1,phi2,lambda2,alpha21,alpha12;
  double outgcarc,ingcarc,gcarc,amp;
  double min=1e9;
  int ierr,i;
  FILE *ifl, *ofl;

  if (argc != 9){
    ierr = usage();
    exit(ierr);
  }


  if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     exit(ierr);
  }

  if ((ofl = fopen(argv[2],"r")) == NULL) {
     ierr = usage();
     exit(ierr);
  }

  evla = atof(argv[3]);
  evlo = atof(argv[4]);
  baz = atof(argv[5]);
  inc = atof(argv[6]);
  time = atof(argv[7]);
  amp = atof(argv[8]);

i=0;
while (!feof(ifl)){
     i++;
     // scan coordinates of each point of incoming ray file
     fscanf(ifl,"%lf %lf %lf %lf %lf",&ingcarc,&inrad,&lat1,&lon1,&intime);
     // search each coordinate of every possible outgoing ray point
     // to find if intersection exists.
     while (!feof(ofl)){
        fscanf(ofl,"%lf %lf %lf",&outdist,&outrad,&outtime);
        // If the coordinates aren't at a similar depth or are too close to source (downgoing)
        // then don't bother doing the vincenty calculations.
        if (fabs(outrad-inrad) > 10 || outrad < 20) continue;
        // Find az between eq and point on incoming ray.
        vincenty_inverse(evla,evlo,lat1,lon1,&alpha12,&alpha21,&outgcarc);
        // Use this to calculate coordinates of outgoing ray point.
        vincenty_direct(evla,evlo,alpha12,outdist*111195.,&lat2,&lon2,&alpha21);
        // find gcarc from point to point.
        vincenty_inverse(lat1,lon1,lat2,lon2,&alpha12,&alpha21,&outgcarc);
        // find distance between two points at the same depth using gcarc
        // if coordinates are closer than 5 km then compute time 
        outdist = (outgcarc/111195.)*(3.14159/180.)*outrad*1000;
        if ((outdist < 5000.) && ( fabs(intime+outtime-time) < 1)){
           printf("%8.2f %8.2f %8.2f %8.4f %8.2f %8.2f %8.2f\n",baz,inc,time,amp,lat1,lon1,6371-outrad);
           return(1);
        }
     }
     rewind(ofl);
}


return(1);
}

int usage(){
  fprintf(stderr,"\n");
  fprintf(stderr,"connect_rays looks for instersections between points on the incoming ray\n");
  fprintf(stderr,"calculated by incoming_ray_coords and a lookup table of rays emerging from\n");
  fprintf(stderr,"the source.\n");
  fprintf(stderr,"\n");
  fprintf(stderr,"Usage: connect_rays inray outray evla evlo time\n");
  fprintf(stderr,"   INPUT:\n");
  fprintf(stderr,"   inray: output of incoming_ray_coords\n");
  fprintf(stderr,"   outray: taup_path ourput specifying outgoing ray coords\n");
//fprintf(stderr,"   stla/stlo: station array centroid latitude/longitude\n");
  fprintf(stderr,"   evla/evlo: source coordinates\n");
  fprintf(stderr,"   time: total time of observed ray\n");
  fprintf(stderr,"   OUTPUT:\n");
  fprintf(stderr,"   lat, lon, depth, dist_to_eq (degrees), time\n");
  fprintf(stderr,"\n");
  return(-1);
}

