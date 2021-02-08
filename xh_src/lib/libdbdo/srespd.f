


c--------------------------------------------------------------------
      function srespd(om,ia,a)
      dimension a(0:*),ia(0:*)
      save
      parameter (LENFLT=1)
      include 'rspaddrs.h'
      complex stgres
      common/rspsgs/stgres(20),stgdly(20)
      data tpi/6.2831853/
      srespd=0.
      ipi=ILENRS
      ipf=ipi/LENFLT
      do i=1,ia(IRSNCS)
        ktop=ipf+FLENSG
        kbot=ktop+ia(ipi+ISGLNT)
        stgdly(i)=-a(ipf+FSGCAP)+cratiod(om
     1     ,ia(ipi+ISGNTP),ia(ipi+ISGNBT),a(ktop),a(kbot)
     1     ,a(ipf+FSGAZE),ia(ipi+ISGPZC),ia(ipi+ISGABD),a(ipf+FSGINR))
        srespd=srespd+stgdly(i)
        ipi=ia(ipi+ISGADN)
        ipf=ipi/LENFLT
      enddo
      return
      end
