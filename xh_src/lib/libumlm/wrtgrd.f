      subroutine wrtgrd(grid,igrid,ikla,iklo)
c
c     reads the grid from an existing file (in the assumption
c     that it is written with the right format!)
c     [am 29-oct-1986]
c
      character*40 flnm
      dimension    grid(igrid,1)
c
      write(6,'(/''type name of file to write grid to: '',$)')
      read(5,'(a40)')flnm
      open(28,file=flnm,form='unformatted')
      write(28) ikla,iklo
      write(28)((grid(i,j),i=1,ikla),j=1,iklo)
      close(28)
      return
      end
