c----------------------------------------------------------------------
      subroutine bpumlm
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
      nbot=noc+1
      ntop=moho
      if(jcom.eq.0) return
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
      do i=1,MAXKER
        acum(i)=0.
      enddo
c
      do 100 iq=nbot,ntop
      do i=1,MAXKER
        temp(i)=0.
      enddo
      if(iq.eq.n) goto 100
c
      iiq=iq
      call corfac(iiq,wcom,jcom,xac,xf,xln)
c
      iq1=iq+1
      r1=r(iq)
      r2=r(iq1)
      hn=r2-r1
      hnh=hn*.5
      if(hn.lt.1.e-4) goto 100
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
c  polynomial relative perturbation in shear velocity: moho-670 km
c
      if(iq.gt.n670.and.iq.lt.moho) then
        x=2.*(rr-r(n670))/(r(moho)-r(n670))-1.
        do i=1,4
          iin=i-1
          pnx=pn(iin,x)
          if(jcom.eq.2) then
            add=wt(il)*rrho*delv2*pnx*(rkn0+rkl0)*hnh
          else
            add=wt(il)*rrho*delv2*pnx*(rkn0+rkl0-2.*etan*rkf0)*hnh
          endif
          temp(i)=temp(i)+add
        enddo
      endif
c
c
c  polynomial relatinve perturbation in shear velocity: 670 - cmb
c
      if(iq.gt.noc.and.iq.lt.n670) then
        x=2.*(rr-r(noc))/(r(n670)-r(noc))-1.
        do i=1,5
          iin=i-1
          pnx=pn(iin,x)
          if(jcom.eq.2) then
            add=wt(il)*rrho*delv2*pnx*(rkn0+rkl0)*hnh
          else
            add=wt(il)*rrho*delv2*pnx*(rkn0+rkl0-2.*etan*rkf0)*hnh
          endif
          temp(i+4)=temp(i+4)+add
        enddo
      endif
c
c  polynomial relative perturbation in p velocity: moho-670 km
c
      if(iq.gt.n670.and.iq.lt.moho) then
        x=2.*(rr-r(n670))/(r(moho)-r(n670))-1.
        do i=1,4
          iin=i-1
          pnx=pn(iin,x)
          if(jcom.eq.2) then
            add=0.d0
          else
            add=wt(il)*rrho*delvp2*pnx*(rka0+rkc0+etan*rkf0)*hnh
          endif
          temp(i+9)=temp(i+9)+add
        enddo
      endif
c
c  polynomial relative perturbation in p velocity: 670 - cmb km
c
      if(iq.gt.noc.and.iq.lt.n670) then
        x=2.*(rr-r(noc))/(r(n670)-r(noc))-1.
        do i=1,5
          iin=i-1
          pnx=pn(iin,x)
          if(jcom.eq.2) then
            add=0.d0
          else
            add=wt(il)*rrho*delvp2*pnx*(rka0+rkc0+etan*rkf0)*hnh
          endif
          temp(i+13)=temp(i+13)+add
        enddo
      endif
c
  110 continue
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
