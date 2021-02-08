c     subroutine ilbyte(k,buf,ibyt)
c     character*1 buf(*)
c     k=ichar(buf(ibyt+1))
c     return
c     end
c -------------------------------------------
      subroutine ilbyte(k,ibuf,ibyt)
      integer*4 ibuf(0:*)
      k=and(z'000000ff',ishft(ibuf(ibyt/4),-24+8*mod(ibyt,4)))
      return
      end
