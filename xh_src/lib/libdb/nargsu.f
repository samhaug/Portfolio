c----------------------------------------------------------
      subroutine nargsu(string)

      include "iargli.h"
cc      character*200 lineli
cc      integer*4 iptli(30)
cc      common/nargch/lineli
cc      common/nargln/lstrli,numali,iptli

      character*(*) string

      lstrli=len(string)
      k=0



      numali=0
      ip=1
   10 continue

      do while((k.le.0.or.string(k:k).eq.' ').and.k.lt.lstrli)
        k=k+1
      enddo

      if(k.ge.lstrli) return

      k1=k



      do while(k1.lt.lstrli.and.string(k1:k1).ne.' ')
        k1=k1+1
      enddo

      if(k1.eq.lstrli.and.string(k1:k1).ne.' ') k1=k1+1

      if(k1.eq.k) then
        return
      else




C       gtawrd=string(k:k1-1)
        numali=numali+1
        lineli(ip:ip+k1-1-k)=string(k:k1-1)
        iptli(numali)=ip
        ip=ip+k1-k
        iptli(numali+1)=ip


      endif



      k=k1

      if(k.le.lstrli) goto 10

      return
      end
