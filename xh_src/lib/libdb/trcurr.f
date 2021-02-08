
c-------------------------------------------------------------------

      logical function trcurr(itre,iok,ioi)
      include "dblib.h"
      la=ibig(itre+OTRKO)
      istak=ibig(itre+OTRST)
      ilev=ibig(itre+OTRLV)
      if(ibig(ibig(itre+OTRPA)+ilev).lt.0) then
        iok=-1
        ioi=-1
        trcurr=.FALSE.
      else
        iptha=ibig(itre+OTRPA)+ilev
        ikeya=ibig(itre+OTRKY)+ilev
        call stakgt(istak,ibig(iptha),ibrec)
        iok=ibrec+2+ibig(ikeya)*la
        ioi=iok+ibig(itre+OTRLK)+ibig(itre+OTRNR)
        trcurr=.TRUE.
      endif
      return
      end
