      subroutine trqral()
      include "dblib.h"
      ip=iptree
      do while(ip.ge.0)
        call trqry(ip)
        ip=ibig(ip+OTRLO)
      enddo

      return
      end
