#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <complex.h>
#include <sys/param.h>
#include "xhhead.h"        /* XH format structures */
#include "beamform_zcomp.h"   /* beamform structure */
 
#define deg2rad 3.14159/180.
/* Beamforms an array of stations over backazimuth and incidence angle*/

#define MAXTRACE 100

int usage();

int main(int argc,char *argv[]){
  xhhed h;
  beamform beam;
  FILE *inf,*outf;
  int i_shift,b_idx,i_idx,ierr;
  int still_reading_data = 1;
  int ii=0,jj=0,M=0;
  int baz_min,baz_max,baz_inc,i_min,i_max,i_inc;
  int bcount,icount, num_samp=0;
  int distaz();
  float v_o=5.80;
  float lat_mean=0,lon_mean=0;
  float seism[XH_NPTS];
  float seism_roll[XH_NPTS];
  float stack4[XH_NPTS];
  float stack2[XH_NPTS];
  float linstack[XH_NPTS];
  float fenv[XH_NPTS];
  float x_vec[MAXTRACE],y_vec[MAXTRACE];
  float rad_i,rad_b,gcarc,az,baz,t_shift;

  if(argc != 9) {
     ierr = usage();
     exit(ierr);
  }
  if ((inf = fopen(argv[1],"r")) == NULL) {
     fprintf(stdout,"Something wrong with XH_IN\n");
     exit(-1);
  }
  outf = fopen(argv[8],"wb");

  baz_min=atoi(argv[2]); 
  baz_max=atoi(argv[3]); 
  baz_inc=atoi(argv[4]); 
  i_min=atoi(argv[5]); 
  i_max=atoi(argv[6]); 
  i_inc=atoi(argv[7]); 

  //Find array centroid
  while (still_reading_data){
    if (! xh_readhead(inf,&h)){
      still_reading_data = 0;
    } 
    else {	
      if (! xh_readdata(inf,h,seism)) {
        still_reading_data = 0;
      }
      if (! xh_checkheader(h)){
        still_reading_data = 0;
      }
    }
    // Fill some beam structure data
    if (ii == 0){
        beam.t_start = 0.;           // starting time
        beam.delta_t = h.delta;	/* 1/sampling_rate  */
        beam.ndata   = h.ndata;	/* number of trace samples  */
        beam.baz_min = baz_min;
        beam.baz_max = baz_max;
        beam.baz_inc = baz_inc;
        beam.i_min = i_min;
        beam.i_max = i_max;
        beam.i_inc = i_inc;
        beam.p_min = (float)(1/v_o)*sin(deg2rad*i_min)*111.195;
        beam.p_max = (float)(1/v_o)*sin(deg2rad*i_max)*111.195;
        for (int i=0;i<4;i++) beam.filt[i] = h.intg[i]; // filter cutoffs
        beam.evdp  = h.edep;    // eq depth
        beam.elat = h.elat;     // event lat
        beam.elon = h.elon;     // event lon
    }

    lat_mean += h.slat;
    lon_mean += h.slon;
    ii++;
    M++;
  } //while
  still_reading_data = 1;
  rewind(inf);

  // End find array centroid
  lat_mean = (float)(lat_mean/ii);
  lon_mean = (float)(lon_mean/ii);
  beam.slat = lat_mean;
  beam.slon = lon_mean;
  distaz(lat_mean, lon_mean, h.elat, h.elon, h.slon, &gcarc, &az, &baz);
  beam.gcarc = gcarc;         // distance from source to array center (deg)
  beam.sr_baz = baz;         // back-azimuth from source to array along great circle
  beam.sr_az = az;           // azimuth from source to array along great circle
  
  // Find position vectors of each station from array centroid
  ii=0;
  //printf("%8.3f %8.3f\n",lat_mean,lon_mean);
  while (still_reading_data){
    if (! xh_readhead(inf,&h)){
      still_reading_data = 0;
    } 
    else {	
      if (! xh_readdata(inf,h,seism)) {
        still_reading_data = 0;
      }
      if (! xh_checkheader(h)){
        still_reading_data = 0;
      }
    }

    distaz(lat_mean, lon_mean, lat_mean, h.slon, &gcarc, &az, &baz);
    //if a_lat > tr.stats.sac['stla']:
    if (lon_mean > h.slon){
        //printf("%s %s slon \n",h.netw,h.stnm);
        x_vec[ii] = gcarc*-111.195/v_o;
    }
    else {
        x_vec[ii] = gcarc*111.195/v_o;
    }

    distaz(lat_mean, lon_mean, h.slat, lon_mean, &gcarc, &az, &baz);
    if (lat_mean > h.slat){
        //printf("%s %s slat \n",h.netw,h.stnm);
        y_vec[ii] = gcarc*-111.195/v_o;
    }
    else {
        y_vec[ii] = gcarc*111.195/v_o;
    }
    //printf("%s %s %8.3f %8.3f \n",h.netw,h.stnm,x_vec[ii],y_vec[ii]);
    //printf("%s %s %8.3f %8.3f \n",h.netw,h.stnm,h.slat,h.slon);
    ii++;
  } //while
  // END find position vectors of each station from array centroid

  // Begin beamforming
  b_idx = 0;
  i_idx = 0;
  num_samp = h.ndata;
  for (bcount=baz_min;bcount<baz_max;bcount+=baz_inc){
    beam.baz = bcount;             // incidence angle of this current beam
    i_idx=0;
    fprintf(stdout,"%8.2f%%  complete\n",100*(float)bcount/(float)baz_max);
    for (icount=i_min;icount<i_max;icount+=i_inc){
      beam.inc = icount;            // incidence angle of this current beam
      beam.p = (1/v_o)*sin(deg2rad*icount)*111.195;
      ii=0;
      still_reading_data = 1;
      rewind(inf);
      for (jj=0;jj<num_samp;jj++){
        stack4[jj] = 0.;
        stack2[jj] = 0.;
        linstack[jj] = 0.;
      }
      
      while (still_reading_data){
        if (! xh_readhead(inf,&h)){
          still_reading_data = 0;
        } 
        else {	
          if (! xh_readdata(inf,h,seism)){
            still_reading_data = 0;
          }
          if (! xh_checkheader(h)){
            still_reading_data = 0;
          }
        }
        rad_i = (M_PI/180.)*icount;
        rad_b = (M_PI/180.)*bcount;
        t_shift = sin(rad_i)*sin(rad_b)*x_vec[ii]+sin(rad_i)*cos(rad_b)*y_vec[ii];
        i_shift = (int)(t_shift/h.delta);
        //printf("t_shift: %8.3f i_shift: %5d\n",t_shift,i_shift);
        if (! roll(seism,seism_roll,h.ndata,i_shift)){
           fprintf(stderr,"Error timeshifting data ... \n");
           exit(1);
        }
        for (jj=0;jj<num_samp;jj++){
           // 4th root stack
           stack4[jj] += pow(fabs(seism_roll[jj]),0.25)*
                        (seism_roll[jj]/fabs(seism_roll[jj]))/(float)M;
           //
           stack2[jj] += pow(fabs(seism_roll[jj]),0.5)*
                        (seism_roll[jj]/fabs(seism_roll[jj]))/(float)M;
           //linear_stack
           linstack[jj] += seism_roll[jj]/(float)M;
        }
        ii++;
      } //while
      // 4th root stack cont'd
      for (jj=0;jj<num_samp;jj++){
         stack4[jj] = pow(fabs(stack4[jj]),4)*(stack4[jj]/fabs(stack4[jj]));
         stack2[jj] = pow(fabs(stack4[jj]),2)*(stack4[jj]/fabs(stack4[jj]));
      }

      if (! envelope(num_samp,stack4,fenv)){
         fprintf(stdout,"error with envelope\n");
         exit(-1);
      }

      for (jj=0;jj<num_samp;jj++){
         beam.dat[jj] = fenv[jj];
      }

    fwrite(&beam,sizeof(beam),1,outf);
    i_idx++;
    } //icount loop
  b_idx++;
  } //bcount

  fclose(inf);
  fflush(stdout);
  fprintf(stdout,"Writing n-th root output...\n");
  fclose(outf);

  return(1);
}

int usage(){
   fprintf(stdout,"\n");
   fprintf(stdout,"xh_beamform stacks energy over backazimuth and incidence angle.\n");
   fprintf(stdout,"\n");
   fprintf(stdout,"Default usage :\n");
   fprintf(stdout,"xh_beamform XH_IN baz_min baz_max baz_inc i_min i_max i_inc OUTPUT\n");
   fprintf(stdout,"\n");
   fprintf(stdout,"XH_IN         : input xh file\n");
   fprintf(stdout,"baz_min/max   : min/max back azimuth to scan (int)\n");
   fprintf(stdout,"baz_inc       : baz increment (int)\n");
   fprintf(stdout,"i_min/max     : min/max incidence angle to scan (int)\n");
   fprintf(stdout,"i_inc         : incidence angle increment)\n");
   fprintf(stdout,"OUTPUT        : Name of n-th root output file\n");
   fprintf(stdout,"\n");
   return(-1);
}
