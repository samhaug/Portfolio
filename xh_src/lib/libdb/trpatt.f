
      subroutine trpatt(itre,patt)
      include "dblib.h"
      character*(*) patt
      logical trfind,trnext,x
      lkey=ibig(itre+OTRLK)
      lpatt=len(patt)
      do while(lpatt.gt.0.and.patt(lpatt:lpatt).eq.' ')
        lpatt=lpatt-1
      enddo
      call balloc(lkey,ia)
      do i=0,lkey-1
        ibig(ia+i)=0
      enddo
      ic=0
      do i=0,lkey-1
        do j=1,4
        ic=1+ic
        if(patt(ic:ic).eq.'*'
     1       .or.patt(ic:ic).eq.'?'.or.ic.gt.lpatt) goto 10
          ibig(ia+i)=ior4(ibig(ia+i),ishft4(ichar(patt(ic:ic)),(4-j)*8))
        enddo
      enddo
   10 continue
      if(trfind(itre,ibig(ia),lkey,iok,ioi)) then
        if(.not.trnext(itre,-1,iok,ioi))
     1    x=trfind(itre,z'80000000',lkey,iok,ioi)
      endif
      call dalloc(lkey,ia)
      return
      end
