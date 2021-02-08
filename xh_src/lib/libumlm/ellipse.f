c---------------------------------------------------------------------
      subroutine ellipse(x,y,arect,radx,rady,ithick)
      dimension arect(4,4)
      alph=4.*atan2(1.,0.)/72.
      call drawc(x+radx,y,arect,0,1)
      do 10 i=1,72
      angl=float(i)*alph
      call drawc(x+radx*cos(angl),y+rady*sin(angl),arect,1,0)
   10 continue
      call linwdt(ithick)
      call drcpolyline()
      return
      end
