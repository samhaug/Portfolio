      subroutine rtoi(ibuf,n)
      equivalence (i,r)
      dimension ibuf(1)
      do 10 ii=1,n
      i=ibuf(ii)
   10 ibuf(ii)=r+.0001
      return
      end
