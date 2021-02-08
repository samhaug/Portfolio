#include <stdio.h>
#include <string.h>
#include <math.h>
#include "xhhead.h"

#define npts_dat 32768  /* Maximum number of samples in time series */
#define npts_crc 4000  /* Maximum number of samples in traces used in cross_correlation  */

/* 
   Check the compatibility of AH headers of SYNTHETIC and DATA
   and verify the whether they obey the input conditions:
*/

int check_xh(h_dat,h_syn)

        xhhed     h_dat, h_syn;
{

          int       i, icheck = 1;
          int       dat_n, syn_n;
          float     z;
          char      stnam[8], chnam[8];

/* STATION AND CHANNEL CODES:  --------------------*/
fprintf(stdout,"q1 h_data stnm= %s\n", h_dat.stnm);
strcpy(stnam,h_dat.stnm);
fprintf(stdout,"q2\n");
strcpy(chnam,h_dat.chan);
fprintf(stdout,"q3\n");

dat_n = h_dat.ndata;
syn_n = h_syn.ndata;
if (dat_n > npts_dat) { 
  fprintf(stderr,"%s [%s] Nsamp [=%d] of DATA is larger than NPTS_dat [=%d]\n",stnam,chnam,dat_n,npts_dat);
  icheck = 0;
}
if (syn_n > npts_dat) { 
  fprintf(stderr,"%s [%s] Nsamp [=%d] of SYNT is larger than NPTS_dat [=%d]\n",stnam,chnam,syn_n,npts_dat);
  icheck = 0;
}

// if (h_dat.tstart.yr  != h_syn.tstart.yr)  {
//   fprintf(stderr,"Year  [=%d] of Data is not Year  [%d] of Synt\n",
//                  h_dat.tstart.yr, h_syn.tstart.yr);
//   icheck = 0;
// }
// if (h_dat.tstart.mo  != h_syn.tstart.mo)  {
//   fprintf(stderr,"Month [=%d] of Data is not Month [%d] of Synt\n",
//                  h_dat.tstart.mo, h_syn.tstart.mo);
//   icheck = 0;
// }
// 
// 
// z =     (h_dat.tstart.day - h_syn.tstart.day) * 24. * 3600.;
// z = z + (h_dat.tstart.hr  - h_syn.tstart.hr) * 3600.;
// z = z + (h_dat.tstart.mn  - h_syn.tstart.mn) * 60.;
// z = z +  h_dat.tstart.sec - h_syn.tstart.sec;
// z = fabs(z);
// if ( z > 0.01) {
//   fprintf(stderr,"%s [%s] Sec of Data and Synt differ by %5.1f seconds\n",
//          h_dat.stnm, h_dat.chan, z);
//   icheck = 0;
// 
// }

// if (strncmp(h_dat.stnm,h_syn.stnm,3) != 0) {
//   fprintf(stderr,"DATA stnm [=%s] is not SYN stnm [%s]\n",h_dat.stnm,h_syn.stnm);
//   icheck = 0;
// }

if (strncmp(h_dat.chan,h_syn.chan,3) != 0) {
  fprintf(stderr,"DATA chan [=%s] is not SYN chan [%s]\n",h_dat.chan,h_syn.chan);
  icheck = 0;
}

return( icheck );
}
