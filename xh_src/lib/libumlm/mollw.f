      subroutine mollw(xlat,xlon,x,y)
      dimension rotmat(3,3)
      common/csplin/ n,arg(300),c(300),qarg(3,300)
      data pi/3.1415926536/,ifirst/1/,rad/1.7453293e-02/,sqrt2/1.4142136/
      if(ifirst.eq.1) call ctable
      ifirst=0
      xlar=xlat*rad
      xlor=xlon*rad
      xar=xlor-pi
      yar=abs(xlar)
      cc=rsple(1,n,arg,c,qarg,yar)
      y=sqrt2*sin(cc)
      if(xlar.lt.0.) y=-y
      x=2.*sqrt2*xar*cos(cc)/pi
      x=x*63.63961+180.
      y=y*63.63961
      return
      end
