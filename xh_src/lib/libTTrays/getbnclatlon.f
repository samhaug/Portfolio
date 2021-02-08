      subroutine getbnclatlon(phout,ela,elo,edp,sla,slo,nrbnc,bla,blo,imima)

      character*(*) phout
      character*20 phsbncold,mod
      common/phsbnc/phsbncold,lphsbncold,nbnc

      parameter(MXBNC=4)
      dimension delb(MXBNC),delbrad(MXBNC),pnts(2,MXBNC),bla(MXBNC),blo(MXBNC)

      radian = 45.0/atan(1.0)

      mod='prem'
      lmd=4

c     determine epicentral distance
      call delaz(ela,elo,sla,slo,delta,azep,azst,eldg,stldg)
c     write(6,*) 'ela,elo,sla,slo,delta,azep,azst,eldg,stldg', ela,elo,sla,slo,delta,azep,azst,eldg,stldg
      if(imima.eq.2) delta=360.-delta

c     find number of surface bounces
      call getnbnc(phout,nbnc,ibtyp)
      nrbnc=nbnc
c     write(6,*)'nbnc, nrbnc= ', nbnc, nrbnc
      if(nbnc.ne.0) then

c      initialise bounce files if nescessarry
       lphs=istlen(phout)
       if(lphs.ne.lphsbncold) then
        lphsbncold=lphs
        phsbncold=''
        phsbncold(1:lphs)=phout(1:lphs)
c       write(6,*) 'reinitialising .bnc file'
        call readbnc(mod,lmd,phout,lphs,nbnc)
       else if(phsbncold(1:lphs).ne.phout(1:lphs)) then
        lphsbncold=lphs
        phsbncold=''
        phsbncold(1:lphs)=phout(1:lphs)
c       write(6,*) 'reinitialising .bnc file'
        call readbnc(mod,lmd,phout,lphs,nbnc)
       endif

c      find the lat-lon of bounce points
       call getbnc(delta,edp,delb)
c      write(6,*) 'H1 delta, edp, delb= ', delta,edp, delb(1)
       do i=1,nbnc
        delbrad(i)=delb(i)/radian
c       write(6,*) 'H2 i= ', i, ' delb= ', delb(i)
       enddo
       call scgrcgivedel(ela,elo,sla,slo,delbrad,nbnc,MXBNC,pnts,idb,epd,imima)

       do i=1,nbnc
        bla(i)=pnts(2,i)
        blo(i)=pnts(1,i)
c       write(6,*) 'i= ', i, ' bla/blo= ', bla(i), blo(i)
       enddo
      endif

      end
