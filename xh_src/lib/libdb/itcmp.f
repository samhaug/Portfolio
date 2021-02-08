c--------------------------------------------------------------------
      function itcmp(itim,jtim)
      integer*4 itim(2),jtim(2)
      if(itim(1).gt.jtim(1)) then
        itcmp=1
        return
      else if(itim(1).lt.jtim(1)) then
        itcmp=-1
        return
      else
        i2=and(z'ffff0000',itim(2))
        j2=and(z'ffff0000',jtim(2))
        if(i2.gt.j2) then
          itcmp=1
          return
        else if(i2.lt.j2) then
          itcmp=-1
          return
        else
          itcmp=0
          return
        endif
      endif
      end
