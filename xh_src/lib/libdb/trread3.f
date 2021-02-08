c-------------------------------------------------------------------
      integer function trread3(itre,ibuf,maxbuf,iok,ioi)
      include "dblib.h"
      dimension ibuf(*)
      la=ibig(itre+OTRKO)
      ilev=ibig(itre+OTRLV)
      lkey=ibig(itre+OTRLK)
      linfo=ibig(itre+OTRLI)
      lres=ibig(itre+OTRNR)
      iptha=ibig(itre+OTRPA)+ilev
      ikeya=ibig(itre+OTRKY)+ilev
      istak=ibig(itre+OTRST)
      if(ibig(iptha).lt.0) then
        pause 'trread3: no current key'
        trread3=-1
        return
      endif
      lux=ibig(itre+OTRUX)
      obotol=ibig(istak+OSTBM)
      call stakgt(istak,ibig(iptha),ibrec)
      obotnw=ibig(istak+OSTBM)
      if(obotnw.ne.obotol) pause 'trread3: not working as expected'
      iok=ibrec+2+ibig(ikeya)*la
      ioi=iok+lres+lkey
      k=ioi+linfo
      if(lux.gt.0) then
        iend=lenlu(lux)
c ! get info from entry
        if(ibig(itre+OEXCH).lt.0) then
c ! nothing to read
          if(ibig(k+OEXAD).lt.0) then
            trread3=0
            return
c ! find first record
          else
            ianex=ibig(k+OEXAD)
            nwnex=ibig(k+OEXLN)
          endif
c ! use info from last read
        else
c ! or write
          ianex=ibig(itre+OEXFP)
          nwnex=ibig(itre+OEXNW)
        endif
        nwords=nwnex
        if(nwords+2.gt.maxbuf) pause 'trread3: buffer space exceeded'
        call bffi(lux,1,ibuf,(nwords+2)*4,j,m,ianex+1)
        call byswap4(ibuf(1+nwords),2)
c ! chaining address
        ibig(itre+OEXCH)=ianex+nwords*4
c ! and ptr to next
        ibig(itre+OEXFP)=ibuf(nwords+1)
c ! and length of next
        ibig(itre+OEXNW)=ibig(nwords+2)
        trread3=nwords
      else
        pause 'trread3: attempt to read from a non extendable entry'
        trread3=0
      endif
      return
      end
