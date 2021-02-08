c ---------------------------------------------------------------
      subroutine cxyz(theta,phi,x,y,z)

      tpi=8.*atan(1.)
      ff=tpi/float(360)
      th=theta*ff
      ph=phi*ff
 
      z=sin(th)
      ct=cos(th)
      x=ct*cos(ph)
      y=ct*sin(ph)
 
      end
 
c -----------------------------------------------------------

