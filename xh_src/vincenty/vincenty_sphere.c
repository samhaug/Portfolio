#include <math.h>
#include <stdio.h>
#include <stdlib.h>

/* Vincenty's formulae are two related iterative methods used 
 * in geodesy to calculate the distance between two points on 
 * the surface of a spheroid. See wikipedia for details.
 * 
 * Samuel M. Haugland Apr 03 2019
 *
 */

int vincenty_direct_sphere(double,double,double,double,double,double *,double *,double *);
int vincenty_inverse_sphere(double,double,double,double,double,double *,double *,double *);

//length of semi-major axis of the ellipsoid (radius at equator)
//static double a = 6378137.0;
//flattening of the ellipsoid
//static double f = 1/298.257223563;
static double f = 0.0;
//length of semi-minor axis of the ellipsoid (radius at the poles)
//static double b = 6356752.314245;

int vincenty_direct_sphere(double phi1,double lambda1,double alpha12,double s, double a,
                    double *phi2,double *lambda2,double *alpha21){
    // given initial starting point, distance, and bearing, calculate
    // new coordinate

    double b=a;
    double piD4,two_pi,TanU1,U1,sigma1,Sinalpha,
           cosalpha_sq,u2,A,B,sigma,last_sigma,two_sigma_m,delta_sigma,
           lambda,C,omega;

    piD4=atan(1.0);
    two_pi = piD4*8.0;
    phi1 = phi1*piD4/45.0;
    lambda1 = lambda1*piD4/45.0;
    alpha12 = alpha12*piD4/45.0;
    if (alpha12 < 0.0){ 
        alpha12 = alpha12+two_pi;
    }
    if (alpha12 > two_pi){
        alpha12 = alpha12-two_pi;
    }
    TanU1 = (1-f) * tan(phi1);
    U1 = atan(TanU1);
    sigma1 = atan2(TanU1,cos(alpha12));
    Sinalpha = cos(U1)*sin(alpha12);
    cosalpha_sq = 1.0 - Sinalpha * Sinalpha;
    u2 = cosalpha_sq*(a*a -b*b)/(b*b);
    A = 1.0+(u2/16384)*(4096+u2*(-768+u2*(320-175*u2)));
    B = (u2/1024)*(256+u2*(-128+u2*(74-47*u2)));
    // Starting with the approx 
    sigma = (s/(b*A));
    last_sigma = 2.0*sigma+2.0;  // something impossible 
    // Iterate the following 3 eqs unitl no sig change in sigma 
    // two_sigma_m , delta_sigma 
    while (fabs((last_sigma-sigma)/sigma)>1.0e-9){
        two_sigma_m = 2*sigma1+sigma;
        delta_sigma = B*sin(sigma)*(cos(two_sigma_m) 
                +(B/4)*(cos(sigma)* 
                (-1+2*pow(cos(two_sigma_m),2)-  
                (B/6)*cos(two_sigma_m)* 
                (-3+4*pow(sin(sigma),2))*  
                (-3+4*pow(cos(two_sigma_m),2)))));
        last_sigma = sigma;
        sigma = (s/(b*A))+delta_sigma;
    }

    *phi2 = atan2((sin(U1)*cos(sigma)+
           cos(U1)*sin(sigma)*cos(alpha12)),
           ((1-f)*sqrt(pow(Sinalpha,2)+
           pow(sin(U1)*sin(sigma)-cos(U1)*
           cos(sigma)*cos(alpha12),2))));
    lambda = atan2((sin(sigma)*sin(alpha12)),
             (cos(U1)*cos(sigma)-
             sin(U1)*sin(sigma)*cos(alpha12)));
    C = (f/16)*cosalpha_sq*(4+f*(4-3*cosalpha_sq));
    omega = lambda-(1-C)*f*Sinalpha*
            (sigma+C*sin(sigma)*(cos(two_sigma_m)+
            C*cos(sigma)*(-1+2*
            pow(cos(two_sigma_m),2))));
    *lambda2 = lambda1+omega;
    *alpha21 = atan2(Sinalpha,(-sin(U1)*
              sin(sigma)+
              cos(U1)*cos(sigma)*cos(alpha12)));
    *alpha21 = *alpha21+two_pi/2.0;
    if (*alpha21 < 0.0){
        *alpha21 = *alpha21+two_pi;
    }
    if (*alpha21 > two_pi){
        *alpha21 = *alpha21-two_pi;
    }

    *phi2 = *phi2 * 45.0 / piD4;
    *lambda2 = *lambda2*45.0/piD4;
    *alpha21 = *alpha21*45.0/piD4;
    return(1);
}

int vincenty_inverse_sphere(double phi_1,double L_1,double phi_2,double L_2, double a,
                     double *alpha1,double *alpha2,double *dist){
    double u_1,u_2,Lambda,sin_u1,cos_u1,sin_u2,cos_u2,cos_lambda,sin_lambda,
           sin_sigma,cos_sigma,sigma,sin_alpha,cos_sq_alpha,cos2_sigma_m,
           C,Lambda_prev,u_sq,A,B,delta_sig,m,L;
    double tol=pow(10,-12);
    double b=a;
    int i,iters; 
    int maxIter=200;

    // given two coordinates, calculate distance az and baz.

    phi_1 = phi_1*M_PI/180.;
    L_1   = L_1*M_PI/180.;
    phi_2 = phi_2*M_PI/180.;
    L_2   = L_2*M_PI/180.;

    u_1 = atan((1-f)*tan(phi_1));
    u_2 = atan((1-f)*tan(phi_2));
    L = L_2-L_1;
    Lambda =L; 

    sin_u1=sin(u_1);
    cos_u1=cos(u_1);
    sin_u2=sin(u_2);
    cos_u2=cos(u_2);

    iters = 0;
    for (i=0;i,i<maxIter;i++){
        iters++;
        cos_lambda=cos(Lambda);
        sin_lambda=sin(Lambda);
        sin_sigma=sqrt(pow((cos_u2*sin(Lambda)),2)+
                  pow((cos_u1*sin_u2-sin_u1*cos_u2*cos_lambda),2));
        cos_sigma=sin_u1*sin_u2+cos_u1*cos_u2*cos_lambda;
        sigma=atan2(sin_sigma,cos_sigma);
        sin_alpha=(cos_u1*cos_u2*sin_lambda)/sin_sigma;
        cos_sq_alpha=1-pow(sin_alpha,2);
        cos2_sigma_m=cos_sigma-((2*sin_u1*sin_u2)/cos_sq_alpha);
        C=(f/16)*cos_sq_alpha*(4+f*(4-3*cos_sq_alpha));
        Lambda_prev=Lambda;
        Lambda=L+(1-C)*f*sin_alpha*(sigma+C*sin_sigma*
               (cos2_sigma_m+C*cos_sigma*(-1+2*pow(cos2_sigma_m,2))));
        if (fabs(Lambda_prev-Lambda) <=tol){
            break;
        }
    }
    u_sq=cos_sq_alpha*((pow(a,2)-pow(b,2))/pow(b,2));
    A=1+(u_sq/16384)*(4096+u_sq*(-768+u_sq*(320-175*u_sq)));
    B=(u_sq/1024)*(256+u_sq*(-128+u_sq*(74-47*u_sq)));
    delta_sig=B*sin_sigma*(cos2_sigma_m+0.25*B*
              (cos_sigma*(-1+2*pow(cos2_sigma_m,2))-
              (1/6)*B*cos2_sigma_m*(-3+4*pow(sin_sigma,2))*
              (-3+4*pow(cos2_sigma_m,2))));

    *dist = b*A*(sigma-delta_sig);
    *alpha1 = (180./M_PI)*atan2(cos_u2*sin_lambda,
                cos_u1*sin_u2-sin_u1*cos_u2*cos_lambda);
    *alpha2 = (180./M_PI)*atan2(cos_u1*sin_lambda,
               -1*sin_u1*cos_u2+cos_u1*sin_u2*cos_lambda)+180;
    return(1);
}

