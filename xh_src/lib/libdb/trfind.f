c-------------------------------------------------------------------

      logical function trfind(itre,key,klen,iok,ioi)
      include "dblib.h"
      integer*4 icmpky,fcmpky,dcmpky
      external icmpky,fcmpky,dcmpky
      dimension key(*)
c ! extension chain address undefined
c     write(6,'(''trfind 1: '',2i12,20a4)') itre,klen,(key(i),i=1,klen)
      ibig(itre+OEXCH)=-1
      lk=ibig(itre+OTRLK)
      if(klen.ne.lk) then
        write(0,*) 'trfind: key length',lk,' not',klen
        pause 'trfind: key of wrong length'
      endif
      la=ibig(itre+OTRKO)
      iform=and(ibig(itre+OTRTP),MTRKT)
      ilev=0
      ibig(ibig(itre+OTRPA)+ilev)=ibig(itre+OTRFR)
      trfind=.FALSE.
c ! nothing in the tree
      if(ibig(itre+OTRFR).lt.0) then
        ibig(itre+OTRLV)=ilev
c     write(6,'(''trfind 2'')')
        return
      endif
  100 continue
c     write(6,'(''trfind 2: '',2i12)')ibig(itre+OTRST),ibig(ibig(itre+OTRPA)+ilev)

      call stakgt(ibig(itre+OTRST),ibig(ibig(itre+OTRPA)+ilev),ibrec)
c     write(6,'(''trfind 3: '',3i12)')ibig(itre+OTRST),ibig(ibig(itre+OTRPA)+ilev),ibrec
      
c     write(6,'(''trfind 5: '',3i12)')iform,VTRAK
      if     (iform.eq.VTRAK) then
        call lkupbi(ibig(ibrec+2),la,ibig(ibrec),key,lk,6,lub,ifeq,icmpky)
      else if(iform.eq.VTRIK) then
        call lkupbi(ibig(ibrec+2),la,ibig(ibrec),key,lk,6,lub,ifeq,icmpky)
      else if(iform.eq.VTRHK) then
        call lkupbi(ibig(ibrec+2),la,ibig(ibrec),key,lk,6,lub,ifeq,icmpky)
      else if(iform.eq.VTRFK) then
        call lkupbi(ibig(ibrec+2),la,ibig(ibrec),key,lk,6,lub,ifeq,fcmpky)
      else if(iform.eq.VTRDK) then
        call lkupbi(ibig(ibrec+2),la,ibig(ibrec),key,lk,6,lub,ifeq,dcmpky)
      else
        pause 'trfind: unknown key format'
      endif
c     write(6,'(''trfind 4'')')

      ik=lub-1
      if(ifeq.ne.0) then
        trfind=.TRUE.
        ibig(ibig(itre+OTRKY)+ilev)=ik
        ibig(itre+OTRLV)=ilev
        iok=ibrec+ik*la+2
        ioi=iok+ibig(itre+OTRLK)+ibig(itre+OTRNR)
c     write(6,'(''trfind 3'')')
        return
      endif
      ibig(ibig(itre+OTRKY)+ilev)=ik
      ilev=1+ilev
      ibig(itre+OTRLV)=ilev
      if(ilev.ge.ibig(itre+OTRML)) then
        write(0,"('Name: ',33a4)")
     1    (ibig(itre+OTRNM+i),i=0,ibig(itre+OTRLN)-1)
        write(0,"(4x,'mord :',i8)") ibig(itre+OTROR)
        write(0,"(4x,'lkey :',i8)") ibig(itre+OTRLK)
        write(0,"(4x,'linfo:',i8)") ibig(itre+OTRLI)
        write(0,"(4x,'type: ',z8)") ibig(itre+OTRTP)
        write(0,"(4x,'maxlv:',i8)") ibig(itre+OTRML)
        write(0,"(4x,'level:',i8)") ibig(itre+OTRLV)
        pause 'too many levels'
      endif
      kt=ibig(ibrec+ik*la+1)
      ibig(ibig(itre+OTRPA)+ilev)=kt
      if(kt.ge.0) goto 100
      ibig(itre+OTRLV)=ilev
      iok=ibrec+ik*la+2
      ioi=iok+ibig(itre+OTRLK)+ibig(itre+OTRNR)
c ! search unsuccessful
c     write(6,'(''trfind 4'')')
      return
      end


c-------------------------------------------------------------------

      subroutine lkupbi(names,inc,num,ntry,nlen,ncut,iub,ifeq,compar)
      dimension names(inc,*),ntry(*)
      integer*4 compar
c     write(6,'(''lkupbi 1'')')
      ifeq=0
c ! sequential search
      if(num.le.ncut) then
        do i=1,num
          itest=compar(ntry(1),names(1,i),nlen)
          if(itest.lt.0) then
            iub=i
            goto 87
          else if(itest.eq.0) then
            ifeq=1
            iub=i
            goto 87
          endif
        enddo
        iub=num+1
   87   continue
c     write(6,'(''lkupbi 2'')')
        return
      endif
      ient=1
      ilb=0
      iub=num+1
  100 itest=compar(ntry(1),names(1,ient),nlen)
      if(itest.lt.0) then
        iub=ient
        goto 400
      else if(itest.eq.0) then
        ifeq=1
        iub=ient
c     write(6,'(''lkupbi 3'')')
        return
      else
        ilb=ient
        goto 400
      endif
  400 continue
c     write(6,'(''lkupbi 4'')')
      if(iub-ilb.eq.1) return
c     write(6,'(''lkupbi 5'')')
      if(ient.eq.1) then
        ient=num
        goto 100
      endif
      ient=(iub+ilb)/2
      goto 100
      end

c-------------------------------------------------------------------

      integer function icmpky(key1,key2,lkey)
      dimension key1(lkey),key2(lkey)
c     write(6,'(''icmpky 1'')')
      do i=1,lkey
        if(key1(i).gt.key2(i)) then
          icmpky=1
          goto 10
        else if(key1(i).lt.key2(i)) then
          icmpky=-1
          goto 10
        endif
      enddo
      icmpky=0
   10 continue
c     write(6,'(''icmpky 2'')')
      return
      end


c-------------------------------------------------------------------

      integer function fcmpky(key1,key2,lkey)
      real*4 key1(lkey),key2(lkey)
      do i=1,lkey
        if(key1(i).gt.key2(i)) then
          fkmpky=1
          goto 10
        else if(key1(i).lt.key2(i)) then
          fkmpky=-1
          goto 10
        endif
      enddo
      fkmpky=0
   10 continue
      return
      end


c-------------------------------------------------------------------

      integer function dcmpky(key1,key2,lkey)
      dimension key1(lkey),key2(lkey)
      dimension itemp1(2),itemp2(2)
      double precision dtemp1,dtemp2
      equivalence (itemp1,dtemp1),(itemp2,dtemp2)
      do i=1,lkey,2
        itemp1(1)=key1(i)
        itemp1(2)=key1(i+1)
        itemp2(1)=key2(i)
        itemp2(2)=key2(i+1)
        if(dtemp1.gt.dtemp2) then
          dcmpky=1
          goto 10
        else if(dtemp1.lt.dtemp2) then
          dcmpky=-1
          goto 10
        endif
      enddo
      dcmpky=0
   10 continue
      return
      end
