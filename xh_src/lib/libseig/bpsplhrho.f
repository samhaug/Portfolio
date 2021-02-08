c----------------------------------------------------------------------
      subroutine bpsplhrho
      save
      parameter (MAXKER=28)
      parameter (MNDIM=222)
      real lcon,ncon,llp,nnp,ll,nn
      common/modl1/n,nic,noc,moho,nsl,ifanis,r(MNDIM)
     1            ,rho(MNDIM),qrho(3,MNDIM),g(MNDIM),ell(MNDIM),eta(MNDIM)
      common/modl2/acon(MNDIM),qacon(3,MNDIM),ccon(MNDIM),qccon(3,MNDIM)
     1            ,lcon(MNDIM),qlcon(3,MNDIM),ncon(MNDIM),qncon(3,MNDIM)
     2            ,fcon(MNDIM),qfcon(3,MNDIM)
      common/modl3/qshear(MNDIM),qkappa(MNDIM)
      common/nond/rn,wn,vn,gn,rhobar
c
      common/mode/nord,jcom,lord,wcom,qbar,cgp,avert,ahor,phis
     1          ,eif(MNDIM,6)
      dimension u(MNDIM),up(MNDIM),v(MNDIM),vp(MNDIM),p(MNDIM),pp(MNDIM)
      equivalence (eif(1,1),u(1)),(eif(1,2),up(1)),(eif(1,3),v(1))
     1           ,(eif(1,4),vp(1)),(eif(1,5),p(1)),(eif(1,6),pp(1))
c

      dimension rg2(MNDIM),radj(MNDIM),rgwk(3,MNDIM),qrg2(3,MNDIM)
     1     ,qradj(3,MNDIM)
      character*1 ialp
      common/mdpert/parm(MAXKER)
      dimension iparm(MAXKER)
      equivalence (parm(1),iparm(1))
c
      dimension q(3),qp(3)
      equivalence (q(1),ur),(q(2),vr),(q(3),pr)
     1          ,(qp(1),upr),(qp(2),vpr),(qp(3),ppr)
c
      double precision temp(MAXKER),acum(MAXKER),add
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
c

      data drn,drnsl,drmidc,drmoho
     1   ,droc,druc,drlc
     2   ,dvpoc,dvpuc,dvplc
     3   ,dvsoc,dvsuc,dvslc/
     4     3.5028e-02, 2.1017e-01,-3.7886e-01,-7.8982e-01
     5   ,-3.5028e-04, 0.        , 0.
     6   , 0.        ,-2.1017e-02, 3.5028e-03
     7   , 0.        ,-5.2542e-03, 1.7514e-03/



      nbot=noc+1
c     ntop=moho
      ntop=n

      if(jcom.eq.0) return
      delvn=1000./vn
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
      if(jcom.ne.2) then
        do iq=1,n
          f=2.*u(iq)-fl3*v(iq)
          if(iq.eq.1) then
            fp=2.*up(iq)-fl3*vp(iq)
            rg2(iq)=-2.*rho(iq)*(up(iq)*f+u(iq)*fp)
          else
            rg2(iq)=-2.*rho(iq)*u(iq)*f/r(iq)
          endif
        enddo
        call rspln(1,n,r(1),rg2(1),qrg2(1,1),rgwk(1,1))
        radj(n)=0.
        do iq=n-1,1,-1
          t=r(iq+1)-r(iq)
          radj(iq)=radj(iq+1)+4.*(
     1 t*(rg2(iq)+t*(qrg2(1,iq)/2.+t*(qrg2(2,iq)/3.+t*(qrg2(3,iq)/4.))))  )
        enddo

      else
        do iq=1,n
          radj(iq)=0.0
        enddo
      endif
      call rspln(1,n,r(1),radj(1),qradj(1,1),rgwk(1,1))
c
      do i=1,MAXKER
        acum(i)=0.
      enddo
c
      do 100 iq=nbot,ntop
      do i=1,MAXKER
        temp(i)=0.
      enddo
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

      do i=1,3
        q(i)=0.
        qp(i)=0.
      enddo
c
      do i=j1,j2
        i1=2*i-1
        i2=i1+1
        a(i)=(eif(iq,i2)+eif(iq1,i2))*hsq
     1       +2.*(eif(iq,i1)-eif(iq1,i1))*hcu
        b(i)=-(2.*eif(iq,i2)+eif(iq1,i2))*hr
     1       -3.*(eif(iq,i1)-eif(iq1,i1))*hsq
      enddo
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
      do i=j1,j2
        i1=2*i-1
        i2=i1+1
        q(i)=eif(iq,i1)+t*(eif(iq,i2)+t*(b(i)+t*a(i)))
        qp(i)=(eif(iq,i2)+t*(2.*b(i)+t*3.*a(i)))*rr
      enddo
c
      aa=xac*(acon(iq)+t*(qacon(1,iq)+t*(qacon(2,iq)+t*qacon(3,iq))))
      cc=xac*(ccon(iq)+t*(qccon(1,iq)+t*(qccon(2,iq)+t*qccon(3,iq))))
      ff=xf*(fcon(iq)+t*(qfcon(1,iq)+t*(qfcon(2,iq)+t*qfcon(3,iq))))
      ll=xln*(lcon(iq)+t*(qlcon(1,iq)+t*(qlcon(2,iq)+t*qlcon(3,iq))))
      nn=xln*(ncon(iq)+t*(qncon(1,iq)+t*(qncon(2,iq)+t*qncon(3,iq))))
      rrho=rho(iq)+t*(qrho(1,iq)+t*(qrho(2,iq)+t*qrho(3,iq)))
      gr=g(iq)+t*(gd+t*(bg+t*ag))
      radjq=radj(iq)+t*(qradj(1,iq)+t*(qradj(2,iq)+t*qradj(3,iq)))
      etan=ff/(aa-2.*ll)
      delv2=(ll+nn)/rrho
      delvp2=(aa+cc)/rrho
c
      if(jcom.ne.2) then
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
        rkr0=((8.*rrho-omn2)*ur2*rr-gr*ur*(f+2.*ur)+2.*ur*ppr)*rr+fl3*t1
     1    +radjq*rr*rr
      else
        xx=vpr-vr
        xx2=xx*xx
        vr2=vr*vr
        rkl0=fl3*xx2
        rkn0=con3*vr2
        t1=-omn2*vr2*rr2
        rkr0=fl3*t1
      endif
c
c  spline relative perturbation in density: moho-cmb
c
      if(iq.gt.noc.and.iq.lt.moho) then
        x=2.*(rr-r(noc))/(r(moho)-r(noc))-1.
        do i=1,21

          pnx=splh(i-1,x)
          if(jcom.eq.2) then
            vkerp=0.0
            vkers=rrho*delv2*(rkn0+rkl0)
            vkerr=rrho*(rkr0+.5*(delv2*(rkl0+rkn0)))
          else
            vkerp=rrho*delvp2*(rka0+rkc0+etan*rkf0)
            vkers=rrho*delv2*(rkn0+rkl0-2.*etan*rkf0)
            vkerr=rrho*(rkr0
     1     +.5*(delvp2*(rka0+rkc0+etan*rkf0)
     1      +delv2*(rkl0+rkn0-2.*etan*rkf0)  )    )
          endif
          temp(i+3)=temp(i+3)+wt(il)*hnh*pnx*vkerr
        enddo
      endif
c
c  crustal correction -- volumetric perturbations
c
CC      if(iq.ge.moho) then
CC        vs=sqrt(ll/rrho)
CC        vvp=sqrt(aa/rrho)
CC        if(iq.gt.nmidc) goto 402
CC       ddrho=drlc
CC        ddvs2=2.*vs*dvslc*delvn
CC        ddvp2=2.*vvp*dvplc*delvn
CC        goto 404
CC  402   if(iq.gt.nsl) goto 403
CC        ddrho=druc
CC        ddvs2=2.*vs*dvsuc*delvn
CC        ddvp2=2.*vvp*dvpuc*delvn
CC        goto 404
CC  403   ddrho=droc
CC        ddvs2=2.*vs*dvsoc*delvn
CC        ddvp2=2.*vvp*dvpoc*delvn
CC  404   etan=ff/(aa-2.*ll)
CC        if(jcom.ne.2) add=wt(il)*hnh*(
CC     1    rrho*(ddvp2*(rka0+rkc0+etan*rkf0)
CC     2       +ddvs2*(rkn0+rkl0-2.*etan*rkf0))
CC     3   +(aa*rka0+cc*rkc0+nn*rkn0+ll*rkl0+ff*rkf0+rrho*rkr0)*ddrho/rrho)
CC        if(jcom.eq.2) add=wt(il)*hnh*(
CC     1    rrho*(ddvs2*(rkn0+rkl0))
CC     2   +(nn*rkn0+ll*rkl0+rrho*rkr0)*ddrho/rrho)
CC        temp(3)=temp(3)+add
CC      endif
      
c
  110 continue

      goto 400
   
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
c  crustal thickness
c
      if(iq.ne.nmidc.and.iq.ne.moho.and.iq.ne.nsl.and.iq.ne.n) goto 301
      delh=0.
CC      if(iq.eq.n) delh=drn*deldis
CC      if(iq.eq.nsl) delh=drnsl*deldis
CC      if(iq.eq.nmidc) delh=drmidc*deldis
      if(iq.eq.nmidc) delh=-.6*deldis
CC      if(iq.eq.moho) delh=drmoho*deldis
      if(iq.eq.moho) delh=-1.0*deldis
      if(jcom.ne.2) add=-float(idis-2)*delh*
     1  (aa*rka0+cc*rkc0+ff*rkf0+
     2   ll*rkl0+nn*rkn0+rrho*rkr0)
      if(jcom.eq.2) add=-float(idis-2)*delh*
     1  (ll*rkl0+nn*rkn0+rrho*rkr0)
      temp(3)=temp(3)+add
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
      temp(2)=temp(2)+add
  302 continue
c
c  ocean surface
c
      if(iq.ne.n) goto 303
      delh=deldis
      if(jcom.ne.2) add=-float(idis-2)*delh*
     1  (aa*rka0+cc*rkc0+ff*rkf0+
     2   ll*rkl0+nn*rkn0+rrho*rkr0)
      if(jcom.eq.2) add=-float(idis-2)*delh*
     1  (ll*rkl0+nn*rkn0+rrho*rkr0)
      temp(1)=temp(1)+add
  303 continue
c
  119 continue


  400 continue


c
      do ii=1,MAXKER
        acum(ii)=acum(ii)+temp(ii)
      enddo
c
c
  100 continue
c
c
      do  i=1,MAXKER
        parm(i)=acum(i)*.5*wcom
      enddo
c
      ialp='s'
      if(jcom.eq.2) ialp='t'
      write(6,'(1x,i2,1x,a1,i4)') nord,ialp,lord
      return
      end
