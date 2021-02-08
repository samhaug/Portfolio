c----------------------------------------------------------
      subroutine openstn(station,netukey,iflap)
      character*(*) station
      integer*4 stnkey(2)
      character*8 cstnkey
      equivalence (stnkey,cstnkey)

      stnkey(2)=0
      cstnkey(1:5)=station
      call byswap4(stnkey(2),1)
      stnkey(2)=or(stnkey(2),netukey)
      call byswap4(stnkey(2),1)


      call openstnk(cstnkey,iflap)
      return
      end
