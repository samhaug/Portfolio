

c-------------------------------------------------------------------

      subroutine staksn(iforce)
      include "dblib.h"
      istadr=ipstak
   10 if(istadr.lt.0) return
      call stakfl(istadr,iforce)
      istadr=ibig(istadr)
      goto 10
      end
