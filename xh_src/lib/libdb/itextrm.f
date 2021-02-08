      subroutine itextrm(idir,itim1,itim2,itim)
      integer*4 itim1(2),itim2(2),itim(2)
      i=itcmp(itim1,itim2)
      if(idir.eq.1) then
        if(i.gt.0) then
          itim(1)=itim1(1)
          itim(2)=and(itim1(2),z'ffff0000')
        else
          itim(1)=itim2(1)
          itim(2)=and(itim2(2),z'ffff0000')
        endif
      else if(idir.eq.-1) then
        if(i.gt.0) then
          itim(1)=itim2(1)
          itim(2)=and(itim2(2),z'ffff0000')
        else
          itim(1)=itim1(1)
          itim(2)=and(itim1(2),z'ffff0000')
        endif
      else
        pause 'itextrm: invalid switch'
      endif
      return
      end
