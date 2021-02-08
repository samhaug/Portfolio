      subroutine ekern(is,wn)
      include 'modl.h'
      double precision acum
      common/work/wk(3,nknts),coef(5),y(3),y1(3),y2(3),y3(3),ydot(3)
      dimension yy(nknts,2),yyd(nknts,2),cy(nknts,2),qe(3,nknts)
      common/kerns/eps(nknts,20)
      dimension idat(4,20),fdat(20)
      dimension xi(5),wt(5)
      data fot/1.3333333333333/
      data bigg,capom/6.6723e-11,7.292115e-05/
      data pi,tau,rhon/3.1415926,1000.0,5514.3/

      data xi/-0.90617 98459 38664,-0.53846 93101 05683
     1       , 0.00000 00000 00000, 0.53846 93101 05683
     2       , 0.90617 98459 38664/
      data wt/ .23692 68850 56189, 0.47862 86704 99366
     1       , .56888 88888 88889, 0.47862 86704 99366
     2       , .23692 68850 56189/

      data nker,idat,fdat/9
     1  ,110,219, 0, 0
     1  ,110,219, 1, 0
     1  ,110,219, 3, 0
     1  ,110,219, 4, 0
     1  ,110,219, 5, 0
     1  , 55, 56,-1, 0
     1  ,109,110,-1, 0
     1  ,180,181,-1, 0
     1  ,219,220,-1, 0
     1  ,44*0
     1  ,20*1./
c
c
      fis=.5*float(is*(is+1))
      do 1200 idir=1,2

      if(idir.eq.1) then
        y(1)=1.
        y(2)=0.
        yy(1,1)=y(1)
        yyd(1,1)=y(2)
        rr=1.e-4
        inc=1
      else
        y(1)=1.
        y(2)=-float(is)/r(n)
        yy(n,2)=y(1)
        yyd(n,2)=y(2)
        rr=r(n)
        inc=-1
      endif

      do 100 iknt=2,n
      if(idir.eq.1) then
        i=iknt
      else
        i=n+1-iknt
        if(i.eq.1) goto 100
      endif
      im1=i-inc

      rstep=r(i)-r(im1)
      if(abs(rstep).gt.1.e-4) goto 110
      yy(i,idir)=yy(im1,idir)
      yyd(i,idir)=yyd(im1,idir)
      goto 200
c
  110 do 101 ii=1,2
  101 y1(ii)=y(ii)
      rr1=rr
      if(inc*(rr+rstep-r(i)).gt.0.) rstep=r(i)-rr
      iback=1
      goto 1100
c
 1201 do 201 ii=1,2
  201 y2(ii)=y(ii)
      rr2=rr
  901 rstep=rstep*.5
      do 321 ii=1,2
  321 y(ii)=y1(ii)
      rr=rr1
      iback=2
      goto 1100
c
 1202 do 401 ii=1,2
  401 y3(ii)=y(ii)
      rr3=rr
      iback=3
      goto 1100
c
 1203 do 501 ii=1,2
      if(abs(y(ii)-y2(ii)).gt.(.5e-4*abs(y(ii))+.5e-4)) goto 601
  501 continue
      goto 701
c
  601 do 801 ii=1,2
  801 y2(ii)=y3(ii)
      rr2=rr3
      goto 901
  701 if(abs(rr-r(i)).lt.1.e-5) goto 1300
      rstep=4.*rstep
      goto 110
c
 1300 yy(i,idir)=y(1)
      yyd(i,idir)=y(2)
      goto 200
c
 1100 k=krunge(2,y,ydot,rr,rstep)
      if(k.ne.1) goto (1201,1202,1203),iback
c
      ydot(1)=y(2)
      t=rr-r(im1)
      rhot=rho(im1)+t*(qrho(1,im1)+t*(qrho(2,im1)+t*qrho(3,im1)))

      if(im1.ne.1) then
      gdot1=4.*rho(im1)-2.*g(im1)/r(im1)
      else
      gdot1=fot*rho(im1)
      endif

      if(i.ne.1) then
      gdot2=4.*rho(i)-2.*g(i)/r(i)
      else
      gdot2=fot*rho(i)
      endif

      hn=r(i)-r(im1)
      hh=t/hn
      gg=t*(gdot1*(1.+hh*(-2.+hh))+gdot2*hh*(hh-1.))
     1    +g(im1)*(1.+hh*hh*(-3+hh*2.))+g(i)*hh*hh*(3.-2.*hh)

      rhr=gg/(fot*rr)
      temp=(3.*rhot-fis*rhr)/rr
      ydot(2)=-2.*(temp*y(1)+3.*rhot*y(2))/(rhr*rr)
      goto 1100
c
  200 write(6,'(''idir:'',i2,''   i:'',i5,''    yy:'',1pe14.5)')
     1  idir,i,yy(i,idir)

  100 continue
c
 1200 continue

      wa=yyd(n,1)+float(is)*yy(n,1)/r(n)
      write(6,'(''wn,g(n),wa'',1p3e12.4)') wn,g(n),wa
      fac=2.5*(capom/wn)**2/(g(n)*wa)
      do 1800 i=2,n
      w1=wa*g(n)**2*r(n)**4/(g(i)**2*r(i)**4)
      w2=yyd(i,1)*yy(i,2)-yyd(i,2)*yy(i,1)
      ellp=fac*yy(i,1)
      write(6,'(''level:'',i4,''   ell:'',1p2e12.4,''    w:'',2e12.4)')
     1  i,ellp,ell(i),w1,w2
 1800 continue
      do 2000 iker=1,nker
      rbot=r(idat(1,iker))
      rtop=r(idat(2,iker))
      rdif=rtop-rbot
      nord=idat(3,iker)
      factor=fdat(iker)/(wa*g(n)**2*r(n)**4)
      ipow=idat(4,iker)
      do 2100 idir=1,2

      acum=0.
      cy(1,1)=0.
      cy(n,2)=0.
      do 2200 iknt=2,n

      if(idir.eq.1) then
        inc=1
        iq=iknt-1
        iq1=iq+inc
        if(iq1.le.idat(1,iker).or.iq.ge.idat(2,iker)) goto 2400
      else
        inc=-1
        iq=n-iknt+2
        iq1=iq+inc
        if(iq1.ge.idat(2,iker).or.iq.le.idat(1,iker)) goto 2400
      endif

      rr=r(iq)
      rr1=r(iq1)
      hn=rr1-rr
      hnh=.5*hn
      yq=yy(iq,idir)
      yqd=yyd(iq,idir)
      yq1=yy(iq1,idir)
      yqd1=yyd(iq1,idir)
      gg=g(iq)
      if(iq.ne.1) then
        ggd=4.*rho(iq)-2.*gg/rr
      else
        ggd=fot*rho(iq)
      endif
      gg1=g(iq1)
      if(iq1.ne.1) then
        ggd1=4.*rho(iq1)-2.*gg1/rr1
      else
        ggd1=fot*rho(iq1)
      endif

      if(abs(hn).lt.1.e-4) goto 2500
c     calculate integral for a layer
      do 2010 il=1,5
      t=hnh*(xi(il)+1.)
      rx=rr+t
      rhod=qrho(1,iq)+t*(2.*qrho(2,iq)+t*3.*qrho(3,iq))
      x=-1.+2.*(rx-rbot)/rdif
c     write(6,"('iq,iq1,rr,t,rx',2i5,1p3e12.4)") iq,iq1,rr,t,rx
      if(x.lt.-1..or.x.gt.1.) pause 'error 2 in ekern'
      fnx=factor*pn(nord,x)
      if(ipow.ne.0) fnx=fnx*rx**ipow

      hh=t/hn
      gx=t*(ggd*(1.+hh*(-2.+hh))+ggd1*hh*(hh-1.))
     1    +gg*(1.+hh*hh*(-3+hh*2.))+gg1*hh*hh*(3.-2.*hh)
      if(rx.gt.r(1)) then
        yx=t*(yqd*(1.+hh*(-2.+hh))+yqd1*hh*(hh-1.))
     1    +yq*(1.+hh*hh*(-3+hh*2.))+yq1*hh*hh*(3.-2.*hh)
      else
        if(idir.eq.1) yx=yy(1,1)*(rx/r(1))**(is-2)
        if(idir.eq.2) yx=yy(1,2)*(rx/r(1))**(-is-3)
      endif
      acum=acum+hnh*wt(il)*4.*gx*rhod*fnx*yx*rx**4
 2010 continue
      goto 2400


c     deal with discontinuity
 2500 fnx=factor
      if(nord.ge.0) then
      x=-1.+2.*(r(iq)-rbot)/rdif
      fnx=factor*pn(nord,x)
      if(ipow.ne.0) fnx=fnx*r(iq)**ipow
      endif

      acum=acum+4.*g(iq)*(rho(iq1)-rho(iq))*fnx*yy(iq,idir)*r(iq)**4
      write(6,'(''discontinuity at'',2i5)') iq,iq1
 2400 cy(iq1,idir)=acum

 2200 continue
 2100 continue
c
c     now compute eps from cy1,cy2
      write(6,'(''kernel'',i4,''   idat:'',4i4
     1/''type return to continue'')') iker,(idat(j,iker),j=1,4)
      read(5,'(a1)') idum

      do 2300 i=1,n
      eps(i,iker)=cy(i,2)*yy(i,1)-cy(i,1)*yy(i,2)
c     write(6,"(i3,' y:',1p2e12.4,' cy:',2e12.4,' eps:',e12.4)")
c    1 i,(yy(i,j),j=1,2),(cy(i,j),j=1,2),eps(i,iker)
 2300 continue

      call rspln(1,n,r,eps(1,iker),qe,wk)
      do 2900 iq=2,n
      t1=2.*qe(2,iq)
      t2=qe(1,iq)*8.*rho(iq)/g(iq)
      t3=eps(iq,iker)*(8.*rho(iq)/(g(iq)*r(iq))-float(is*(is+1))/r(iq)**2)
      rhs=0.
      if((iq.ge.idat(1,iker).and.iq.le.idat(2,iker))
     1  .and.idat(3,iker).ge.0)
     1  rhs=4.*qrho(1,iq)*fdat(iker)*r(iq)**idat(4,iker)
     1  *pn(idat(3,iker),-1.+2.*(r(iq)-r(idat(1,iker)))
     1  /(r(idat(2,iker))-r(idat(1,iker))) )/g(iq)
      write(6,'(i3,1p6f10.4)') iq,eps(iq,iker),t1,t2,t3,t1+t2+t3,rhs
 2900 continue


 2000 continue
      end
