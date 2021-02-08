cprog ylmav
cxref
      subroutine ylmav(xlat1,xlon1,xlat2,xlon2,lmax,ylmh,ylmt
     1   ,wk1,wk2,wk3,sar,d)
      double precision d(1),dcth
      complex fac,dfac,temp,temp1,ccon
      dimension sar(1),wk1(1),wk2(1),wk3(1),ylmh(1),ylmt(1)
c
c     wk1,wk2,wk3,sar should be dimensioned at least (lmax+1)*4
c     d should be dimensioned at least (2*lmax+1)**2*8
c     ylmh,ylmt are in comlex arrays of length (lmax+1)**2(*8)
c
      data radian/57.2957795/
c
      call pole(xlat1,xlon1,xlat2,xlon2,xlatp,xlonp,azmp,delta)
c
      del=delta/radian
      cth=(90.-xlatp)/radian
      dcth=cth
      cph=xlonp/radian
      phmp=(180.-azmp)/radian
c
      lm1=lmax+1
      sar(1)=1.
      do 11 imp=2,lm1
      arg=float(imp-1)*del*.5
   11 sar(imp)=sin(arg)/arg
c
      ind=0
      do 10 il1=1,lm1
      l=il1-1
      itlp1=2*l+1
c
      call legndr(90./radian,l,l,wk1,wk2,wk3)
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
c
      do 25 ic=1,itlp1
      mp=ic-il1
      fmp=float(mp)
      imp=iabs(mp)+1
      ssgn=1.
      if(mp.lt.0.and.(mp/2)*2.ne.mp) ssgn=-1.
      arg=fmp*phmp
      ccon=cmplx(0.,arg)
      ccon=cexp(ccon)
      temp=temp+ssgn*wk1(imp)*sar(imp)*d(ibia+ic)*ccon
   25 continue
c
      temp=temp*fac
      temp1=wk1(1)*d(il1+ibia)*fac
c     write(6,59)temp1,wk1(1),d(il1+ibia),fac
c  59 format(' temp1,wk1(1),d,fac are ',4(f10.3,1x))
      ind=ind+1
      ylmt(ind)=real(temp)
      ylmh(ind)=real(temp1)
      if(im.eq.1) goto 20
      ind=ind+1
      ylmt(ind)=aimag(temp)
      ylmh(ind)=aimag(temp1)
   20 fac=fac*dfac
c
   10 continue
      do 13 kk=1,4
c     write(6,12)ylmt(kk),ylmh(kk)
   13 continue
c  12 format(' in ylmav, ylmt and ylmh are ',2(f10.3,1x))
      return
      end
