#include	<stdio.h>
#include  <stdlib.h>
#include	<math.h>

#define deg_to_rad 0.017453292
#define rad_to_deg 57.29577951

float           lat1, lon1, delta, az;


int distaz2latlon(lat1,lon1,delta,az,lat2,lon2)
  float           lat1, lon1,delta,az;
  float          *lat2,*lon2;
  {
    float		theta, ct, st, phi, cp, sp, bearing;
    float		cb, sb, cd, sd;
    float		ez, ex, ey;
    float		radius;

    radius = 6378.2064;
    theta = deg_to_rad * lat1;
    ct = cos(theta);
    st = sin(theta);
    phi = deg_to_rad * lon1;
    cp = cos(phi);
    sp = sin(phi);
    bearing = deg_to_rad * az;
    delta = deg_to_rad * delta;
    cb = cos(bearing);
    sb = sin(bearing);
    cd = cos(delta);
    sd = sin(delta);
    ez = cd * st + sd * cb * ct;
    ey = cd * ct * cp + sd * (-cb * st * cp - sb * sp);
    ex = cd * ct * sp + sd * (-cb * st * sp + sb * cp);

    *lat2 = (float) (rad_to_deg * atan2(ez, sqrt(ex * ex + ey * ey)));
    *lon2 = (float) (rad_to_deg * atan2(ex, ey));

    // fprintf(stdout,"in distaz2latlon(): %8.3f %8.3f\n", *lat2, *lon2);

    return (1);
}
