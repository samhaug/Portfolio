c-------------------------------------------------------------------
c-------- Programmed by J. H. Woodhouse ----------------------------
c-------------------------------------------------------------------
      function lenfl(lufl)
      include 'openfile.h'
      if(jrecl(lufl).le.0) then
        lenfl=0
      else
        call ffstat(lufl,idummy,idummy1,isize)
        lenfl=isize
      endif
      return
      end
