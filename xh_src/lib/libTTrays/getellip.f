      subroutine getellip(phs,elat,elon,edep,slat,slon,dtellip,ierr)

      character*8 mod
      character*(*) phs
      character*20 phsbncold,phout(10)
      common/phsbnc/phsbncold,lphsbncold,nbnc

      parameter(MXBNC=10)
      dimension delb(MXBNC),delbrad(MXBNC),pnts(2,MXBNC)

      pi=atan(1.0)*4.
      radian = 45.0/atan(1.0)
      ierr=0

      mod='prem'
      lmod=4

c     find the epicentral distance, check 
c     whether phase is a major arc phase and find the 
c     total number of bounce points in the original phase
c     correct azimuth for major arcs
      call delaz(elat,elon,slat,slon,delta,azep,azst,eldg,stldg)
      azeprad=azep/radian
      lp=istlen(phs)
      if(phs(lp:lp).eq.'m') then
       imima=2
       write(6,*) 'getcrcor: major arc phase detected ',phs(1:lp),' reducing to ',phs(1:lp-1)
       phs=phs(1:lp-1)
       delta=360.-delta
       if(azeprad.gt.pi) then
        azeprad = azep/radian - pi
       else
        azeprad = azep/radian + pi
       endif
      else
       imima=1
      endif
      write(6,*) 'Source azimuth = ',azeprad
      call getnbnc(phs,nbnct,ibtyp)

c     check whether phase is in ellipticity correction tables

      call inelcor(phs,ifnd)
      if(ifnd.eq.1) then

c      phase is available in elcor
       ecolat = (90.0-elat)/radian
       call ellref(ecolat)
       call ellcor(phs,delta,edep,ecolat,azeprad,dtellip,abrt)

      else

c      check whether we can get the ellipticity correction for this phase 
c      by splitting it up
       call splitphs(phs,phout,nout,isplit)
       write(6,*) 'USING SPLIT PHASE FOR ELLIPTICITY CORRECTION'
       do i=1,nout
        call inelcor(phout(i),ifnd)
        write(6,*) i,phout(i),ifnd
        if(ifnd.eq.0) then
         ierr=1
         write(6,*) 'getellip: phase from splitphs not in ellcor'
         return
        endif
       enddo

c      check whether we need to read bnc files in again
       lphs=istlen(phs)
       if(lphs.ne.lphsbncold) then
        lphsbncold=lphs
        phsbncold=''
        phsbncold(1:lphs)=phs(1:lphs)
        write(6,*) 'reinitialising .bnc file'
        call readbnc(mod,lmod,phs,lphs,nbnct)
       else if(phsbncold(1:lphs).ne.phs(1:lphs)) then
        lphsbncold=lphs
        phsbncold=''
        phsbncold(1:lphs)=phs(1:lphs)
        write(6,*) 'reinitialising .bnc file'
        call readbnc(mod,lmod,phs,lphs,nbnct)
       endif

c      find the lat lon of bounce points for the original (unsplit) phase
c      extend to include receiver
       call getbnc(delta,edep,delb)
       delb(nbnct+1)=delta
       do i=1,nbnct+1
        delbrad(i)=delb(i)/radian
       enddo
       call scgrcgivedel(elat,elon,slat,slon,delbrad,nbnct+1,MXBNC,pnts,idb,epd,imima)
c      do i=1,nbnct+1
c       write(6,*) pnts(2,i),pnts(1,i),delb(i),delbrad(i)*radian
c      enddo

c      now find the ellipticity corrections for the different legs
c      find appropriate lat-long for new(split) phase by comparing number
c      of bounces in split phase to that in orignal phase
       xla1=elat
       xlo1=elon
       xdep=edep
       dtellip=0.
       indexbnc=0
       delleg=0.
       do i=1,nout
        call getnbnc(phout(i),nbnc,ibtyp)
        indexbnc=indexbnc+nbnc+1
        if(indexbnc.le.nbnct) then
         xla2=pnts(2,indexbnc)
         xlo2=pnts(1,indexbnc)
c        store epicentral distance for leg
         idum=indexbnc
        else
         idum=nbnct+1
         xla2=slat
         xlo2=slon
        endif
c       check whether the remaining phase is a major arc phase
        if(imima.eq.1.or.imima.eq.2) then
         delleg=delb(idum)-delleg
        endif
        lpo=istlen(phout(i))
        write(6,*) ''
        write(6,*) 'calculating leg ',i,' ',phout(i)(1:lpo),xla1,xlo1,xla2,xlo2,indexbnc

c       this is quick fix
c       if bounce of Sup if very close to station (less than .02 degree)
c       delaz gives an inexact answer:
        dlo=xlo2-xlo1
        dla=xla2-xla1
        del=dlo*dlo+dla*dla
        if(del.lt..02) then
         write(6,*) 'WARNING!!! FIXING delaz'
         xlo2tmp=xlo1+.02/del*dlo
         xla2tmp=xla1+.02/del*dla
         call delaz(xla1,xlo1,xla2tmp,xlo2tmp,delt,azep,azst,thcs,thcr)
        else
c        write(6,*) 'calculating ellip cor for',xla1,xlo1,xla2,xlo2
         call delaz(xla1,xlo1,xla2,xlo2,delt,azep,azst,thcs,thcr)
        endif
  
c       write(6,*) 'na delaz'
        ecolat = (90.0-xla1)/radian
        call ellref(ecolat)

c       check whether the distance of the leg exceeds 180 degrees 
c       major arc phase is still possible for SS from SSS, for instance
c       if so adjust azimuth for the ellipticity calculation
        if(delleg.gt.180.) then
         write(6,*) 'MAJOR ARC DETECTED IN SPLIT PHASE'
         if(azeprad.gt.pi) then
          azeprad = azep/radian - pi
         else
          azeprad = azep/radian + pi
         endif
        else
         azeprad = azep/radian
        endif

        write(6,*) 'azimuth, delta for leg',azeprad, delleg
        call ellcor(phout(i),delt,xdep,ecolat,azeprad,dt,abrt)
c       check whether leg exceeds 180 degrees (possible for SSS, for instance)
        write(6,*) 'dtellip for this leg: ',dt
c       write(6,*) 'na ellcor'
        dtellip=dtellip+dt
        xla1=xla2
        xlo1=xlo2
        xdep=0.
       enddo
      endif

      end
        

