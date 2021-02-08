      subroutine grdnmdlp(grid,igrid,ikla,iklo,rn,vn,rtop1,rbot1,ip1,ip2
     1   ,del12,mess)
      character*(*) mess
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
***
      common/nmdl/lmaxn,nstr,anmdl(972),bnmdl(972)
***
      dimension grid(igrid,1)
      dimension polnom(5)
c     write(6,"('grdnmdl: igrid,ikla,iklo,rn,vn,rtop,rbot,ip1,ip2'
c    1,',lmaxn,nstr'/3i5,1p4e12.4,4i5)") igrid,ikla,iklo,rn,vn,rtop,rbot
c    1,ip1,ip2,lmaxn,nstr
      rmoho=6346619.
      r670= 5701000.
      rcmb= 3479958.
      if(ip1.eq.3) then
        if(ip2.ne.6) pause 'grdnmdl: unusual choice arguments'
        rtop=rmoho
        rbot=r670
      else if(ip1.eq.7) then
        if(ip2.ne.11) pause 'grdnmdl: unusual choice arguments'
        rtop=r670
        rbot=rcmb
      else
        pause 'grdnmdl: unusual choice arguments'
      endif
      lmaxm1=1+lmaxn
      leny=lmaxm1**2
      radian=180./3.1415926535

      if(mess(1:1).eq.'?') then
      write(6,1) 1,lmaxn,ip2-ip1,0
    1 format(' type lmin,lmax and n and ifeven',
     1       ' or type return for defaults'/i1,3(1x,i1)/'* * * *')
      read(5,2) lminp,lmaxp,npp
    2 format(i1,1x,i1,1x,i1)
      if(lminp.eq.0.and.lmaxp.eq.0.and.npp.eq.0.and.ifeven.eq.0) then
        lminp=1
        lmaxp=lmaxn
        npp=ip2-ip1
        ifeven=0
      endif
      else
        lminp=1
        lmaxp=lmaxn
        npp=ip2-ip1
        ifeven=0
      endif
      npp=min0(npp+1,ip2-ip1+1)
      lmaxp=min0(lmaxp,lmaxn)

      ir1=n
      ir=n-1
      xtop=1.-(rtop-rtop1)*2./(rtop-rbot)
      xint=2.*(rtop1-rbot1)/(float(ikla-1)*(rtop-rbot))
      do 109 irad=1,ikla
      x=xtop-xint*float(irad-1)
      if(x.lt.-1.001.or.x.gt.1.001) pause 'grdnmdl: x out of range'
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
      xlll=lcon(ir)+t*(qlcon(1,ir)+t*(qlcon(2,ir)+t*qlcon(3,ir)))
      xrho= rho(ir)+t*( qrho(1,ir)+t*( qrho(2,ir)+t* qrho(3,ir)))
      vs2=2.*(vn/1000.)**2*xlll/xrho
      do 139 icof=1,ip2-ip1+1
      iord=icof-1
      pnx=pn(iord,x)
  139 vsc(icof,irad)=100.*pnx/vs2
  109 continue
c
      call ylm(0.,0.,lmaxp,y1,wk1,wk2,wk3)
      if(ieven.ne.0) then
      k=0
      do ll=0,lmaxp
      llm=mod(ll,2)
        do mm=-l,l
        k=1+k
        if(llm.ne.0) y1(k)=0
        enddo
      enddo
      endif
      stlo=del12/float(iklo-1)
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
c     write(6,"('starting 104  npp,leny,ip1,ip2=',4i5)") npp
c    1  ,leny,ip1,ip2
      do 104 icof=1,npp
      sum=0.
      ind1=lminp**2+1
      ind2=min0(leny,(lmaxp+1)**2)
      ind=(icof+ip1-2)*leny+ind1-1
c     write(6,"('starting 105:  icof,lminp,lmaxp,ind1,ind2=',5i6)")
c    1  icof,lminp,lmaxp,ind1,ind2
      do 105 i=ind1,ind2
      ind=ind+1
c     if(icof.eq.1.and.ilon.eq.1) write(6,"('grdnmdl:',i6,1pe12.4)")
c    1  ind,bnmdl(ind)
  105 sum=sum+y2(i)*bnmdl(ind)
  104 polnom(icof)=sum
      do 100 irad=1,ikla
      sum=0.
      do 207 icof=1,npp
  207 sum=sum+vsc(icof,irad)*polnom(icof)
  100 grid(irad,ilon)=sum
      return
      end
