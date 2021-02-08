      subroutine getcrcor(phas,ela,elo,edp,sla,slo,selevi,crmod,iice,dtcrust,ierr,lmaxu)

      character*1 typ,typ1,typ2
      character*(*) phas,crmod
      character*20 mod,phout,dumstr

      character*20 phsbncold
      common/phsbnc/phsbncold,lphsbncold,nbnc
      common/corsetups/isetup
      character*20 oldphs
      common/ireadphs/oldphs

      parameter(MXBNC=10)
      dimension delb(MXBNC),delbrad(MXBNC),pnts(2,MXBNC),ibarr(MXBNC)

      radian = 45.0/atan(1.0)

c     set some values
      ierr=0
      mod='prem'
      lmd=4

c     set up maps for travel time interpolation as function of
c     ray parameter p
      if(isetup.ne.999) then
       if(crmod(1:6).eq.'crust5') then
        if(iice.eq.0) stop'getcrcor: iice=0 not implemented for crust5.1'
        call setupinterpcr5()
        iinttyp=1
       else if(crmod(1:6).eq.'crust2') then
        call setupinterpcr2(iice)
        iinttyp=1
       else if(crmod(1:6).eq.'ffecr2') then
        call setupinterpcrff(lmaxu)
        iinttyp=2
       else
        stop'getcrcor: unknown crustal model'
       endif
       isetup=999
      endif

c     determine epicentral distance
      call delaz(ela,elo,sla,slo,delta,azep,azst,eldg,stldg)

c     check whether phase is a major arc phase
      lp=istlen(phas)
      if(phas(lp:lp).eq.'m') then
       imima=2
       write(6,*) 'getcrcor: major arc phase detected ',phas(1:lp),' reducing to ',phas(1:lp-1)
       phas=phas(1:lp-1)
       delta=360.-delta
      else
       imima=1
      endif

c     determine ray parameter of phase
      call schkdiff(phas,edp,delta,phout,ierr)
      lph=istlen(phout)

      if(oldphs.ne.phout) then
       write(6,*) 'getcrcor: reinitialising phase times',phas,phout
       call readphs(mod,lmd,phout,lph,hdepmx)
       oldphs=phout
       loldphs=lph
      endif
  
c     check depth
      if(edp.gt.hdepmx) then
       ierr=3
       return
      endif

      call getphsmnmx(edp,delmn,delmx)
      if(delta.lt.delmn) then
       ierr=1
       return
      elseif(delta.gt.delmx) then
       write(6,*) 'delta outside interp range: delta, delmn, delmx ',delta,delmn,delmx
       ierr=2
       return
      endif

      call getphsp(delta,edp,p)
c     write(6,*) 'Ray parameter',p, 'for epc dist ',delta

c     find number of surface bounces and fill bounce type array ibarr if number of bounces > 0
      call getnbnc(phout,nbnc,ibtyp)
c     write(6,*) 'NR of bounces ',nbnc
      if(nbnc.gt.0) then
       write(dumstr,'(i<nbnc>)') ibtyp
       do j=1,nbnc
        read(dumstr(j:j),'(i1)') ibarr(j)
       enddo
      endif

c     do station side correction first
      if(ibtyp.eq.0) then
       typ=phas(1:1)
       if(typ.eq.'s'.or.typ.eq.'S') then
        vman=4.49
       else if(typ.eq.'p'.or.typ.eq.'P') then
        vman=8.19
       else
        stop 'getcrcor: unknown typ'
       endif
      else 
       ibstn=ibarr(nbnc)
       if(ibstn.eq.2.or.ibstn.eq.3) then
        write(6,*)
        write(6,'(a)') 'BOUNCING PHASE: P arrival at station'
        typ='P'
        vman=8.19
       else if(ibstn.eq.1.or.ibstn.eq.4) then
        write(6,*)
        write(6,'(a)') 'BOUNCING PHASE: S arrival at station'
        typ='S'
        vman=4.49
       else
        stop 'getcrcor: not setup for this ibtyp'
       endif
      endif

c     calculate correction at the station
      call interpttcr(sla,slo,p,typ,iinttyp,dtcrst,dh)
      prad=p*radian
      rcr=6340.
      sini=prad*vman/rcr
      cosi=sqrt(1-sini*sini)
      write(6,*) sini,cosi,dh
      if(lelev.eq.-1) then
       write(6,*) 'station topography from global topography file',dh
       dttopost=cosi*dh/vman
      else
       dttopost=cosi*((selev+3000.)/1000.)/vman
      endif
      write(6,12) dtcrst,dttopost
12    format('STATION ',20x,' dt-crust=',f8.3,' dt-topo=',f8.3)

c     now do corrections for bounce points
      if(nbnc.eq.0) then
c      write(6,*) 'DTBNBSTOT',dtbncstot
       dtbncstot=0.
      else

c      initialise bounce files for finding lat,lon of bounce points if nescessarry
       lphs=istlen(phout)
       if(lphs.ne.lphsbncold) then
        lphsbncold=lphs
        phsbncold=''
        phsbncold(1:lphs)=phout(1:lphs)
c       write(6,*) 'reinitialising .bnc file',phout
        call readbnc(mod,lmd,phout,lphs,nbnc)
       else if(phsbncold(1:lphs).ne.phout(1:lphs)) then
        lphsbncold=lphs
        phsbncold=''
        phsbncold(1:lphs)=phout(1:lphs)
c       write(6,*) 'reinitialising .bnc file',phout
        call readbnc(mod,lmd,phout,lphs,nbnc)
       endif

c      find the lat-lon of bounce points
       call getbnc(delta,edp,delb)
       do i=1,nbnc
        delbrad(i)=delb(i)/radian
c       write(6,*) 'BOUNCE ',i,delb(i)
       enddo
       call scgrcgivedel(ela,elo,sla,slo,delbrad,nbnc,MXBNC,pnts,idb,epd,imima)

c      loop over the bounce points and calculate the corrections at each bounce point
       dtbncstot=0.

       do i=1,nbnc
        bla=pnts(2,i)
        blo=pnts(1,i)
        if(ibarr(i).eq.1) then
         typ='S'
         vman=4.49
         call interpttcr(bla,blo,p,typ,iinttyp,dtbnc,dh)
         dtbnc=dtbnc*2.
c        write(6,*) sini,cosi,dh
         dttopobnc=2.*cosi*dh/vman
         write(6,11) i,bla,blo,dtbnc,dttopobnc
11       format('BOUNCE ',i1,' at ',2f8.2,' dt-crust=',f8.3,' dt-topo=',f8.3)
        else if(ibarr(i).eq.2) then
         typ='P'
         vman=8.19
         call interpttcr(bla,blo,p,typ,iinttyp,dtbnc,dh)
         dtbnc=dtbnc*2.
c        write(6,*) sini,cosi,dh
         dttopobnc=2.*cosi*dh/vman
         write(6,11) i,bla,blo,dtbnc,dttopobnc
        else if(ibarr(i).eq.3.or.ibarr(i).eq.4) then
c        do mixed bounce

c        do S part of bounce
         typ1='S'
         vman=4.49
         call interpttcr(bla,blo,p,typ1,iinttyp,dtbncs,dh)

         sini=prad*vman/rcr
         cosi=sqrt(1.-sini*sini)
         dttopobncs=cosi*dh/vman
         write(6,15) i,bla,blo,dtbncs,dttopobncs
15       format('S part of BOUNCE ',i1,' at ',2f8.2,' dt-crust=',f8.3,' dt-topo=',f8.3)

c        do P part of bounce
         typ2='P'
         vman=8.19
         call interpttcr(bla,blo,p,typ2,iinttyp,dtbncp,dh)

         sini=prad*vman/rcr
         cosi=sqrt(1-sini*sini)
c        write(6,*) sini,cosi,dh
         dttopobncp=cosi*dh/vman
         write(6,16) i,bla,blo,dtbncp,dttopobncp
16       format('P part of BOUNCE ',i1,' at ',2f8.2,' dt-crust=',f8.3,' dt-topo=',f8.3)

         dttopobnc=dttopobncs+dttopobncp
         dtbnc=dtbncs+dtbncp
         write(6,17) i,bla,blo,dtbnc,dttopobnc
17       format('sum of SP BOUNCE ',i1,' at ',2f8.2,' dt-crust=',f8.3,' dt-topo=',f8.3)

        else
         stop 'getcrcor: not yet setup for other ibtypes'
        endif

c       add latest bounce point to bounce total
        dtbncstot=dtbncstot+dtbnc+dttopobnc

       enddo
      endif

c     add bounce total to station side correction
      dtcrust=dtbncstot+dtcrst+dttopost
      write(6,18) dtcrust
c     write(6,*) dtbncstot,dtcrst,dttopost
18    format('TOTAL CRUST + TOPO                 dt=',f8.2)

      end
