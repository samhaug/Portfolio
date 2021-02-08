#include <stdio.h>
#include <math.h>


float epdist(stlat,stlon,evlat,evlon)

    float stlat, stlon, evlat,evlon;
{

float theta1, theta2, phi1, phi2;

float sin_t1;
float sin_t2;
float cos_t1;
float cos_t2;
float R, cosR;
float arc;

float deg2rad = 3.1415927/180.;

theta1 = evlat*deg2rad;
phi1   = evlon*deg2rad;
theta2 = stlat*deg2rad;
phi2   = stlon*deg2rad;
R      = phi1-phi2;

sin_t1 = sin(theta1);
sin_t2 = sin(theta2);
cos_t1 = cos(theta1);
cos_t2 = cos(theta2);
cosR   = cos(R);

arc = cos_t1*cos_t2 * cosR + sin_t1*sin_t2;
arc = acos(arc);
arc = arc/deg2rad;

// fprintf(stdout,"In EPDIST: Angular distance = %6.2f degrees\n", arc);

return(arc);

}
