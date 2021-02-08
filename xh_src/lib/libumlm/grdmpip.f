      subroutine grdmpip(grid,igrid,ikla,iklo,rn,vn,ricb,rcnt,rx
     1  ,del12,mess)
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
      common/wkwk/cosa(9),sina(9),wrk(295),vsc(5),y1(82),y2(82)
      common/icmdl/lmax,lmaxm1,leny,npar,pertm(588),bmdl(588)
      dimension grid(igrid,1)
      radian=180./3.1415926535
      x=-1.+2.*(rx-rcnt)/(ricb-rcnt)
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
      npp=min0(1+npp,5)
      lmaxp=min0(lmaxp,lmax)
      ir1=n
      ir=n-1
      rr=rx/rn
  132 if(r(ir).le.rr.and.r(ir1).gt.rr) goto 131
      ir=ir-1
      ir1=ir1-1
      if(ir.lt.1) ir=n-1
      if(ir1.lt.2) r1=n
      goto 132
  131 continue
      t=rr-r(ir)
      xaaa=acon(ir)+t*(qacon(1,ir)+t*(qacon(2,ir)+t*qacon(3,ir)))
      xrho= rho(ir)+t*( qrho(1,ir)+t*( qrho(2,ir)+t* qrho(3,ir)))
      vs2=(vn/1000.)*sqrt(xaaa/xrho)
      do 139 icof=1,5
      pnx=pn(icof-1,x)
  139 vsc(icof)=100.*pnx/vs2
      ind1=lminp**2+1
      ind2=(lmaxp+1)**2
      do 109 ind=1,leny
  109 wrk(ind)=0.
      do 104 ind=ind1,ind2
      sum=0.
      indx=ind
      do 105 icof=1,npp
      sum=sum+vsc(icof)*bmdl(indx)
  105 indx=indx+leny
  104 wrk(ind)=sum
c
      stla=180./float(ikla-1)
      do 200 ilat=1,ikla
      xlat=90.-float(ilat-1)*stla
      call ylm(xlat,0.,lmaxp,y1,wk1,wk2,wk3)
      if(ifeven.ne.0) then
        k=0
        do ll=0,lmaxp
        llm=mod(ll,2)
          do mm=-ll,ll
          k=k+1
          if(llm.ne.0) y1(k)=0.
          enddo
        enddo
      endif
      stlo=del12/float(iklo-1)
      do 100 ilon=1,iklo
      phi=(float(ilon-1)*stlo)/radian
      sdif=sin(phi)
      cdif=cos(phi)
      sina(1)=0.
      cosa(1)=1.
      do 101 i=2,lmaxm1
      ii=i-1
      sina(i)=sina(ii)*cdif+cosa(ii)*sdif
  101 cosa(i)=cosa(ii)*cdif-sina(ii)*sdif
      k=0
      sum=0.
      do 102 l1=1,lmaxm1
      do 103 m1=1,l1
      k=k+1
      sum=sum+y1(k)*wrk(k)*cosa(m1)
      if(m1.eq.1) goto 103
      k1=k+1
      sum=sum+y1(k)*wrk(k1)*sina(m1)
      k=k1
  103 continue
  102 continue
  100 grid(ilat,ilon)=sum
  200 continue
      return
      end
