c     subroutine isbyte(k,buf,j)
c		needed in subroutine trnslt.
c     character*1 buf(*)
c     buf(j+1)=char(k)
c     return
c     end
      subroutine isbyte(k,ibuf,ibyt)
      integer*4 ibuf(0:*)
      integer*4 m1(0:3),m2(0:3)
      data m1/z'00ffffff',z'ff00ffff',z'ffff00ff',z'ffffff00'/
      data m2/z'ff000000',z'00ff0000',z'0000ff00',z'000000ff'/
      n=ibyt/4
      m=mod(ibyt,4)
      ibuf(n)=or(and(ibuf(n),m1(m)),and(m2(m),ishft(k,24-8*m)))
      return
      end
