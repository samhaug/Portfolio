      subroutine getlocpd(mod,sla,slo,ela,elo,edp,phs,pd,ierr)

c     calculates partial derivatives for relocation
c     derivatives are in degrees for latitude and longitude
c     and in kilometres for the depth.
c     units of p and v are in s/degree and km/s

      character*(*) mod,phs
      dimension pd(4)
      double precision vtmp,dvsrc

c     to check whether phase file has been read
      character*20 phsold,phsout
      common/getlocpdstore/phsold,lphsold,ireadin

      data pi/3.1415926535898/
c     data deg2km/111.1949266/
      deg2rad=pi/180.
      radian=180./pi
      ierr=0

      if(mod(1:4).ne.'prem') stop 'getlocpd: models other than prem not yet implemented'

      if(ireadin.ne.999) then
       call readin
       ireadin=999
      endif

c     find the epicentral distance, check
c     whether phase is a major arc phase and find the
c     total number of bounce points in the original phase
c     correct azimuth for major arcs
      call delaz(ela,elo,sla,slo,del,azep,azst,eldg,stldg)
      azeprad=azep/radian
      lp=istlen(phs)
      if(phs(lp:lp).eq.'m') then
       imima=2
       write(6,*) 'getlocpd: major arc phase detected ',phs(1:lp),' reducing to ',phs(1:lp-1)
       phs=phs(1:lp-1)
       del=360.-del
       if(azeprad.gt.pi) then
        azeprad = azep/radian - pi
       else
        azeprad = azep/radian + pi
       endif
      else
       imima=1
      endif

c     distinguish between main phase and diffracted phase
      call schkdiff(phs,edp,del,phsout,ierr)
      if(ierr.ne.0) return

c     and check whether we can find p for this phase for this
c     distance through extrapolation
      lmd=istlen(mod)
      lph=istlen(phsout)
      if(phsout(1:lph).ne.phsold(1:lph).or.lph.ne.lphsold) then
c      write(6,*) 're-initialising phase file'
       call readphs(mod,lmd,phsout,lph,hdepmx)
       phsold=''
       phsold=phsout(1:lph)
       lphsold=istlen(phsold)
      endif

      call getphsmnmx(edp,dmn,dmx)
      if(del.gt.dmx*1.000001.or.del.lt.dmn*.999999) then
       write(6,*) phsout(1:lph),' ',del,' outside validity of interpolation'
       ierr=2
       return
      endif

c     retrieve the rayparameter for this distance
      call getphsp(del,edp,p)

c     find the velocity at the source:
      if(phsout(1:1).eq.'S'.or.phsout(1:1).eq.'s') then
       iwave=3
      else if(phsout(1:1).eq.'P'.or.phsout(1:1).eq.'p') then
       iwave=2
      else 
       stop 'getlocpd: unknown phase type'
      endif

      if(phsout(1:1).eq.'s'.or.phsout(1:1).eq.'p') then
       idown=-1
      else
       idown=1 
      endif

      call getv(iwave,dble(edp),vtmp,dvsrc,lay,ierrgetv)
      vsrc=sngl(vtmp)
      if(ierrgetv.ne.0) then
       ierr=3
       write(6,*) 'getlocpd: problem in getv'
       return
      endif
      
c     dDelta/dTheta (lat)
      pd(1)=-p*cos(azep*deg2rad)

c     dDelta/dPhi (lon)
      pd(2)=-p*sin(azep*deg2rad)*abs(cos(ela*deg2rad))

c     dT/dh
      prad=p*radian
      rev=6371.-edp
      sini=prad*vsrc/rev
      cosi=sqrt(1.-sini*sini)
      pd(3)=-float(idown)*cosi/vsrc

c     dT/dT0
      pd(4)=1.

      end



