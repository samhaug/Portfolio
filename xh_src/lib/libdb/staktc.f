
c-------------------------------------------------------------------

c     subroutine staktc(ibadr)
      subroutine staktc(istadr)
      include "dblib.h"
c     ibig(ibig(ibadr-1))=1
      ibig(ibig(istadr+OSTUF)+ibig(istadr+OSTBM))=1
      return
      end
