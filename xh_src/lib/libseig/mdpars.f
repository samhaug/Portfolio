c----------------------------------------------------------------------
      subroutine mdpars
      save
      real lcon,ncon,llp,nnp,ll,nn
      common/modl1/n,nic,noc,moho,nsl,ifanis,r(222)
     1            ,rho(222),qrho(3,222),g(222),ell(222),eta(222)
      common/modl2/acon(222),qacon(3,222),ccon(222),qccon(3,222)
     1            ,lcon(222),qlcon(3,222),ncon(222),qncon(3,222)
     2            ,fcon(222),qfcon(3,222)
      common/modl3/qshear(222),qkappa(222)
      common/nond/rn,wn,vn,gn,rhobar
c
      common/mode/nord,jcom,lord,wcom,qbar,cgp,avert,ahor,phis
     1          ,eif(222,6)
      dimension u(222),up(222),v(222),vp(222),p(222),pp(222)
      equivalence (eif(1,1),u(1)),(eif(1,2),up(1)),(eif(1,3),v(1))
     1           ,(eif(1,4),vp(1)),(eif(1,5),p(1)),(eif(1,6),pp(1))
c
      common/mdprs/parm(20)
      dimension iparm(20)
      equivalence (parm(1),iparm(1))
c
      dimension q(3),qp(3)
      equivalence (q(1),ur),(q(2),vr),(q(3),pr)
     1          ,(qp(1),upr),(qp(2),vpr),(qp(3),ppr)
c
      double precision temp(20),acum(20),add
      dimension xi(5),wt(5),a(3),b(3)
      data xi/-0.90617 98459 38664,-0.53846 93101 05683
     1       , 0.00000 00000 00000, 0.53846 93101 05683
     2       , 0.90617 98459 38664/
      data wt/ .23692 68850 56189, 0.47862 86704 99366
     1       , .56888 88888 88889, 0.47862 86704 99366
     2       , .23692 68850 56189/
c
      data n670/180/,n220/202/,nmidc/216/
      data twth/0.66666 66666 66667/
      data thrd,fot/.33333 33333 33333,1.33333 33333 33333/
      data capom/7.292115e-05/
      data nint/13/
      data drn,drnsl,drmidc,drmoho
     1   ,droc,druc,drlc
     2   ,dvpoc,dvpuc,dvplc
     3   ,dvsoc,dvsuc,dvslc/
     4     3.5028e-02, 2.1017e-01,-3.7886e-01,-7.8982e-01
     5   ,-3.5028e-04, 0.        , 0.
     6   , 0.        ,-2.1017e-02, 3.5028e-03
     7   , 0.        ,-5.2542e-03, 1.7514e-03/
c
      if(jcom.eq.0) return
      capon2=(capom/wn)**2
      delv=1000./vn
      delv2=delv*delv
      deldis=1000./rn
      fl=float(lord)
      fl3=fl*(fl+1.)
      sfl3=sqrt(fl3)
      con1=fl3-3.
      con2=fl3*(fl3-2.)+3.*(4.*fl3-8.)
      con3=fl3*(fl3-2.)
      con4=3.*(4.*fl3-8.)
      omnd=wcom/wn
      omn2=omnd**2
      gmcc=1000./rhobar
      j1=1
      j2=3
      if(jcom.eq.2) j1=2
      if(jcom.eq.2) j2=2
c
      do 141 i=1,nint
  141 acum(i)=0.
c
      nstart=1
      if(jcom.eq.2) nstart=noc
      do 100 iq=nstart,n
      do 142 i=1,nint
  142 temp(i)=0.
      if(iq.eq.n) goto 99
c
      iiq=iq
      call corfac(iiq,wcom,jcom,xac,xf,xln)
c
      iq1=iq+1
      r1=r(iq)
      r2=r(iq1)
      hn=r2-r1
      hnh=hn*.5
      if(hn.lt.1.e-4) goto 99
      hr=1./hn
      hsq=hr*hr
      hcu=hr*hsq
c
      do 120 i=j1,j2
      i1=2*i-1
      i2=i1+1
      a(i)=(eif(iq,i2)+eif(iq1,i2))*hsq
     1     +2.*(eif(iq,i1)-eif(iq1,i1))*hcu
  120 b(i)=-(2.*eif(iq,i2)+eif(iq1,i2))*hr
     1     -3.*(eif(iq,i1)-eif(iq1,i1))*hsq
c
      elld=0
      if(iq.ne.1) elld=ell(iq)*eta(iq)/r(iq)
      elld1=ell(iq1)*eta(iq1)/r(iq1)
      ae=(elld+elld1)*hsq+2.*(ell(iq)-ell(iq1))*hcu
      be=-(2.*elld+elld1)*hr-3.*(ell(iq)-ell(iq1))*hsq
c
      gd=fot*rho(iq)
      if(iq.ne.1) gd=4.*rho(iq)-2.*g(iq)/r(iq)
      gd1=4.*rho(iq1)-2.*g(iq1)/r(iq1)
      ag=(gd+gd1)*hsq+2.*(g(iq)-g(iq1))*hcu
      bg=-(2.*gd+gd1)*hr-3.*(g(iq)-g(iq1))*hsq
c
      do 110 il=1,5
      t=.5*hn*(xi(il)+1.)
      rr=r1+t
      rr2=rr*rr
      do 130 i=j1,j2
      i1=2*i-1
      i2=i1+1
      q(i)=eif(iq,i1)+t*(eif(iq,i2)+t*(b(i)+t*a(i)))
  130 qp(i)=(eif(iq,i2)+t*(2.*b(i)+t*3.*a(i)))*rr
      el=ell(iq)+t*(elld+t*(be+t*ae))
      et=(elld+t*(2.*be+t*3.*ae))*rr/el
c
      if(jcom.eq.2) goto 132
      gr=g(iq)+t*(gd+t*(bg+t*ag))
      aa=xac*(acon(iq)+t*(qacon(1,iq)+t*(qacon(2,iq)+t*qacon(3,iq))))
      cc=xac*(ccon(iq)+t*(qccon(1,iq)+t*(qccon(2,iq)+t*qccon(3,iq))))
      ff=xf*(fcon(iq)+t*(qfcon(1,iq)+t*(qfcon(2,iq)+t*qfcon(3,iq))))
      aap=xac*(qacon(1,iq)+t*(2.*qacon(2,iq)+t*3.*qacon(3,iq)))
      ccp=xac*(qccon(1,iq)+t*(2.*qccon(2,iq)+t*3.*qccon(3,iq)))
      ffp=xf*(qfcon(1,iq)+t*(2.*qfcon(2,iq)+t*3.*qfcon(3,iq)))
  132 ll=xln*(lcon(iq)+t*(qlcon(1,iq)+t*(qlcon(2,iq)+t*qlcon(3,iq))))
      nn=xln*(ncon(iq)+t*(qncon(1,iq)+t*(qncon(2,iq)+t*qncon(3,iq))))
      rrho=rho(iq)+t*(qrho(1,iq)+t*(qrho(2,iq)+t*qrho(3,iq)))
      llp=xln*(qlcon(1,iq)+t*(2.*qlcon(2,iq)+t*3.*qlcon(3,iq)))
      nnp=xln*(qncon(1,iq)+t*(2.*qncon(2,iq)+t*3.*qncon(3,iq)))
      rhop=qrho(1,iq)+t*(2.*qrho(2,iq)+t*3.*qrho(3,iq))
      if(jcom.eq.2) goto 134
      f=2.*ur-fl3*vr
      xx=vpr-vr+ur
      xx2=xx*xx
      vr2=vr*vr
      ur2=ur*ur
      t1=(-omn2*vr2*rr+vr*(2.*pr+gr*ur))*rr
      rka0=f*f
      rkc0=upr*upr
      rkf0=2.*upr*f
      rkl0=fl3*xx2
      rkl2=rkl0-3.*xx2
      rkn0=-rka0+con3*vr2
      rkn2=rkn0-con4*vr2
      rkr0=((8.*rrho-omn2)*ur2*rr-gr*ur*(f+2.*ur)+2.*ur*ppr)*rr
     1   +fl3*t1
      rkr2=rkr0-3.*t1
      g1=rrho*(6.*ur2+3.*(ur*vpr-vr*(upr+2.*f-ur)))
      g2=rrho*rr*(-2.*ur*f+3.*ur*vr)
      php1=gr
      php2=4.*rrho+(et-1)*gr/rr
      goto 135
c
  134 xx=vpr-vr
      xx2=xx*xx
      vr2=vr*vr
      t1=-omn2*vr2*rr2
      rkl0=fl3*xx2
      rkl2=rkl0-3.*xx2
      rkn0=con3*vr2
      rkn2=rkn0-con4*vr2
      rkr0=fl3*t1
      rkr2=rkr0-3.*t1
c
c   normalization integral
c
  135 t1=vr2*fl3
      if(jcom.ne.2) t1=t1+ur2
      add=wt(il)*rr2*t1*rrho*hnh
      temp(13)=temp(13)+add
c
c  ellipticity
c
      if(jcom.ne.2) add=wt(il)*rr*twth*el*
     1   (aap*rka0+ccp*rkc0+ffp*rkf0+llp*rkl2+nnp*rkn2+rhop*rkr2
     2   +php1*g1+php2*g2)*hnh
      if(jcom.eq.2) add=wt(il)*rr*twth*el*
     1   (llp*rkl2+nnp*rkn2+rhop*rkr2)*hnh
      temp(6)=temp(6)+add
c
c  p velocity in the lithosphere
c
      if(iq.gt.moho.or.iq.lt.n220) goto 204
      if(jcom.eq.2) goto 204
      add=wt(il)*rrho*delv2*(rka0+rkc0+rkf0)*hnh
      temp(8)=temp(8)+add
  204 continue
c
c    crustal correction
c
      if(iq.lt.moho) goto 401
      vs=sqrt(ll/rrho)
      vvp=sqrt(aa/rrho)
      if(iq.gt.nmidc) goto 402
      ddrho=drlc
      ddvs2=2.*vs*dvslc*delv
      ddvp2=2.*vvp*dvplc*delv
      goto 404
  402 if(iq.gt.nsl) goto 403
      ddrho=druc
      ddvs2=2.*vs*dvsuc*delv
      ddvp2=2.*vvp*dvpuc*delv
      goto 404
  403 ddrho=droc
      ddvs2=2.*vs*dvsoc*delv
      ddvp2=2.*vvp*dvpoc*delv
  404 etan=ff/(aa-2.*ll)
      if(jcom.ne.2) add=wt(il)*hnh*(
     1  rrho*(ddvp2*(rka0+rkc0+etan*rkf0)
     2       +ddvs2*(rkn0+rkl0-2.*etan*rkf0))
     3 +(aa*rka0+cc*rkc0+nn*rkn0+ll*rkl0+ff*rkf0+rrho*rkr0)*ddrho/rrho)
      if(jcom.eq.2) add=wt(il)*hnh*(
     1  rrho*(ddvs2*(rkn0+rkl0))
     2 +(nn*rkn0+ll*rkl0+rrho*rkr0)*ddrho/rrho)
      temp(7)=temp(7)+add
  401 continue
c
c   rotational splitting
c
c
      add=0.
      if(jcom.ne.2) add=wt(il)*rr2*(vr2+2.*ur*vr)*rrho*hnh
      temp(12)=temp(12)+add
c
  110 continue
c
      goto 400
c
   99 rr=r(iq)
      rr2=rr*rr
      do 119 idis=1,3,2
      iqt=iq+(idis-1)/2
      if(iqt.gt.n) goto 119
c
      call corfac(iqt,wcom,jcom,xac,xf,xln)
c
      do 129 i=j1,j2
      i1=2*i-1
      i2=i1+1
      q(i)=eif(iqt,i1)
  129 qp(i)=eif(iqt,i2)*rr
      el=ell(iqt)
c
      if(jcom.eq.2) goto 192
      gr=g(iqt)
      aa=xac*acon(iqt)
      cc=xac*ccon(iqt)
      ff=xf*fcon(iqt)
  192 ll=xln*lcon(iqt)
      nn=xln*ncon(iqt)
      rrho=rho(iqt)
c
      if(jcom.eq.2) goto 194
      f=2.*ur-fl3*vr
      xx=vpr-vr+ur
      xx2=xx*xx
      vr2=vr*vr
      ur2=ur*ur
      t1=(-omn2*vr2*rr+vr*(2.*pr+gr*ur))*rr
      rka0=f*f
      rkc0=-upr*upr
      rkc2=rkc0+6.*vr*upr
      rkf0=0.
      rkf2=rkf0+6.*vr*f
      rkl0=fl3*xx2-2.*fl3*vpr*xx
      rkl2=rkl0-3.*xx2+6.*vpr*xx
      rkn0=-rka0+con3*vr2
      rkn2=rkn0-con4*vr2
      rkr0=((8.*rrho-omn2)*ur2*rr-gr*ur*(f+2.*ur)+2.*ur*ppr)*rr
     1   +fl3*t1
      rkr2=rkr0-3.*t1
      goto 195
c
  194 xx=vpr-vr
      xx2=xx*xx
      vr2=vr*vr
      t1=-omn2*vr2*rr2
      rkl0=fl3*xx2-2.*fl3*vpr*xx
      rkl2=rkl0-3.*xx2+6.*vpr*xx
      rkn0=con3*vr2
      rkn2=rkn0-con4*vr2
      rkr0=fl3*t1
      rkr2=rkr0-3.*t1
  195 continue
c
c  ellipticity
c
      if(jcom.ne.2) add=float(idis-2)*rr*twth*el*
     1 (aa*rka0+cc*rkc2+ff*rkf2
     2   +ll*rkl2+nn*rkn2+rrho*rkr2)
      if(jcom.eq.2) add=float(idis-2)*rr*twth*el*
     1 (ll*rkl2+nn*rkn2+rrho*rkr2)
      temp(6)=temp(6)+add
c
c  crustal thickness
c
      if(iq.ne.nmidc.and.iq.ne.moho.and.iq.ne.nsl.and.iq.ne.n) goto 301
      if(iq.eq.n) delh=drn*deldis
      if(iq.eq.nsl) delh=drnsl*deldis
      if(iq.eq.nmidc) delh=drmidc*deldis
      if(iq.eq.moho) delh=drmoho*deldis
      if(jcom.ne.2) add=-float(idis-2)*delh*
     1  (aa*rka0+cc*rkc0+ff*rkf0+
     2   ll*rkl0+nn*rkn0+rrho*rkr0)
      if(jcom.eq.2) add=-float(idis-2)*delh*
     1  (ll*rkl0+nn*rkn0+rrho*rkr0)
      temp(7)=temp(7)+add
  301 continue
c
c  radius of solid surface
c
      if(iq.ne.moho.and.iq.ne.nmidc.and.iq.ne.nsl.and.iq.ne.n) goto 302
      delh=deldis
      if(jcom.ne.2) add=-float(idis-2)*delh*
     1  (aa*rka0+cc*rkc0+ff*rkf0+
     2   ll*rkl0+nn*rkn0+rrho*rkr0)
      if(jcom.eq.2) add=-float(idis-2)*delh*
     1  (ll*rkl0+nn*rkn0+rrho*rkr0)
      temp(9)=temp(9)+add
  302 continue
c
c  ocean depth
c
      if(iq.ne.n) goto 303
      delh=deldis
      if(jcom.ne.2) add=-float(idis-2)*delh*
     1  (aa*rka0+cc*rkc0+ff*rkf0+
     2   ll*rkl0+nn*rkn0+rrho*rkr0)
      if(jcom.eq.2) add=-float(idis-2)*delh*
     1  (ll*rkl0+nn*rkn0+rrho*rkr0)
      temp(10)=temp(10)+add
  303 continue
c
c  67o km discontinuity
c
      if(iq.ne.n670) goto 304
      delh=deldis
      if(jcom.ne.2) add=-float(idis-2)*delh*
     1  (aa*rka0+cc*rkc0+ff*rkf0+
     2   ll*rkl0+nn*rkn0+rrho*rkr0)
      if(jcom.eq.2) add=-float(idis-2)*delh*
     1  (ll*rkl0+nn*rkn0+rrho*rkr0)
      temp(11)=temp(11)+add
  304 continue
c
  119 continue
c
  400 do 146 ii=1,nint
  146 acum(ii)=acum(ii)+temp(ii)
c
c
  100 continue
c
c
      parm(1)=wcom
      parm(2)=qbar
      parm(3)=avert
      parm(4)=ahor
      parm(5)=cgp
      parm(6)=acum(6)*.5*fl3/((2.*fl+3.)*(2.*fl-1.))
      parm(7)=acum(7)*.5*wcom
      parm(8)=acum(8)*.5*wcom
      parm(9)=acum(9)*.5*wcom
      parm(10)=acum(10)*.5*wcom
      parm(11)=acum(11)*.5*wcom
      parm(12)=acum(12)*omn2*capom/wcom
      if(jcom.eq.2) parm(12)=capom/(fl3*wcom)
c     x2=parm(6)*wcom*rn/((fl+.5)*cgp*1000.)
c     per=2.*3.1415926535/wcom
c
      anorm=acum(13)*omn2
c
      if(jcom.eq.2) write(6,1) nord,lord,wcom,anorm,parm(12)
     1   ,parm(6)
    1 format(1x,i2,' t',i3,' wcom:',e12.5,' anorm:',e12.5,
     1  5h 'b':,e10.4,' alpha:',e10.4)
      if(jcom.ne.2) write(6,2) nord,lord,wcom,anorm,parm(12)
     1   ,parm(6)
    2 format(1x,i2,' s',i3,' wcom:',e12.5,' anorm:',e12.5,
     1  5h 'b':,e10.4,' alpha:',e10.4)
      avtest=-u(nsl)*wcom**2
      ahtest=-v(nsl)*wcom**2
      write(6,111) avtest,parm(3),ahtest,parm(4)
  111 format(' av',2e12.5,'  ah',2e12.5)
      return
      end
