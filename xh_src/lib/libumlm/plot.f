      subroutine plot(x,y,n)
      common /plotc/ l
      nn = n + 1
      goto (1,2,3,4,5,6),nn
 1    call drawa(x,y)
      return
 2    call drawr(x,y)
      return
 3    call movea(x,y)
      return
 4    call mover(x,y)
      return
 5    call dasha(x,y,l)
      return
 6    call dashr(x,y,l)
      return
      end
