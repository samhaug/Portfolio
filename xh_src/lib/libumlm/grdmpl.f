      subroutine grdmpl(grid,igrid,ikla,iklo,rn,vn,r670,rcmb,rx)
      dimension grid(igrid,1)
      call grdmplp(grid,igrid,ikla,iklo,rn,vn,r670,rcmb,rx
     1  ,360.,'?:1 6 4 0')
      return
      end
