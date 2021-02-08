cprog ylmint
      subroutine ylmint(xlat1,xlon1,xlat2,xlon2,lmax
     1   ,ylmh,ylmt,ylmh1,ylmt1,wk1,wk2,wk3,sar,d)
      double precision d(1),dcth
      complex fac,dfac,temp,temp1,ccon,cfctr,cfctr1,temp3,temp4
      dimension sar(1),wk1(1),wk2(1),wk3(1)
     1  ,ylmh(1),ylmt(1),ylmh1(1),ylmt1(1)
c
c     wk1,wk2,wk3 should be dimensioned at least (lmax+1)*4
c     and sar should be dimensioned at least (lmax+3)*4
c     d should be dimensioned at least (2*lmax+1)**2*8
c     ylmh,ylmt are in arrays of length (lmax+1)**2(*4)
c
      data radian/57.2957795/
c
      call pole(xlat1,xlon1,xlat2,xlon2,xlatp,xlonp,azmp,delta)
c
      del=delta/radian
      pib2=90./radian
      twopi=4.*pib2
      tcdel=2.*cos(del)
      tsdel=2.*sin(del)
      shdel=sin(.5*del)
      chdel=cos(.5*del)
      qdel=.25*del
      cth=(90.-xlatp)/radian
      dcth=cth
      cph=xlonp/radian
      phmp=(180.-azmp)/radian
c
      lm1=lmax+1
      lm3=lmax+3
      sar(1)=1.
      do 11 imp=2,lm3
      arg=float(imp-1)*del*.5
   11 sar(imp)=sin(arg)/arg
c
      ind=0
      do 10 il1=1,lm1
      l=il1-1
      itlp1=2*l+1
      fl3=float(l*il1)
c
      call legndr(pib2,l,l,wk1,wk2,wk3)
c
      call  rotmx2(l,l,dcth,d,itlp1,itlp1)
c
      fac=(1.,0.)
      dfac=cexp(cmplx(0.,cph))
c
      do 20 im=1,il1
      imc=im+l
      ibia=itlp1*(imc-1)
      temp=(0.,0.)
      temp1=(0.,0.)
      temp3=(0.,0.)
      temp4=(0.,0.)
c
      do 25 ic=1,itlp1
      mp=ic-il1
      fmp=float(mp)
      fmp2=fmp*fmp
      imp=iabs(mp)+1
      ssgn=1.
      if(mp.lt.0.and.(mp/2)*2.ne.mp) ssgn=-1.
      arg=fmp*phmp
      ccon=cmplx(0.,arg)
      ccon=cexp(ccon)
      imp2=iabs(mp+2)+1
      imm2=iabs(mp-2)+1
      imp1=iabs(mp+1)+1
      imm1=iabs(mp-1)+1
      smp2=sar(imp2)
      smm2=sar(imm2)
      smp1=sar(imp1)
      smm1=sar(imm1)
      sm=sar(imp)
      cfctr=(ssgn*d(ibia+ic))*ccon
      cfctr1=cfctr*wk2(imp)
      cfctr=cfctr*wk1(imp)
      temp=temp+cfctr*cmplx(-(fl3-fmp2)*(smp2+smm2-tcdel*sm)
     1     +fmp*(smp2-smm2),-tsdel*fmp*sm)
      if(mp.eq.2.or.mp.eq.-2)
     1 temp1=temp1-cfctr*(fl3-2.)
      if(mp.eq.0) temp1=temp1+cfctr*fl3*tcdel
      temp3=temp3+cfctr1*cmplx(shdel*(smp1+smm1),chdel*(smp1-smm1))
      if(mp.eq.1.or.mp.eq.-1)
     1   temp4=temp4+cfctr1*cmplx(shdel,-fmp*chdel)
   25 continue
c
      temp=qdel*temp*fac/tsdel
      temp1=pib2*temp1*fac/tsdel
      temp3=del*temp3*fac/tsdel
      temp4=twopi*temp4*fac/tsdel
      ind=ind+1
      ylmt(ind)=real(temp)
      ylmh(ind)=real(temp1)
      ylmt1(ind)=real(temp3)
      ylmh1(ind)=real(temp4)
      if(im.eq.1) goto 20
      ind=ind+1
      ylmt(ind)=aimag(temp)
      ylmh(ind)=aimag(temp1)
      ylmt1(ind)=aimag(temp3)
      ylmh1(ind)=aimag(temp4)
   20 fac=fac*dfac
c
   10 continue
      return
      end
