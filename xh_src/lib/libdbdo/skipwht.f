c------------------------------------------------
      subroutine skipwht(string,ind,none)
      character*(*) string
      logical none
      none=.FALSE.
      lstring=len(string)
      do while (ind.le.lstring.and.string(ind:ind).eq.' ')
        ind=ind+1
      enddo
      if(ind.gt.lstring) none=.TRUE.
      return
      end
