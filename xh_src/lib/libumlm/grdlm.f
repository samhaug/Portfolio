      subroutine grdlm(grid,igrid,ikla,iklo,rn,vn,rtop1,rbot1)
      dimension grid(igrid,1)
      call grdlmp(grid,igrid,ikla,iklo,rn,vn,rtop1,rbot1,360.,'?:1 6 4 0')
      return
      end
