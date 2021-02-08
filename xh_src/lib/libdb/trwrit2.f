
c-------------------------------------------------------------------
      subroutine trwrit2(itre,ibuf,nwords)
      include "dblib.h"
      integer*4 ibuf(*)
      dimension itemp(2)
      la=ibig(itre+OTRKO)
      ilev=ibig(itre+OTRLV)
      lkey=ibig(itre+OTRLK)
      linfo=ibig(itre+OTRLI)
      lres=ibig(itre+OTRNR)
      iptha=ibig(itre+OTRPA)+ilev
      ikeya=ibig(itre+OTRKY)+ilev
      istak=ibig(itre+OTRST)
      if(ibig(iptha).lt.0) pause 'trwrit2: no current key'
      lux=ibig(itre+OTRUX)
      obotol=ibig(istak+OSTBM)
      call stakgt(istak,ibig(iptha),ibrec)
      obotnw=ibig(istak+OSTBM)
      if(obotnw.ne.obotol) pause 'trwrit2: not working as expected'
      k=ibrec+2+ibig(ikeya)*la+lres+lkey+linfo
      if(lux.gt.0) then
        if(nwords.gt.0) then
          iend=lenlu(lux)
c ! get info from entry
          if(ibig(itre+OEXCH).lt.0) then
c ! first extension
            if(ibig(k+OEXAD).lt.0) then
              ianex=iend
              nwnex=0
c ! save adress and length
cxy   write(6,*) 'trwrit2: pR ibig(25729)=',ibig(25729),k+OEXAD,ianex

              ibig(k+OEXAD)=ianex
cxy   write(6,*) 'trwrit2: pS ibig(25729)=',ibig(25729),k+OEXAD,ianex
c ! of this addition
              ibig(k+OEXLN)=nwords
c ! find first record
            else
              ianex=ibig(k+OEXAD)
              nwnex=ibig(k+OEXLN)
c ! new record won't fit
              if(nwnex.lt.nwords) ianex=iend
              ibig(k+OEXAD)=ianex
              ibig(k+OEXLN)=nwords
            endif
            call trtuch(itre)
c ! use info from last read
          else
c ! or write
            ianex=ibig(itre+OEXFP)
            nwnex=ibig(itre+OEXNW)
c ! new record won't fit
            if(nwnex.lt.nwords) ianex=iend
            itemp(1)=ianex
c ! attach to chain
            itemp(2)=nwords
            call byswap4(itemp,2)
            call bffo(lux,1,itemp,8,j,ibig(itre+OEXCH)+1)
            call byswap4(itemp,2)
          endif
c ! terminate chain
cxy   write(6,*) 'trwrit2: pT ibig(25729)=',ibig(25729),nwords
          ibuf(nwords+1)=-1
cxy   write(6,*) 'trwrit2: pU ibig(25729)=',ibig(25729),k+OEXAD,ianex
          ibuf(nwords+2)=0
          call byswap4(ibuf(nwords+1),2)
          call bffo(lux,1,ibuf,(nwords+2)*4,j,ianex+1)
cxy   write(6,*) 'trwrit2: pV ibig(25729)=',ibig(25729),k+OEXAD,ianex
          call byswap4(ibuf(nwords+1),2)
c ! update append point
          ibig(k+OEXAP)=ianex+nwords*4
c ! and chaining address
          ibig(itre+OEXCH)=ianex+nwords*4
c ! and ptr to next
cxy   write(6,*) 'trwrit2: pP ibig(25729)=',ibig(25729),itre,OEXFP
          ibig(itre+OEXFP)=-1
cxy   write(6,*) 'trwrit2: pQ ibig(25729)=',ibig(25729),itre,OEXFP
c ! and length of next
          ibig(itre+OEXNW)=0
          call trtuch(itre)
c ! do nothing
        else
        endif
      else
        pause 'trwrit2: attempt to extend a non extendable entry'
      endif
      return
      end
