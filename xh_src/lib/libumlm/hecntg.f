      subroutine hecntg(grid,igrid,ikx,iky,klin,ilin,nshd,z1,z2
     1    , i1,i2,j1,j2)
      common /mesh/ nx,nx1,nx2,nx3,ny,ny1,ny2,ny3
      common /boxdbl/ ndev
      common /ctring/ npause,isize,label,exinc,ifrot
      common/view/prm(40)
      dimension ilin(1)
      dimension jcon(5000)
      dimension con(3),grid(igrid,1)
      inx=ikx+2
      iny=iky+2
      nswap=(ikx+1)/2
      do 13 i=1,nswap
      ii1=ikx+2-i
      do 13 j=1,iky
      temp=0.
      if(ii1.le.ikx) temp=grid(ii1,j)
      grid(ii1,j)=grid(i,j)
      grid(i,j)=temp
   13 continue
      do 14 j=1,iky
      jj1=1+iky-j
      jj2=jj1+1
      do 14 i=2,ikx+1
   14 grid(i,jj2)=grid(i,jj1)
      icon = 5000
      noverr = 20
      isize=40
c     call setup(15,5,4)
c     ndev=prm(1)
c     noverr=prm(2)
c     so=prm(3)
c     dels=prm(4)
c     npause=prm(5)
c     isize=prm(6)
c     label=prm(7)
      ndev=0
c     noverr=nshd-1
      noverr=nshd
c     so=z1+(z2-z1)/float(nshd)
      so=z1
      dels=(z2-z1)/float(nshd)
      npause=0
      isize=3
      label=0
c
      nx1=inx-2
      ny1=iny-2
      nx2 = nx1 + 1
      nx3 = nx2 + 1
      nx  = nx1 - 1
      ny2 = ny1 + 1
      ny3 = ny2 + 1
      ny  = ny1 - 1
c     if(ndev.eq.0) call tekint
c     if(ndev.ne.0) call pltint
      call twindo(i1,i2,j1,j2)
c
c     enter here to contour
c
      con(2) = dels
      con(1) = so
c
c    mesh point in the range 2 < x < nx2, 2 < y < ny2 are plotted
c
      call cntorg(grid,con,jcon,icon,noverr,2,nx2,igrid,
     *2,ny2,ny3,klin,ilin)
      call tsend
      return
      end
