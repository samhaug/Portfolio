      subroutine trclal()
      include "dblib.h"
      do while(iptree.ge.0)
        ipnex=ibig(iptree+OTRLO)
c       write(6,*) 'closing ',iptree
        call trclos(iptree)
      enddo

      return
      end
