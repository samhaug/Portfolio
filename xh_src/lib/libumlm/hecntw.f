      subroutine hecntw(grid,igrid,ikx,iky,i1,i2,j1,j2)
      common /mesh/ nx,nx1,nx2,nx3,ny,ny1,ny2,ny3
      common /boxdbl/ ndev
      common /ctring/ npause,isize,label,exinc,ifrot
      common/view/prm(40)
      dimension jcon(500)
      dimension con(3),grid(igrid,1)
c     do 13 i=2,inx-1
c     do 13 j=2,iny-3
c  13 work(i,j+1)=grid(inx-i,j-1)
c     do 14 i=2,inx-1
c     work(i,2)=grid(inx-i,iny-4)
c  14 work(i,iny-1)=grid(inx-i,1)
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
c     do 13 i=2,inx-1
c     do 13 j=2,iny-1
c  13 work(i,j)=grid(inx-i,j-1)
      icon = 500
      noverr = 20
      isize=40
      call setup(5,6,4)
      ndev=prm(1)
      noverr=prm(2)
      so=prm(3)
      dels=prm(4)
      npause=prm(5)
      isize=prm(6)
      label=prm(7)
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
      call cntour(grid,con,jcon,icon,noverr,2,nx2,igrid,
     *2,ny2,ny3)
      call tsend
      return
      end
