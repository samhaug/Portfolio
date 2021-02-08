c -----------------------------------------------------------
      subroutine dctp(x,y,z,theta,phi)
c     this subroutine assumes the length of vector (x,y,z) to be 1.

      implicit double precision(a-h,o-z)
 
      tpi=8.*atan(1.)
      ff=360./tpi
 
      th=asin(z)
      ph=atan2(y,x)
      theta=th*ff
      phi=ph*ff
 
      end
 
c ------------------------------------------------------------

