      subroutine rdrjo(grid,igrid)
      character*40 flnm
      dimension    grid(igrid,*)
c
      write(6,'(/''type name of file to read grid from: '',$)')
      read(5,'(a40)')flnm
      open(28,file=flnm,status='old')

      read(28,'(a1)') idum
      read(28,'(a1)') idum
      do ilat=2,60
      read(28,'(e18.8)')(grid(ilat,ilon),ilon=1,120)
      enddo
      close(28)
      sumn=0.
      sums=0.
      do ilon=1,120
      sumn=sumn+grid(2,ilon)
      sums=sums+grid(60,ilon)
      enddo
      sumn=sumn/120.
      sums=sums/120.
      do ilon=1,121
      grid(1,ilon)=sumn
      grid(61,ilon)=sums
      enddo
      do ilat=2,60
      grid(ilat,121)=grid(ilat,1)
      enddo
      return
      end
