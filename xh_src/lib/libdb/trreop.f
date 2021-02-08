

c-------------------------------------------------------------------
c needs some fixing
      subroutine trreop(ifadf,iofff,itradr)
      include "dblib.h"
      mord0=ibig(itradr+OTROR)
      lkey0=ibig(itradr+OTRLK)
      linfo0=ibig(itradr+OTRLI)
      ittyp0=ibig(itradr+OTRTP)
      call stakgt(ibig(itradr+11),ifadf,ibadf)
      ia=ibadf+iofff
      ier=0
      if(ibig(ia+ODROR).ne.mord0) ier=1
      if(ibig(ia+ODRLK).ne.lkey0) ier=ier+2
      if(ibig(ia+ODRLI).ne.linfo0) ier=ier+4
      if(ibig(ia+OTRTP).ne.ittyp0) ier=ier+8
      if(ier.ne.0) then
        write(6,"('trreop: incompatible parameters: error',i4)") ier
        pause
      else
        ibig(itradr+OTRFR)=ibig(ia+ODRFR)
      endif
      ibig(itradr+OTRLV)=0
      ibig(itradr+12)=ifadf
      ibig(itradr+13)=iofff
      return
      end
