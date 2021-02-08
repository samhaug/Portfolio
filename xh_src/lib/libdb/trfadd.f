
c-------------------------------------------------------------------

      subroutine trfadd(itre,key,lkey,info,linfo,jnfo,ljnfo,found)
      include "dblib.h"
      logical trfind
      integer*4 info(*),key(*),jnfo(*),trread
      logical match,found
      lux=ibig(itre+OTRUX)
      if(linfo.ne.ibig(itre+OTRLI)) pause 'trfadd: info wrong length'
      found=.false.
c ! check secondary info
      if(trfind(itre,key,lkey,iok,ioi)) then
        match=.TRUE.
        if(lux.gt.0) then
          nspac=-1
          call balloc(nspac,ia)
          nspac1=nspac/2
          nspac=nspac-nspac1
          call dalloc(nspac1,ia+nspac)
          nget=trread(itre,ibig(ia),nspac)
          if(nget.ne.0) then
            if(nget.ne.ljnfo) match=.FALSE.
            do i=1,nget
              if(ibig(ia+i-1).ne.jnfo(i)) match=.FALSE.
            enddo
          else
            if(ljnfo.ne.0) match=.FALSE.
          endif
          call dalloc(nspac,ia)
        endif
        found=.TRUE.
        do i=1,linfo
          if(info(i).ne.ibig(i-1+ioi)) then
            match=.FALSE.
            goto 10
            endif
        enddo
   10   continue
        if(.not.match) pause 'inconsistent info'
      else
c       call traddk(itre,key,lkey,info,linfo,jnfo,ljnfo)
        call traddk(itre,key,lkey,info,linfo)
        if(lux.gt.0) then
          if(trfind(itre,key,lkey,iok,ioi)) then
            call trwrit(itre,jnfo,ljnfo)
          else
            pause 'added key not found'
          endif
        endif
      endif
      return
      end
