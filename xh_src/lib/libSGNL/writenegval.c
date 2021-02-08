#include <stdio.h>
#include <math.h>

/* 
       Takes the data file x-y and writes
          x-y if y<0
       and
          x-0 if y>0

       Useful when looking at record sections;
       fill in the waveform with negative polarities
*/

int writenegval(data, y, npts)
 	float data[];
 	float y[];
	int npts;
{

int i;


// loop over all samples
for (i=0; i<npts;i++) {
  if ( data[i] < 0.) {
    y[i] = data[i];
  } else {
    y[i] = 0.;
  }
}

return(1);

}
