      subroutine rdmdll(lulm)
      common/lmmdl/lmaxm,lmaxm1,leny,npmm,pertm(588),bmdl(588)
      dimension buff(10)
      rewind lulm
      fac=sqrt(4.*3.1415926)/1000.
      lmaxm=6
      npmm=5
      lmaxm1=lmaxm+1
      leny=lmaxm1**2
      k=0
      do 10 l1=1,lmaxm1
      do 10 m1=1,l1
      read(lulm,1,end=99) il,im,(buff(i),i=1,10)
    1 format(3x,i1,3x,i1,2x,10f7.2)
      if(m1.eq.1) llast=il
      mlast=im
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
   99 if(llast.ne.lmaxm) then
        if(mlast.ne.llast) pause 'error 4 in rdmdll'
        llast1=llast+1
        leny1=llast1**2
        if(k.ne.leny1) pause 'error 5 in rdmll'
        do i=1,npmm
          do k=1,leny1
            pertm(leny1*(i-1)+k)=pertm(leny*(i-1)+k)
          enddo
        enddo
        lmaxm=llast
        lmaxm1=llast1
        leny=leny1
      endif
      return
      end
