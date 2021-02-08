      subroutine hammer(xlat,xlon,x,y)
      data pi/3.1415926536/,rad/1.7453293e-02/
      xlar=rad*xlat
      xlor=.5*rad*(xlon-180.)
      r=acos(amin1(1.,cos(xlar)*cos(xlor)))
      a1=cos(xlar)*sin(xlor)
      a2=sin(xlar)
      if(a1.ne.0..or.a2.ne.0.) then
        b=atan2(a1,a2)
      else
        b=0.
      endif
      r=2.*sin(0.5*r)
      x=2.*r*sin(b)*63.63961+180.
      y=r*cos(b)*63.63961
      return
      end
