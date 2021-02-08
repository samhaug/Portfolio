      subroutine sphars(l,theta,caz,saz,epc,icomp,x,y)
      save
      complex epc(4),x(8),y(8),xx,yy
      common/inter/ knt,xj,zz1,zz2
      dimension z(4),zp(4),zpp(4),x1(12),x2(8)
      equivalence (z(1),x1(1)),(zp(1),x1(5)),(zpp(1),x1(9)),(x1(5),
     1x2(1))
      data fpi/12.5663706/
      call fvclr(x1,1,12)
      ct=cos(theta)
      st=sin(theta)
      cosec=1./st
      m=min0(l,3)
      lp1=l+1
      mp1=m+1
      zl=l
      fct=(2.*zl+1.)/fpi
      fl3=zl*(zl+1.)
      cot=ct/st
      if(l.gt.2) go to 20
      go to(22,23,24),lp1
   22 z(1)=fct
      go to 28
   23 z(1)=ct*fct
      zp(1)=-st*fct
      z(2)=zp(1)
      zp(2)=-.5*z(1)*fl3
      if(l.eq.1) go to 27
   24 zz1=1.
      zz2=ct
   20 z3=((2.*zl-1.)*ct*zz2-(zl-1.)*zz1)/zl
      zz1=zz2
      zz2=z3
      z3=zz2*fct
      z(1)=z3
      z2=zl*(zz1-ct*zz2)*fct*cosec
      zp(1)=-z2
      zp(2)=cot*z2-fl3*z3
      z(2)=-z2
      z2=-z2
      z1=z3
      fct=1.
      do 25 i=3,mp1
      fct=0.5*fct
      zm=i-1
      z3=-(2.*(zm-1.)*cot*z2+(zl-zm+2.)*(zl+zm-1.)*z1)
      z(i)=z3*fct
      zp(i)=-fct*((zl+zm)*(zl-zm+1.)*z2+zm*cot*z3)
      z1=z2
   25 z2=z3
   27 do 26 i=1,mp1
   26 zpp(i)=cot*zp(i)-(fl3-(float(i-1)*cosec)**2)*z(i)
   28 do 1 i=1,8
      k=mod(i-1,4)+1
      if(icomp.gt.1) go to 2
      x(i)=x1(i)*epc(k)
      y(i)=(0.,0.)
      go to 1
    2 xm=k-1
      xx=x2(i)*epc(k)
      yy=epc(k)*cmplx(0.,xm*x1(i)*cosec)
      x(i)=-caz*xx-saz*yy
      y(i)=saz*xx-caz*yy
    1 continue
      return
      end
