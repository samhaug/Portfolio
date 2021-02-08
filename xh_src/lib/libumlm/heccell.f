      subroutine heccell(grid,igrid,iky,ikx,klin,ilin,nshd,z1,z2
     1    , i1,i2,j1,j2)
      dimension grid(igrid,1),ilin(nshd),xs(5),ys(5)
      external mapfun
      gsave=grid(1,1)
      call twindo(i1,i2,j1,j2)
      call dwindo(0.,1.,0.,1.)
      xdiv=1./float(ikx-1)
      ydiv=1./float(iky-1)
      call linwdt(klin)
      do iy=1,iky-1
        do ix=1,ikx-1
          val=.25*(  grid(iy,ix)+grid(iy,ix+1)
     1              +grid(iy+1,ix)+grid(iy+1,ix+1) )
          xlev=1.+(val-z1)*float(nshd)/(z2-z1)
          if(xlev.ge.0.) then 
            lev=ifix(xlev)
          else
            lev=-1.+ifix(xlev)
          endif
          lev=min0(nshd,max0(1,lev))
          xs(1)=float(ix-1)*xdiv
          ys(1)=1.-float(iy)*ydiv
          xs(2)=xs(1)+xdiv
          ys(2)=ys(1)
          xs(3)=xs(2)
          ys(3)=ys(2)+ydiv
          xs(4)=xs(1)
          ys(4)=ys(3)
          xs(5)=xs(1)
          ys(5)=ys(1)
          call filcol(ilin(lev))
          call polyfil(1,xs,ys,1,5)
        enddo
      enddo
      call tsend
      return
      end
