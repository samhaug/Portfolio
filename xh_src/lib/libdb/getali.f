      
c----------------------------------------------------------
      subroutine getali(iarg,string)
      character*(*) string
      include "iargli.h"
cc      character*200 lineli
cc      integer*4 iptli(30)
cc      common/nargch/lineli
cc      common/nargln/lstrli,numali,iptli
      string=lineli(iptli(iarg+1):iptli(iarg+2)-1)
      return
      end
