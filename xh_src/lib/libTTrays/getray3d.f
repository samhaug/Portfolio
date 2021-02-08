
      subroutine getray3d(elat,elon,hdep,slat,slon,
     1                    mod,phas,dsstp,mxp,rad,pnts,nrp)

      implicit double precision(a-h,o-z)
      character*20 phas,mod

      parameter (MXS=1000000)
      dimension rad(MXS),del(MXS),vel(MXS),ds(MXS)
      dimension pnts(2,MXS)

      if(mxp.ne.MXS) stop 'getray3d: inconsistent array lengths in main'
 
      ths=elat
      phs=elon
      thr=slat
      phr=slon

c     write(6,*) 'voor ddelaz',elat,elon,hdep,slat,slon,mod,phas,dsstp,mxp
c     find epicentral distance, azimuth and the corrected, geocentric, latitudes 
      call ddelaz(ths,phs,thr,phr,delt,az1,az2,thcs,thcr)

c     check whether phase is a major arc phase
      lp=istlen(phas)
      if(phas(lp:lp).eq.'m') then
       imima=2
       write(6,*) 'getray3d: major arc phase detected ',phas(1:lp),' reducing to ',phas(1:lp-1)
       phas=phas(1:lp-1)
       delt=360.d0-delt
      else
       imima=1
      endif
 
c     write(6,*) 'voor getray',phas,mod,hdep,delt,dsstp,nrp
c     find ray as function of r and delta - store ds steps, delta steps and velocities
      call getray(phas,mod,hdep,delt,dsstp,nrp,rad,del,vel,ds,icl)
      if(nrp.gt.MXS) stop 'ttharmpd: increase dimension MXS'

c     write(6,*) 'voor cgrcgivedel',thcs,phs,thcr,phr,nrp
c     find lat,lons along ray
      call cgrcgivedel(thcs,phs,thcr,phr,del,nrp,MXS,pnts,idb,epd,imima)
c     write(6,*) 'na cgrcgivedel'

      end
