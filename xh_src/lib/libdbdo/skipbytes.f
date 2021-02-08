      subroutine skipbytes(nbytes)
      include "seedbuf.h"
      nget=nbytes
      k=0
      ifcont=0
   10 i1=ibyte+1
      if(i1.gt.lrec) then
        call getlrec(irec+1)
        if(ifcont.ne.0.and.icont.eq.0) pause 'No continuation record'
        i1=ibyte+1
      endif
      i2=min0(ibyte+nget,lrec)
      ibyte=i2
      nget=nget-i2+i1-1
      ifcont=1
      if(nget.ne.0) goto 10
      itp=itype
      return
      end
