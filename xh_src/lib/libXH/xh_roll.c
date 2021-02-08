
/* Roll seismogram of n elements forwards or backwards by r samples*/
/* Effect similar to numpy.roll */


int roll(float x_in[], float x_roll[], int n, int r){
  int i;
  if (r == 0){
    for(i=0; i<n; i++){
      x_roll[i] = x_in[i];
    }
  }

  else{
    for(i=0; i<n; i++){
      if (i+r < 0){
          x_roll[(i+r)+n] = x_in[i];
      }
      else if (i+r < n && i+r >= 0){
          x_roll[(i+r)] = x_in[i];
      }
      else if (i+r >= n){
          x_roll[(i+r)-n] = x_in[i];
      }
    }
  }
  return(1);
}
