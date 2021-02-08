#include <string.h>
#include <stdio.h>
#include <math.h>

#define npts_dat 8192  /* Maximum number of samples in time series */
#define npts_crc 4000  /* Maximum number of samples in traces used in cross_correlation  */

main(argc,argv)
int     argc;
char    **argv;
{

/* --- Declarations: -------------------------------------------------*/

float           data[npts_dat], env_data[npts_dat], synt[npts_dat], crcor[npts_crc];
float           t1[npts_crc], t2[npts_crc], t3[npts_crc];
float           startsec=0.;
float           stlat,stlon,  evlat,evlon,evdep=0., gcarc;
float           dt, new_dt, timeshift, timeuncert, Amp1, Amp2, Fit, Wvshape;
float           Z_noise, L_noise, T_noise;
float           P_amp, PP_amp, PPP_amp, S_amp, ScS_amp, SS_amp, SSS_amp, SKS_amp;
float           max, maxamp;
float           bandpass[4];
float           signaltonoise, envAmpRatio, noise_window;

int             i, j, k, n1, n2, n3, n4, pagenum, index;
int             iCrcorMax = 1, iTraceMax = 1, Meas = 1;
int             nsamp, n_crc, maxshift, window_new;
int             i_record = 0, i_tables = 0, i_data, i_synt;

char            datcode[8], phase[8];
char            ss[120], revname[120], gmtfile[120];
char            stnam[6], chnam[6];
char            colour[9], string[9]; 


FILE           *fopen(),*ifl, *gmt, *log;
/*--------------------------------------------------------------------*/



/* --- Command line input: -------------------------------------------*/
if (argc < 2 ){
  fprintf(stderr,"Usage: review [ -i revname ]\n");
  exit( -1 );
}

while ( ++index < argc && argv[index][0] == '-' ) {
   switch ( argv[index][1] ) {
      case 'i':
           if ( sscanf( argv[++index], "%s", revname ) != 1 ) {
               fprintf(stderr, "ERROR: Illegal parameter file name ...\n" );
               exit( -1 );
           }
           break;
       default:
           fprintf( stderr, "Usage: review [ -i revname ]\n");
           exit( -1 );
   }
}
/*--------------------------------------------------------------------*/

/*--  Get parameters:-------------------------------------------------*/
k = strspace(revname); revname[k] = '\0';
if ( (ifl = fopen(revname,"r")) == NULL ){
           fprintf(stderr," INPUT: %s cannot be opened ...\n", revname);
           exit(-1.);
}
log = fopen("review.log","w");

k = 0;
pagenum = 0;
while ( fgets(ss,120,ifl) != NULL ) {
  k=k+1;
  if (k == 1) pagenum = pagenum + 1;
  if (pagenum > 20) exit(-1);
  sscanf(ss,"%s %s",phase, datcode);
  i = strspace(datcode); datcode[i] = '\0';
  i = strspace(stnam);   stnam[i]   = '\0';
  i = strspace(chnam);   chnam[i]   = '\0';
  i = strspace(phase);   phase[i]   = '\0';
  fgets(ss,120,ifl);
  sscanf(ss,"%*s %f %f %f %f",&bandpass[0],&bandpass[1],&bandpass[2],&bandpass[3]);
  fgets(ss,120,ifl);
  sscanf(ss,"%*s %f %*s %f", &startsec, &dt);
  fgets(ss,120,ifl);
  sscanf(ss,"%*s %f %f %f",  &evlat, &evlon, &evdep);
  fgets(ss,120,ifl);
  sscanf(ss,"%s %s %f %f %f", stnam, chnam, &stlat, &stlon, &gcarc);
  fgets(ss,120,ifl);
  sscanf(ss,"%*s %f %*s %f %f", &envAmpRatio,&signaltonoise,&noise_window);
  if (pagenum >= 30) {
  fprintf(stdout,"ss= %s \n", ss);
  fprintf(stdout,"\n------------------------------------------------------------\n");
  fprintf(stdout,"%s %s Lat= %5.1f Lon= %6.1f Gcarc= %5.1f",stnam,chnam,stlat,stlon,gcarc);
  fprintf(stdout,"           %s\n",phase);
  }
  fprintf(log,"\n------------------------------------------------------------\n");
  fprintf(log,"%s %s Lat= %5.1f Lon= %6.1f Gcarc= %5.1f",stnam,chnam,stlat,stlon,gcarc);
  fprintf(log,"           %s\n",phase);

  /*-------- DATA and SYNTHETICS ----------------*/
  n1 = nint(150./dt)/2;
  n2 = nint(250./dt)/2;
  for (i= -n1; i<= n2; ++i) {
      fgets(ss,120,ifl);
      sscanf(ss,"%*f %f %f %f",&data[i+n1],&env_data[i+n1],&synt[i+n1]);
  }
  maxamp = 0.;
  for(i= -n1; i<= n2; ++i) {
     if ( fabs(data[i+n1]) > maxamp ) maxamp = fabs(data[i+n1]);
     if ( fabs(synt[i+n1]) > maxamp ) maxamp = fabs(synt[i+n1]);
  }
  for(i= -n1; i<= n2; ++i) {
     data[i+n1] = data[i+n1]/maxamp;
     synt[i+n1] = synt[i+n1]/maxamp,
     env_data[i+n1] = env_data[i+n1]/maxamp;
  }

  fgets(ss,120,ifl);
  sscanf(ss,"%f %d %d",   &new_dt, &maxshift, &window_new);

  /*------- CROSS CORRELATION FUNCTION ----------*/
  n3 = maxshift/10;
  for (i= -n3; i<= n3; ++i) {
      fgets(ss,120,ifl);
      sscanf(ss,"%*f %f",&crcor[i+n3]);
  }
  maxamp = 0.;
  for(i= -n3; i<= n3; ++i) {
     if ( fabs(crcor[i+n3]) > maxamp ) maxamp = fabs(crcor[i+n3]);
  }
  for(i= -n3; i<= n3; ++i)
     crcor[i+n3] = crcor[i+n3]/maxamp; 
   
  /*------- T1, T2, and T3 ----------------------*/
  n4 = 2*window_new/10;
  for (i= 0; i<= n4; ++i) {
      fgets(ss,120,ifl);
      sscanf(ss,"%*f %f %f %f",&t1[i], &t2[i], &t3[i]);
  }
  fgets(ss,120,ifl);
  sscanf(ss,"%f %f %f %f %f %f %d %d %d",&timeshift, &timeuncert, &Fit, &Amp2, &Amp1,
              &Wvshape, &iCrcorMax, &iTraceMax, &Meas);
  maxamp = 0.;
  for(i= 0; i<= n4; ++i) {
     if ( fabs(t1[i]) > maxamp ) maxamp = fabs(t1[i]);
     if ( fabs(t2[i]) > maxamp ) maxamp = fabs(t2[i]);
     if ( fabs(t3[i]) > maxamp ) maxamp = fabs(t3[i]);
  }
  for(i= 0; i<= n4; ++i) {
     t1[i] = t1[i] / maxamp;
     t2[i] = t2[i] / maxamp;
     t3[i] = t3[i] / maxamp;
  }

  if ( envAmpRatio     < 1.599) {
    Meas = 0;
    fprintf(log,"Meas= 0 because envAmpRatio= %6.2f is less than 1.499\n",envAmpRatio);
  }
  if ( signaltonoise   < 1.599) {
    Meas = 0;
    fprintf(log,"Meas= 0 because signaltonoise= %6.2f is less than 1.499\n",signaltonoise);
  }
  if ( fabs(timeshift) > 20.) {
    Meas = 0;
    fprintf(log,"Meas= 0 because ABS-timeshift= %6.2f is more than 20\n",timeshift);
  }
  if (      timeuncert > 10.) {
    Meas = 0;
    fprintf(log,"Meas= 0 because timeuncert= %6.2f is more than 10\n",timeuncert);
  }
  if (    iCrcorMax          ) {
    Meas = 0;
    fprintf(log,"Meas= 0 because ICrcorMax = %d \n",iCrcorMax);
  }
  if (    iTraceMax          ) {
    Meas = 0;
    fprintf(log,"Meas= 0 because ITraceMax = %d \n",iTraceMax);
  }
  if ( Amp2 > 2.5 || Amp2 < 0.4) {
    Meas = 0;
    fprintf(log,"Meas= 0 because Amp2= %6.2f is less than 0.4 or more than 2.5\n",Amp2);
  }
  if ( Fit     < 0.749) {
    Meas = 0;
    fprintf(log,"Meas= 0 because Fit= %6.2f is less than 0.709\n",Fit);
  }
  if ( Wvshape < 0.709) {
    Meas = 0;
    fprintf(log,"Meas= 0 because Wvshape= %6.2f is less than 0.709\n",Fit);
  }
   
  /*--------------------------------------------------------------------*/
  if (k==1) {
    sprintf(gmtfile,"%s.gmt.%d",datcode,pagenum);
    gmt=fopen(gmtfile,"w");
    fprintf(gmt,"#!/bin/csh -f\n");
    fprintf(gmt,"\n");
    fprintf(gmt,"set ooo = \"-P -K\"\n");
    fprintf(gmt,"#-- Data and Synts\n");
    fprintf(gmt,"\n");
    fprintf(gmt,"set Frame = \"/work/jeroen/my_src/AutoPicker/Lib\"\n");
    fprintf(gmt,"\n");
    fprintf(gmt,"\n");
    fprintf(gmt,"set reg1  = -R-150/250/-1.32/1.32\n");
    fprintf(gmt,"set proj1 = -Jx0.005/0.31\n");
    fprintf(gmt,"\n");
    fprintf(gmt,"set reg2  = -R-40/40/-1.32/1.32\n");
    fprintf(gmt,"set proj2 = -Jx0.0225/0.31\n");
    fprintf(gmt,"\n");
    fprintf(gmt,"set reg3  = -R-30/30/-0.32/1.32\n");
    fprintf(gmt,"set proj3 = -Jx0.025/0.4990243\n");
    fprintf(gmt,"\n");
    fprintf(gmt,"#-- Make PostScript header: --------------------------------------------\n");
    fprintf(gmt,"pstext $reg1 $proj1 << END -X0.4 -Y9.5    $ooo > plot.ps\n");
    fprintf(gmt,"END\n");
    fprintf(gmt,"#-----------------------------------------------------------------------\n");
    fprintf(gmt,"\n");
  }

  fprintf(gmt,"#-----------------------------------------------------------------------\n");
  if (k==1) {
  fprintf(gmt,"psxy   $Frame/frame1        $reg1 $proj1                 -M -W2     -O $ooo   >> plot.ps\n");
  } else {
  fprintf(gmt,"psxy   $Frame/frame1        $reg1 $proj1 -X-4.0 -Y-1.00  -M -W2     -O $ooo   >> plot.ps\n");
  }
  fprintf(gmt,"pstext $Frame/frame1_labels $reg1 $proj1                         -N -O $ooo   >> plot.ps\n");
  fprintf(gmt,"psxy   << END        $reg1 $proj1                  -W1       -O $ooo   >> plot.ps\n");
  for(i= -n1; i<= n2; ++i) fprintf(gmt,"%5.1f %5.2f\n", i*dt*2, data[i+n1]+0.10);
  fprintf(gmt,"END\n");
  fprintf(gmt,"psxy   << END        $reg1 $proj1                  -W0/200   -O $ooo   >> plot.ps\n");
  for(i= -n1; i<= n2; ++i) fprintf(gmt,"%5.1f %5.2f\n", i*dt*2, env_data[i+n1]+0.13);
  fprintf(gmt,"END\n");
  fprintf(gmt,"psxy   << END        $reg1 $proj1                  -W1ta     -O $ooo   >> plot.ps\n");
  for(i= -n1; i<= n2; ++i) fprintf(gmt,"%5.1f %5.2f\n", i*dt*2, synt[i+n1]-0.10);
  fprintf(gmt,"END\n");
  fprintf(gmt,"\n");
  fprintf(gmt,"\n");
  fprintf(gmt,"psxy   $Frame/frame2        $reg2 $proj2 -X2.1 -M -W2 -O $ooo   >> plot.ps\n");
  fprintf(gmt,"pstext $Frame/frame2_labels $reg2 $proj2           -N -O $ooo   >> plot.ps\n");
  fprintf(gmt,"psxy   << END        $reg2 $proj2          -W2 -O $ooo   >> plot.ps\n");
  for(i= 0; i<= n4; ++i) fprintf(gmt,"%5.1f %5.2f\n", 10*i*new_dt-window_new/10, t1[i]);
  fprintf(gmt,"END\n");
  fprintf(gmt,"psxy   << END        $reg2 $proj2          -W2/200 -O $ooo   >> plot.ps\n");
  for(i= 0; i<= n4; ++i) fprintf(gmt,"%5.1f %5.2f\n", 10*i*new_dt-window_new/10, t2[i]);
  fprintf(gmt,"END\n");
  fprintf(gmt,"psxy   << END        $reg2 $proj2          -W1/ta  -O $ooo   >> plot.ps\n");
  for(i= 0; i<= n4; ++i) fprintf(gmt,"%5.1f %5.2f\n", 10*i*new_dt-window_new/10, t3[i]);
  fprintf(gmt,"END\n");
  fprintf(gmt,"\n");

  if (Meas == 1) {
    sprintf(string,"Accepted");
    sprintf(colour,"0/230/0");
  } else {
    sprintf(string,"Rejected");
    sprintf(colour,"230/0/0");
  }
  colour[8] = '\0';
  string[8] = '\0';
  fprintf(gmt,"pstext << END $reg2 $proj2 -G%7s  -N -O $ooo   >> plot.ps\n", colour);
  fprintf(gmt,"180  1.10  8 0 3 TL %8s\n", string);
  fprintf(gmt,"END\n");

  fprintf(gmt,"pstext << END $reg2 $proj2           -N -O $ooo   >> plot.ps\n");
  if (k == 1) {
    fprintf(gmt," 186 1.80 10 0 2 BL Page %d\n", pagenum);
    fprintf(gmt,"-113 1.40 10 0 1 BL %s\n", datcode);
    fprintf(gmt,"-83  1.40  7 0 0 BL [%5.1f, %6.1f, %5.1f]\n", evlat,evlon,evdep);
  }
  fprintf(gmt," 120 1.35  7 0 1 TL %s\n",phase);
  fprintf(gmt," 120  1.00  7 0 0 TL %4s     @~D@~ = %5.1f@+o@+\n", stnam, gcarc);
  fprintf(gmt," 120  0.60  7 0 0 TL SN ratio= %6.1f   Window= %6.1fs\n",signaltonoise,noise_window);
  fprintf(gmt," 120  0.30  7 0 0 TL envAmpRatio= %4.1f\n", envAmpRatio);
  fprintf(gmt," 120  0.00  7 0 0 TL TimeShift= %4.1fs   [+-%4.1fs]\n",timeshift,timeuncert);
  fprintf(gmt," 120 -0.30  7 0 1 TL Fit= %2d%%\n",nint(Fit*100.));
  fprintf(gmt," 120 -0.60  7 0 0 TL A2= %5.2f   A1= %5.2f\n",Amp2,Amp1);
  fprintf(gmt," 120 -0.90  7 0 1 TL WvShape= %2d%%\n",nint(Wvshape*100.));
  fprintf(gmt," 120 -1.20  7 0 0 TL CrcorMax= %d  TraceMax= %d\n",iCrcorMax,iTraceMax);
  fprintf(gmt,"END\n");
  fprintf(gmt,"psxy   $Frame/frame3        $reg3 $proj3 -X1.9 -M -W2 -O $ooo   >> plot.ps\n");
  fprintf(gmt,"pstext $Frame/frame3_labels $reg3 $proj3           -N -O $ooo   >> plot.ps\n");
  fprintf(gmt,"psxy   << END        $reg3 $proj3          -W4 -O $ooo   >> plot.ps\n");
  for(i= -n3; i<= n3; ++i) fprintf(gmt,"%5.1f %5.2f\n", 10*i*new_dt, crcor[i+n3]);
  fprintf(gmt,"END\n");
  fprintf(gmt,"psxy   << END        $reg3 $proj3       -M -W0 -O $ooo   >> plot.ps\n");
  fprintf(gmt,">\n");
  fprintf(gmt,"-30 0\n");
  fprintf(gmt," 30 0\n");
  fprintf(gmt,">\n");
  fprintf(gmt,"-30 0.5\n");
  fprintf(gmt," 30 0.5\n");
  fprintf(gmt,">\n");
  fprintf(gmt,"  0 -0.32\n");
  fprintf(gmt,"  0  1.32\n");
  fprintf(gmt,"END\n");
  
  fprintf(gmt,"pstext $Frame/frame3_labels $reg3 $proj3           -N -O $ooo   >> plot.ps\n");
  fprintf(gmt,"\n");
  if (k==10) { 
    fprintf(gmt,"finps >> plot.ps\n");
    fprintf(gmt,"\n");
    fprintf(gmt,"\n");
    fprintf(gmt,"mv plot.ps %s.%d.ps\n",revname,pagenum);
    fclose(gmt);
    k = 0;
  }
}
fprintf(stdout,"ZZZ: k= %d pagenum= %d\n", k, pagenum);
if (k!=10) {
    fprintf(gmt,"finps >> plot.ps\n");
    fprintf(gmt,"\n");
    fprintf(gmt,"\n");
    fprintf(gmt,"mv plot.ps %s.%d.ps\n",revname,pagenum);
    fclose(gmt);
}
fclose(ifl);
}
