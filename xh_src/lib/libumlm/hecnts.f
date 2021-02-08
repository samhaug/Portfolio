      subroutine hecnts(grid,igrid,ikx,iky,klin,ilin,nshd,z1,z2
     1    , i1,i2,j1,j2)
      dimension grid(igrid,1),ilin(nshd)
      dimension xy(2,50000),wk(50000),ind(1000),ilev(1000)
     1 ,cxy(2,3000)
      external mapfun
      call twindo(i1,i2,j1,j2)
      call dwindo(0.,1.,0.,1.)
      is=0
      call hecnti(grid,igrid,ikx,iky,nshd,z1,z2,0.,1.,1.,0.
     1      ,0,cxy(1,1),cxy(2,1),2,npts,0,mapfun
     1      ,xy(1,1),xy(2,1),2,50000,is,ind,ilev,1000,wk,50000)
      call linwdt(klin)
      do i=1,is
      itex=min0(nshd,max0(1,ilev(i)))
      call filtex(ilin(itex))
      call polyfil(1,xy(1,ind(i)),xy(2,ind(i)),2,ind(i+1)-ind(i))
      enddo
      call tsend
      return
      end
