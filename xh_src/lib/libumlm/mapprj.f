      subroutine mapprj(x,y,iproj,xp,yp)
      goto (1,2,3),iproj
      xp=x
      yp=y
      return
    1 call  mollw(y,x,xp,yp)
      return
    2 call hammer(y,x,xp,yp)
      return
    3 call aitoff(y,x,xp,yp)
      return
      end
