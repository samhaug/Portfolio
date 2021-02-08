/*
 * noise level  - Determines the maximum peak-to-trough (/2)
                  signal amplitude between
                 FIRST arrival minus i250s and FIRST arrival minus i80s
 *
 */

#include <stdio.h>
#include <string.h>
#include <math.h>

extern int i80s, i100s, i250s;
extern float dt;


void noiselevel(Sample, data, noise, noise_window, noise_windowMin,log)

   int      Sample;
   float   *data;
   float    noise_windowMin;
   float   *noise, *noise_window;
   FILE    *log;
{

int i1, i2;
int i, j, k;
float recmax;

// fprintf(stdout,"IN NOISELEVEL: Sample= %d\n", Sample);
// fprintf(stdout,"data1500= %f\n", data[1500]);

i1 = Sample - i250s;
if (i1 < i80s) i1 = i80s;
i2 = Sample - i80s;

// fprintf(stdout,"in NOISELEVEL: i1= %d i2= %d\n",i1,i2);

if (i1 < 0 || i2 < 0) {
   /* fprintf(stderr,"in NOISELEVEL: i1= %d i2= %d smaller than 0\n",i1, i2); */
  *noise = 0.;
} else {
  *noise_window = (i2 - i1) * dt;

  /*--- Peak-to-trough noise level --------------*/
  recmax = 0.;
  for(i=i1; i< i2; ++i) {
    recmax = recmax + fabsf(data[i]);
  }
  *noise = recmax/(i2-i1);
}

// fprintf(stdout,"recmax= %7.1f i2-i1= %d\n", recmax, i2-i1);
// fprintf(stdout,"NoiseLevel= %e measured over %6.1f sec [min= %5.1fs]\n",
//             *noise, *noise_window, noise_windowMin);
fprintf(log,"NoiseLevel= %e measured over %6.1f sec [min= %5.1fs]\n",
            *noise, *noise_window, noise_windowMin);

return;
}
