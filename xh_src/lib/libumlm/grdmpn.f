      subroutine grdmpn(grid,igrid,ikla,iklo,rn,vn,rtop,rbot,ip1,ip2,rx)
      dimension grid(igrid,1)
      call grdmpnp(grid,igrid,ikla,iklo,rn,vn,rtop,rbot,ip1,ip2,rx
     1  ,360.,'?')
      return
      end
