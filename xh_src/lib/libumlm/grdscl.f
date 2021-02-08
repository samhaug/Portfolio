      subroutine grdscl(grid,igrid,ikla,iklo,zmin,zmax)
      dimension grid(igrid,1)
      zmin1=zmin+.001*(zmax-zmin)
      zmax1=zmax-.001*(zmax-zmin)
      do 100 ilon=1,iklo
      z=zmin1+(float(ilon-1))*(zmax1-zmin1)/float(iklo-1)
      do 100 ilat=1,ikla
      grid(ilat,ilon)=z
  100 continue
      return
      end
