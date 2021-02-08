      subroutine ttylmpd(elat,elon,hdep,slat,slon,
     1                    lmax,nsplmn,nsplmx,
     1                    model,phas,dsstp,MXPD,imima,imix,pd)

c     returns partial derivative to sph parameters for mixed phases
c     the derivative to S is stored in pd(i,1), to P in pd(i,2)
c     for non mixed phases, the derivative (P or S) is stored in pd1

      implicit double precision(a-h,o-z)
      character*20 phas,model

      parameter (MXS=5000000)
      dimension rad(MXS),del(MXS),vel(MXS),ds(MXS),slo(MXS)
      dimension sdel(MXS),cdel(MXS),g(MXS)

      parameter (MXKNT=21)
      common/splhprm/spknt(MXKNT),qq0(MXKNT,MXKNT),qq(3,MXKNT,MXKNT)
      dimension splstore(MXS,MXKNT)

      common/premread/icl

      real csa1(MXPD),pd(MXPD,2),csa2(MXPD)
      real selat,selon,saz1
      
      data pi/3.1415926535898d0/

      ths=elat
      phs=elon
      thr=slat
      phr=slon

c     check dimension of MXPD
      if((lmax+1)**2*(nsplmx-nsplmn+1).gt.MXPD) stop'ttylmpd: increase MXPD'

c     write(6,*) 'voor ddelaz'
c     find epicentral distance, azimuth and the corrected, geocentric, latitudes 
      call ddelaz(ths,phs,thr,phr,delt,az1,az2,thcs,thcr)

c     adjust epicentral distance and azimuth if major arc phase
      if(imima.eq.2) then
       write(6,*) 'MAJOR ARC PHASE; resetting delta and az1',delt,az1
       delt=360.d0-delt
       if(az1.gt.180.d0) then
        az1=az1-180.d0
       else
        az1=az1+180.d0
       endif
       write(6,*) delt,az1
      endif
 
c     write(6,*) 'voor getray',phas,model,hdep,delt,dsstp,nrp
c     find ray as function of r and delta - store ds steps, delta steps and velocities
      call getray(phas,model,hdep,delt,dsstp,nrp,rad,del,vel,ds,icl)
      if(nrp.gt.MXS) stop 'ttylmpd: increase dimension MXS'

c     convert to slowness
      do i=1,nrp
       slo(i)=1.d0/vel(i)
      enddo

c     calculate where type change happens and store conversion point as
c     1st step of new type
c     also check for 2nd conversion
      if(imix.eq.1) then
       itp1=isorp(rad(1),vel(1))
       do i=1,nrp
        itp=isorp(rad(i),vel(i))
c       if(mod(i,100).eq.0) write(6,*) i,itp,rad(i),vel(i)
        if(itp.ne.itp1) then
         itp2=isorp(rad(i),vel(i))
         npconv=i
         do j=npconv,nrp
          itp=isorp(rad(j),vel(j))
          if(itp.ne.itp2) then
           write(6,*) j,nrp,rad(j),vel(j),itp,itp2
           write(6,*) j,nrp,rad(j-1),vel(j-1),itp1,npconv
           stop'ttylmpd: cannot cope with multiple type changes in mixed phases'
          endif
         enddo
         exit
        endif
       enddo
       write(6,*) 'itp1, itp2, npconv',itp1,itp2,npconv
      endif
 
c     calculate and store spline values at points along ray
      call dsplhsetup()
      rcmb=3479.95776d0
      rmoho=6346.62891d0
      sf1=rcmb+rmoho
      sf2=1.d0/(rmoho-rcmb)

      do i=1,nrp
       u=(2.d0*rad(i)-sf1)*sf2
       do j=nsplmn,nsplmx
        splstore(i,j)=-dsplh(j-1,u)*slo(i)
       enddo
      enddo

c     mulitply and integrate to give partials
c     do not need to worry about varying ds-steps because
c     this will only happen in crust: splines are zero
c     anyway!

      lenshrt=2*lmax+1
      do l=0,lmax

       if(l.eq.0) then

c       do cos(0*del)
        do ns=nsplmn,nsplmx
         do k=1,nrp
          g(k)=splstore(k,ns)
         enddo
         ist=(ns-1)*lenshrt+1
         if(imix.eq.0) then
          csa1(ist)=sngl(drofint(g,dsstp,nrp))
         else
          csa1(ist)=sngl(drofint(g,dsstp,npconv-1))
          csa2(ist)=sngl(drofint(g(npconv),dsstp,nrp-npconv+1))
         endif
c        write(6,*) l,ns,ist,csa1(ist)

        enddo

       else

        ind=(l-1)*2+2
        fl=float(l)
        do i=1,nrp
         ff=fl*del(i)
         sdel(i)=sin(ff)
         cdel(i)=cos(ff)
        enddo

        do ns=nsplmn,nsplmx

c        integrate cos(l*x)
         do k=1,nrp
          g(k)=cdel(k)*splstore(k,ns)
         enddo
         ist=ind+(ns-1)*lenshrt
         if(imix.eq.0) then
          csa1(ist)=sngl(drofint(g,dsstp,nrp))
         else
          csa1(ist)=sngl(drofint(g,dsstp,npconv-1))
          csa2(ist)=sngl(drofint(g(npconv),dsstp,nrp-npconv+1))
         endif
c        write(6,*) l,ns,ist,csa1(ist)

c        integrate sin(l*x)
         do k=1,nrp
          g(k)=sdel(k)*splstore(k,ns)
         enddo
         ist=ist+1
         if(imix.eq.0) then
          csa1(ist)=sngl(drofint(g,dsstp,nrp))
         else
          csa1(ist)=sngl(drofint(g,dsstp,npconv-1))
          csa2(ist)=sngl(drofint(g(npconv),dsstp,nrp-npconv+1))
         endif
c        write(6,*) l,ns,ist,csa1(ist)

        enddo
       endif
      enddo

      selat=sngl(thcs)
      selon=sngl(elon)
      saz1=sngl(az1)

      if(imix.eq.0) then
       call ylmray (selat,selon,saz1,csa1,lmax,nsplmx,pd(1,1))
      else
       call ylmray (selat,selon,saz1,csa1,lmax,nsplmx,pd(1,itp1))
       call ylmray (selat,selon,saz1,csa2,lmax,nsplmx,pd(1,itp2))
      endif

      end

c -----------------------------------------------
        function isorp(rad,vel)

c       returns 1 if combination of depth and velocity is for S step
c       and 2 for P

        double precision rad,vel
 
        if(rad.ge.6346.62891d0) then
         if(vel.lt.4.0d0) then
          isorp=1
         else
          isorp=2
         endif
        else
         if(vel.lt.7.4d0) then
          isorp=1
         else
          isorp=2
         endif
        endif

        end
