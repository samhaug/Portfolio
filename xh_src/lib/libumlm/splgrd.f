      subroutine splgrd(grid1,ig1,nr1,nc1,grid2,ig2,nr2,nc2,work)
c
c  work should be dimensioned at least 8*max(nr1,nc1).
c  grid1 and grid2 can be identical, in which case ig1 muse equal ig2.
c
      dimension grid1(ig1,1),grid2(ig2,1),work(1)
      do 10 i=1,nr1
   10 call splexp(grid1(i,1),ig1,nc1,grid2(i,1),ig2,nc2,work)
      do 20 i=1,nc2
   20 call splexp(grid2(1,i),1,nr1,grid2(1,i),1,nr2,work)
      return
      end
