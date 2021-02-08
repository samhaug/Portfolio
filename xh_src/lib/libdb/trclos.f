c-------------------------------------------------------------------

      subroutine trclos(itradr)
      include "dblib.h"
      call dalloc(ibig(itradr+OTRML),ibig(itradr+OTRKY))
      call dalloc(ibig(itradr+OTRML),ibig(itradr+OTRPA))
      call stakcl(ibig(itradr+OTRST))
      if(ibig(itradr+OTRFA).eq.-1) call closfl(ibig(ibig(itradr+OTRST)+OSTLU))
      ibig(itradr+OTRFR)=-1
      if(itradr.ne.iptree) pause 'closing tree not last opened'
      call dalloc(LTRPK+ibig(itradr+OTRLN),itradr)
      iptree=ibig(itradr+OTRLO)
      return
      end
