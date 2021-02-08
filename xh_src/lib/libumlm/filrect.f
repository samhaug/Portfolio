c---------------------------------------------------------------------
      subroutine filrect(arect)
      dimension arect(4),x(5),y(5)
      x(1)=arect(1)
      y(1)=arect(2)
      x(2)=arect(3)
      y(2)=y(1)
      x(3)=x(2)
      y(3)=arect(4)
      x(4)=x(1)
      y(4)=y(3)
      x(5)=x(1)
      y(5)=y(1)
      call polyfil(0,x,y,1,5)
      return
      end
