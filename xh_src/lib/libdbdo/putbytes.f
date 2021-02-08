

c----------------------------------------------------------
      subroutine putbytes(nbytes,cbuf,itp,ifcode,iflush)
      character*(*) cbuf
      integer*2 minus8/-8/,right/z'00FF'/
      include "seedobuf.h"
      character*6 str6
      character*1 atype(5)/'V','A','S','T','D'/
      nget=nbytes
      k=0
      if(ifcode.ne.0.and.
     1     ((ibyteo+3.gt.lreco.or.itp.ne.itypeo).or.iflush.ne.0) )then
        if(ibyteo.ne.0) then
          do i=ibyteo+1,lreco
            cbufo(i)=' '
          enddo
        endif
        ibyteo=lreco
      endif
   10 i1=ibyteo+1
      if(i1.gt.lreco) then
        if(ireco.ne.0) call bffo(luto,1,ibufo,lreco,j,0)
        ibyteo=0
        ireco=ireco+1
        itypeo=itp
        write(str6,"(i6)") ireco
        do i=1,6
          if(str6(i:i).eq.' ') str6(i:i)='0'
        enddo
        do i=1,6
          ibyteo=ibyteo+1
          cbufo(ibyteo)=str6(i:i)
        enddo
        ibyteo=ibyteo+1
        cbufo(ibyteo)=atype(itp)
        itypeo=itp
        ibyteo=1+ibyteo
        if(ifcode.eq.0) then
          cbufo(ibyteo)='*'
        else
          cbufo(ibyteo)=' '
        endif
        i1=1+ibyteo
      endif
      i2=min0(ibyteo+nget,lreco)
      do i=i1,i2
        k=k+1
        cbufo(i)=cbuf(k:k)
      enddo
      ibyteo=i2
      nget=nget-i2+i1-1
      if(nget.ne.0) goto 10
      if(k.ne.nbytes) pause 'counting error in getbytes'
      return
      end
