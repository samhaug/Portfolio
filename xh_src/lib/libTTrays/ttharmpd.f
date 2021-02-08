
      subroutine ttharmpd(elat,elon,hdep,slat,slon,
     1                    nl,nm,leny,nsplmn,nsplmx,phim,them,oophhl,oothhl,
     1                    mod,phas,dsstp,MXPD,pd)

      implicit double precision(a-h,o-z)
      character*20 phas,mod

      parameter (MXS=20000)
      dimension rad(MXS),del(MXS),vel(MXS),ds(MXS),slo(MXS)

      parameter (MXKNT=21)
      common/splhprm/spknt(MXKNT),qq0(MXKNT,MXKNT),qq(3,MXKNT,MXKNT)
      dimension splstore(MXS,MXKNT)

      include 'parharm.h'
      dimension pnts(2,maxp)
      dimension x(maxp),y(maxp)
      dimension fcosx(maxp,maxl+1),fsinx(maxp,maxl)
      dimension fcosy(maxp,maxm+1),fsiny(maxp,maxm)
      dimension f(maxp),g(maxp),pd(*)

      data pi/3.1415926535898d0/
 
      ths=elat
      phs=elon
      thr=slat
      phr=slon

c     write(6,*) 'voor ddelaz'
c     find epicentral distance, azimuth and the corrected, geocentric, latitudes 
      call ddelaz(ths,phs,thr,phr,delt,az1,az2,thcs,thcr)
 
c     write(6,*) 'voor getray',phas,mod,hdep,delt,dsstp,nrp
c     find ray as function of r and delta - store ds steps, delta steps and velocities
      call getray(phas,mod,hdep,delt,dsstp,nrp,rad,del,vel,ds,icl)
      if(nrp.gt.MXS) stop 'ttharmpd: increase dimension MXS'
      if(nrp.gt.MXPD) stop 'ttharmpd: increase dimension of pd in main program'

c     convert to slowness
      do i=1,nrp
       slo(i)=1.d0/vel(i)
      enddo
 
c     write(6,*) 'voor cgrcgivedel'
c     find lat,lons along ray
      call cgrcgivedel(thcs,phs,thcr,phr,del,nrp,maxp,pnts,idb,epd)
c     write(6,*) 'na cgrcgivedel'

c     calculate and store spline values at points along ray
      call dsplhsetup()
      rcmb=3479.95776
      rmoho=6346.62891
      sf1=rcmb+rmoho
      sf2=1.d0/(rmoho-rcmb)

      do i=1,nrp
       u=(2*rad(i)-sf1)*sf2
       do j=nsplmn,nsplmx
        splstore(i,j)=-dsplh(j-1,u)*slo(i)
       enddo
      enddo

c     set up sines and cosines
      do i=1,nrp
       x(i)=dxphi(pnts(1,i),phim,oophhl)
       y(i)=dythe(pnts(2,i),them,oothhl)
      enddo

      do j=1,nrp
       fcosx(j,1)=1.
       fcosy(j,1)=1.
      enddo
 
      do i=1,nl
       fi=float(i)
       do j=1,nrp
        xx=fi*x(j)
        fcosx(j,i+1)=cos(xx)
        fsinx(j,i)=sin(xx)
       enddo
      enddo
 
      do i=1,nm
       fi=float(i)
       do j=1,nrp
        yy=fi*y(j)
        fcosy(j,i+1)=cos(yy)
        fsiny(j,i)=sin(yy)
       enddo
      enddo

c     mulitply and integrate to give partials
c     do not need to worry about varying ds-steps because
c     this will only happen in crust: splines are zero 
c     anyway!
      ind=0
c     cos(xx)cos(yy)
      do i=1,nl+1
       do j=1,nm+1
        do k=1,nrp
         f(k)=fcosx(k,i)*fcosy(k,j)
        enddo
        ind=ind+1
        do l=nsplmn,nsplmx
         do k=1,nrp
          g(k)=f(k)*splstore(k,l)
         enddo
         ist=(l-1)*leny+ind
         pd(ist)=drofint(g,dsstp,nrp)
        enddo
       enddo
      enddo

c     cos(xx)sin(yy)
      do i=1,nl+1
       do j=1,nm
        do k=1,nrp
         f(k)=fcosx(k,i)*fsiny(k,j)
        enddo
        ind=ind+1
        do l=nsplmn,nsplmx
         do k=1,nrp
          g(k)=f(k)*splstore(k,l)
         enddo
         ist=(l-1)*leny+ind
         pd(ist)=drofint(g,dsstp,nrp)
        enddo
       enddo
      enddo
 
c    sin(xx)cos(yy)
      do i=1,nl
       do j=1,nm+1
        do k=1,nrp
         f(k)=fsinx(k,i)*fcosy(k,j)
        enddo
        ind=ind+1
        do l=nsplmn,nsplmx
         do k=1,nrp
          g(k)=f(k)*splstore(k,l)
         enddo
         ist=(l-1)*leny+ind
         pd(ist)=drofint(g,dsstp,nrp)
        enddo
       enddo
      enddo
 
c    sin(xx)sin(yy)
      do i=1,nl
       do j=1,nm
        do k=1,nrp
         f(k)=fsinx(k,i)*fsiny(k,j)
        enddo
        ind=ind+1
        do l=nsplmn,nsplmx
         do k=1,nrp
          g(k)=f(k)*splstore(k,l)
         enddo
         ist=(l-1)*leny+ind
         pd(ist)=drofint(g,dsstp,nrp)
        enddo
       enddo
      enddo
 
      end
