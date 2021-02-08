      subroutine rdmdli(lulm)
      common/icmdl/lmaxm,lmaxm1,leny,npmm,pertm(588),bmdl(588)
      dimension buff(10)
      rewind lulm
      fac=sqrt(4.*3.1415926)/1000.
      lmaxm=4
      npmm=5
c     write(6,36884)
c6884 format('maximum l to read for low man [6]: ',$)
c     read(5,"(i1)")ll
c     if(ll.ne.0)lmaxm=ll
      lmaxm1=lmaxm+1
      leny=lmaxm1**2
      k=0
      do 10 l1=1,lmaxm1
      do 10 m1=1,l1
      read(lulm,1) il,im,(buff(i),i=1,10)
    1 format(3x,i1,3x,i1,2x,10f7.2)
      if(im+1.ne.m1) stop 'error 1 in rdmdll'
      if(im.eq.0.and.il+1.ne.l1) stop 'error 2 in rdmdll'
      k=k+1
      do 20 i=1,npmm
   20 pertm(leny*(i-1)+k)=buff(2*(i-1)+1)*fac
      if(m1.eq.1) goto 10
      k=k+1
      do 30 i=1,npmm
   30 pertm(leny*(i-1)+k)=buff(2*(i-1)+2)*fac
   10 continue
      if(k.ne.leny) stop 'error 3 in rdmdll'
      return
      end
