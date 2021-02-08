
c-------------------------------------------------------------------
      subroutine trapnd(itre,ibuf,nwords)
      include "dblib.h"
      integer*4 ibuf(*)
      la=ibig(itre+OTRKO)
      ilev=ibig(itre+OTRLV)
      lkey=ibig(itre+OTRLK)
      linfo=ibig(itre+OTRLI)
      lres=ibig(itre+OTRNR)
      iptha=ibig(itre+OTRPA)+ilev
      ikeya=ibig(itre+OTRKY)+ilev
      istak=ibig(itre+OTRST)
      if(ibig(iptha).lt.0) pause 'trapnd: no current key'
      lux=ibig(itre+OTRUX)
      obotol=ibig(istak+OSTBM)
      call stakgt(istak,ibig(iptha),ibrec)
      obotnw=ibig(istak+OSTBM)
      if(obotnw.ne.obotol) pause 'trapnd: not working as expected'
      k=ibrec+2+ibig(ikeya)*la+lres+lkey+linfo
      if(lux.gt.0) then
        if(nwords.gt.0) then
c ! set chaining at append point
          ibig(itre+OEXCH)=ibig(k+OEXAP)
c ! no next record
          ibig(itre+OEXFP)=-1
c ! no words
          ibig(itre+OEXNW)=0
          call trwrit(itre,ibuf,nwords)
c ! do nothing
        else
        endif
      else
        pause 'trapnd: attempt to extend a non extendable entry'
      endif
      return
      end
