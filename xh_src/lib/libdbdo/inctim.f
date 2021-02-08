
      subroutine inctim(itim)
      dimension itim(2)
      integer*2 j(2)
      integer*4 k
      equivalence (j,k)
      k=itim(2)
      j(1)=j(1)+1
      itim(2)=k
      return
      end
