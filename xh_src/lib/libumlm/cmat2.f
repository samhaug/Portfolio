      subroutine cmat2(c,ic,lmode,work,iwork,kmax,ifrot,msr,mtr,msi,mti
     1  ,iswitch)
      double precision work(1)
      dimension c(1)
      if(iabs(iswitch).ne.1) stop 'invalid switch in cmat'
      kmax=0
      if(ifrot.ne.0) kmax=1+kmax
      do 10 is=0,2*lmode,2
      if(is.gt.msr) goto 10
      do 20 it=0,is
      if(it.gt.mtr) goto 20
      kmax=1+kmax
      if(it.ne.0) kmax=1+kmax
   20 continue
   10 continue
      do 11 is=0,2*lmode,2
      if(is.gt.msi) goto 11
      do 21 it=0,is
      if(it.gt.mti) goto 21
      kmax=1+kmax
      if(it.ne.0) kmax=1+kmax
   21 continue
   11 continue
      mwork=(2*lmode+1)**2
      if(mwork.gt.iwork) stop 'insufficient work space in cmat'
      mc=2*(2*lmode+1)**2*kmax
      if(mc.gt.ic) stop 'insufficient space for c matrix in cmat'
      call cmat1(c,-lmode,lmode,kmax,work,ifrot,msr,mtr,msi,mti,iswitch)
      return
      end
