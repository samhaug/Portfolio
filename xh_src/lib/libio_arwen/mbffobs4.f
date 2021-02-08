c--------------------------------------------------------

      subroutine mbffobs4(lu,ifbin,ibuf,nbyts,j,irec)
      dimension ibuf(*)
      call byswap4(ibuf,(nbyts+3)/4)
      call mbffo(lu,ifbin,ibuf,nbyts,j,irec)
      call byswap4(ibuf,(nbyts+3)/4)
      return
      end
  
