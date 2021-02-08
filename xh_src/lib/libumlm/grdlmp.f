      subroutine grdlmp(grid,igrid,ikla,iklo,rn,vn,rtop1,rbot1,xlonmx
     1  ,mess)
      character*(*) mess
      character*10 line
      real lcon,ncon
c
      common/modl1/n,nic,noc,moho,nsl,ifanis,r(222)
     1            ,rho(222),qrho(3,222),g(222),ell(222),eta(222)
      common/modl2/acon(222),qacon(3,222),ccon(222),qccon(3,222)
     1            ,lcon(222),qlcon(3,222),ncon(222),qncon(3,222)
     2            ,fcon(222),qfcon(3,222)
c
      double precision d
      common/legwk/wk1(9),wk2(9),wk3(9),sar(11),d(17,17)
     1   ,vec1(34),vec2(34),ylmh(81),ylmt(81),ylmh1(81),ylmt1(81)
      common/wkwk/cosa(9),sina(9),vsc(5,60),y1(82),y2(82)
      common/lmmdl/lmax,lmaxm1,leny,npar,pertm(588),bmdl(588)
      dimension grid(igrid,1)
      dimension polnom(5)
      rtop=5701000.
      rbot=3479958.
      radian=180./3.1415926535
      if(mess(1:1).eq.'?') then
        write(6,1) mess(3:9)
    1   format('type lmin,lmax,n and ifeven for lower mantle'
     1    ,' or nl for defaults'/a7/'* * * *')
        read(5,'(a10)') line
        if(line.eq.' ') line=mess(3:9)
      else
        line=mess(3:9)
      endif
      read(line,2) lminp,lmaxp,npp,ifeven
    2 format(i1,1x,i1,1x,i1,1x,i1)
      npp=min0(npp+1,5)
      lmaxp=min0(lmaxp,lmax)
      ir1=n
      ir=n-1
      xtop=1.-(rtop-rtop1)*2./(rtop-rbot)
      xint=2.*(rtop1-rbot1)/(float(ikla-1)*(rtop-rbot))
      do 109 irad=1,ikla
      x=xtop-xint*float(irad-1)
      if(x.lt.-1.001.or.x.gt.1.001) pause 'grdlm: x out of range'
      rr=rbot+(x+1.)*.5*(rtop-rbot)
      rr=rr/rn
  132 if(r(ir).le.rr.and.r(ir1).gt.rr) goto 131
      ir=ir-1
      ir1=ir1-1
      if(ir.lt.1) ir=n-1
      if(ir1.lt.2) ir1=n
      goto 132
  131 continue
      t=rr-r(ir)
      xaaa=acon(ir)+t*(qacon(1,ir)+t*(qacon(2,ir)+t*qacon(3,ir)))
      xrho= rho(ir)+t*( qrho(1,ir)+t*( qrho(2,ir)+t* qrho(3,ir)))
      vs2=(vn/1000.)*sqrt(xaaa/xrho)
      do 139 icof=1,5
      pnx=pn(icof-1,x)
  139 vsc(icof,irad)=100.*pnx/vs2
  109 continue
c
      call ylm(0.,0.,lmax,y1,wk1,wk2,wk3)
      if(ifeven.ne.0) then
        k=0
        do ll=0,lmax
        llm=mod(ll,2)
          do mm=-ll,ll
          k=k+1
          if(llm.ne.0) y1(k)=0.
          enddo
        enddo
      endif
      stlo=xlonmx/float(iklo-1)
      do 100 ilon=1,iklo
      phi=(float(ilon-1)*stlo)/radian
      do 101 i=1,lmaxm1
      sina(i)=sin(phi*float(i-1))
  101 cosa(i)=cos(phi*float(i-1))
      k=0
      do 102 l1=1,lmaxm1
      do 103 m1=1,l1
      k=k+1
      y2(k)=y1(k)*cosa(m1)
      if(m1.eq.1) goto 103
      k=k+1
      y2(k)=y1(k-1)*sina(m1)
  103 continue
  102 continue
      do 104 icof=1,5
      sum=0.
      ind1=lminp**2+1
      ind2=(lmaxp+1)**2
      ind=(icof-1)*leny+ind1-1
      do 105 i=ind1,ind2
      ind=ind+1
  105 sum=sum+y2(i)*bmdl(ind)
  104 polnom(icof)=sum
      do 100 irad=1,ikla
      sum=0.
      do 207 icof=1,npp
  207 sum=sum+vsc(icof,irad)*polnom(icof)
  100 grid(irad,ilon)=sum
      return
      end
