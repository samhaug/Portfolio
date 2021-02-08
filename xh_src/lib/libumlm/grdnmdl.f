      subroutine grdnmdl(grid,igrid,ikla,iklo,rn,vn,rtop1,rbot1,ip1,ip2)
      dimension grid(igrid,1)
      call grdnmdlp(grid,igrid,ikla,iklo,rn,vn,rtop1,rbot1,ip1,ip2
     1  ,360.,'?')
      return
      end
