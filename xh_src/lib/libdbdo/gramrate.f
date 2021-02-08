


c-------------------------------------------------------------------------------
      function gramrate(igtab,ig)
      include 'gramblock.h'
      include '../libdb/dblib.h'
      double precision dsmpin
      iadent=igtab+ibig(igtab+OTGETIT)+(ig-1)*LTENTRY
      call byswap4(ibig(iadent+4),1)
      gramrate=1.d0/dsmpin(ibig(iadent+4))
      call byswap4(ibig(iadent+4),1)
      return
      end
