
      logical function digits(string)
      character*(*) string
      l=len(string)
      digits=.TRUE.
      do i=1,l
        k=ichar(string(i:i))
        if(k.lt.z'30'.or.k.gt.z'39') digits=.FALSE.
      enddo
      return
      end
