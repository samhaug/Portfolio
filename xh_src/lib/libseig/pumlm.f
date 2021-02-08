c----------------------------------------------------------------------
      subroutine pumlm
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
      character*1 ialp
      common/mdpert/parm(20)
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
      data n670/180/,n220/202/,nmidc/216/,n1100/165/
      data twth/0.66666 66666 66667/
      data thrd,fot/.33333 33333 33333,1.33333 33333 33333/
      data capom/7.292115e-05/
      data nint/10/
c     data ratrvs,ratvps/.4,.8/
      data ratrvs,ratvps/0.,0./
c
c  correction -- original version integrated only from 1100 km depth.
      nbot=noc+1
      ntop=moho
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
      j1=1
      j2=3
      if(jcom.eq.2) j1=2
      if(jcom.eq.2) j2=2
c
      do 141 i=1,nint
  141 acum(i)=0.
c
      do 100 iq=nbot,ntop
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
      x=2.*(rr-r(n670))/(r(moho)-r(n670))-1.
      do 130 i=j1,j2
      i1=2*i-1
      i2=i1+1
      q(i)=eif(iq,i1)+t*(eif(iq,i2)+t*(b(i)+t*a(i)))
  130 qp(i)=(eif(iq,i2)+t*(2.*b(i)+t*3.*a(i)))*rr
c
      aa=xac*(acon(iq)+t*(qacon(1,iq)+t*(qacon(2,iq)+t*qacon(3,iq))))
      cc=xac*(ccon(iq)+t*(qccon(1,iq)+t*(qccon(2,iq)+t*qccon(3,iq))))
      ff=xf*(fcon(iq)+t*(qfcon(1,iq)+t*(qfcon(2,iq)+t*qfcon(3,iq))))
      ll=xln*(lcon(iq)+t*(qlcon(1,iq)+t*(qlcon(2,iq)+t*qlcon(3,iq))))
      nn=xln*(ncon(iq)+t*(qncon(1,iq)+t*(qncon(2,iq)+t*qncon(3,iq))))
      rrho=rho(iq)+t*(qrho(1,iq)+t*(qrho(2,iq)+t*qrho(3,iq)))
      gr=g(iq)+t*(gd+t*(bg+t*ag))
      ratv2=ratvps*(aa+cc)/(ll+nn)
      rrv2=ratrvs/(ll+nn)
      etan=ff/(aa-2.*ll)
c
      if(jcom.eq.2) goto 134
      f=2.*ur-fl3*vr
      xx=vpr-vr+ur
      xx2=xx*xx
      vr2=vr*vr
      ur2=ur*ur
      rka0=f*f
      rkc0=upr*upr
      rkf0=2.*upr*f
      rkl0=fl3*xx2
      rkn0=-rka0+con3*vr2
      t1=(-omn2*vr2*rr+vr*(2.*pr+gr*ur))*rr
      rkr0=((8.*rrho-omn2)*ur2*rr-gr*ur*(f+2.*ur)+2.*ur*ppr)*rr
     1   +fl3*t1
      goto 135
c
  134 xx=vpr-vr
      xx2=xx*xx
      vr2=vr*vr
      rkl0=fl3*xx2
      rkn0=con3*vr2
      t1=-omn2*vr2*rr2
      rkr0=fl3*t1
  135 continue
c
c  polynomial perturbation to squared shear velocity: moho-670 km
c
      if(iq.le.n670.or.iq.ge.moho) goto 224
      x=2.*(rr-r(n670))/(r(moho)-r(n670))-1.
      do 235 i=1,4
      iin=i-1
      pnx=pn(iin,x)
      if(jcom.eq.2) add=wt(il)*rrho*delv2
     1   *pnx*(rkn0+rkl0+rrv2*(nn*rkn0+ll*rkl0+rrho*rkr0))*hnh
      if(jcom.ne.2) add=wt(il)*rrho*delv2
     1   *pnx*(rkn0+rkl0-2.*etan*rkf0
     2   +ratv2*(rka0+rkc0+etan*rkf0)
     3   +rrv2*(rka0*aa+rkc0*cc+rkn0*nn+rkl0*ll+rkf0*ff+rkr0*rrho))*hnh
  235 temp(i)=temp(i)+add
  224 continue
c
c
c  polynomial perturbation to squared shear velocity: 670 - cmb
c
      if(iq.le.noc.or.iq.ge.n670) goto 424

      x=2.*(rr-r(noc))/(r(n670)-r(noc))-1.
      do 435 i=1,5
      iin=i-1
      pnx=pn(iin,x)
      if(jcom.eq.2) add=wt(il)*rrho*delv2
     1   *pnx*(rkn0+rkl0+rrv2*(nn*rkn0+ll*rkl0+rrho*rkr0))*hnh
      if(jcom.ne.2) add=wt(il)*rrho*delv2
     1   *pnx*(rkn0+rkl0-2.*etan*rkf0
     2   +ratv2*(rka0+rkc0+etan*rkf0)
     3   +rrv2*(rka0*aa+rkc0*cc+rkn0*nn+rkl0*ll+rkf0*ff+rkr0*rrho))*hnh
  435 temp(i+4)=temp(i+4)+add
  424 continue
c
  110 continue
c
      goto 400
c
   99 continue
      rr=r(iq)
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
c  67o km discontinuity
c
      if(iq.ne.n670) goto 304
      delh=deldis
      if(jcom.ne.2) add=-float(idis-2)*delh*
     1  (aa*rka0+cc*rkc0+ff*rkf0+
     2   ll*rkl0+nn*rkn0+rrho*rkr0)
      if(jcom.eq.2) add=-float(idis-2)*delh*
     1  (ll*rkl0+nn*rkn0+rrho*rkr0)
      temp(10)=temp(10)+add
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
      do 264 i=1,nint
  264 parm(i)=acum(i)*.5*wcom
c
      ialp='s'
      if(jcom.eq.2) ialp='t'
      write(6,343) nord,ialp,lord
  343 format(1x,i2,1x,a1,i4)
      return
      end
