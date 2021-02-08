      subroutine getbytes(nbytes,cbuf,itp)
      character*(*) cbuf
      integer*2 minus8/-8/,right/z'00FF'/
      include "seedbuf.h"
      nget=nbytes
      k=0
      ifcont=0
   10 i1=ibyte+1
      if(i1.gt.lrec) then
        call getlrec(irec+1)
        if(itype.eq.0) then
          itp=itype
          return
        endif
        if(ifcont.ne.0.and.icont.eq.0) pause 'No continuation record'
        i1=ibyte+1
      endif
      i2=min0(ibyte+nget,lrec)
      do i=i1,i2
        iwd=i2bias+1+(i-1)/2
        k=1+k
        if(mod(i,2).ne.0) then
          cbuf(k:k)=char(ishft(jbuf(iwd),minus8))
        else
          cbuf(k:k)=char(and(jbuf(iwd),right))
        endif
      enddo
      ibyte=i2
      nget=nget-i2+i1-1
      ifcont=1
      if(nget.ne.0) goto 10
      itp=itype
      if(k.ne.nbytes) pause 'counting error in getbytes'
      return
      end
