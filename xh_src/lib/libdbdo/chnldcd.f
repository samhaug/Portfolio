c--------------------------------------
      subroutine chnldcd(ckey,hz,isub,ifmt)
      double precision dsmpin
      character*16 ckey
      character*4 c4
      integer*2 jj(2)
      integer*4 ii
      equivalence (ii,jj,c4)
      c4=ckey(9:12)
      call byswap4(ii,1)
      if(ii.ne.0) then
        hz=1.d0/dsmpin(ii)
      else
        hz=0.
      endif
      c4=ckey(13:16)
      call byswap2(jj,2)
      ifmt=jj(1)
      isub=jj(2)
      return
      end
