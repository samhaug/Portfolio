

c--------------------------------------------------------------------
      complex function sresp(om,ia,a)
c
c     Evaluate the complex response at angular frequency
c     om (radians/second), using results previously stored
c     by srespinit in the arrays ia,a
c
      dimension a(0:*),ia(0:*)
      save
      include 'seedparam.h'
      parameter (LENFLT=1)
      include 'rspaddrs.h'
      complex ess,cratio
      complex stgres
      common/rspsgs/stgres(20),stgdly(20)
      ess=cmplx(0.,om)
      sresp=(1.,0.)
      ipi=ILENRS
      ipf=ipi/LENFLT
      do i=1,ia(IRSNCS)
        ktop=ipf+FLENSG
        kbot=ktop+ia(ipi+ISGLNT)
        stgres(i)=a(ipf+FSGGAI)*cratio(om
     1     ,ia(ipi+ISGNTP),ia(ipi+ISGNBT),a(ktop),a(kbot)
     1     ,a(ipf+FSGAZE),ia(ipi+ISGPZC),ia(ipi+ISGABD),a(ipf+FSGINR))
        if(i.eq.1.and.ia(IRSPOW).ne.0) then
          do j=1,ia(IRSPOW)
            stgres(i)=stgres(i)*ess
          enddo
        endif
        if(a(ipf+FSGCAP).ne.0.) stgres(i)=stgres(i)*cexp(cmplx(0.,om*a(ipf+FSGCAP)))
        sresp=sresp*stgres(i)
        ipi=ia(ipi+ISGADN)
        ipf=ipi/LENFLT
      enddo
      return
      end
