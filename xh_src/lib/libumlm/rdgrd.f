      subroutine rdgrd(grid,igrid)
c
c     reads the grid from an existing file (in the assumption
c     that it is written with the right format!)
c     [am 29-oct-1986]
c
      character*40 flnm
      dimension    grid(igrid,1)
c
      write(6,'(/''type name of file to read grid from: '',$)')
      read(5,'(a40)')flnm
      open(28,file=flnm
     1 ,form='unformatted',status='old')
      read(28) ii,jj
      read(28)((grid(i,j),i=1,ii),j=1,jj)
      close(28)
      return
      end
