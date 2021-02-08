c------------------------------------------------
      logical function isdigit(ch)
      character*1 ch
      ich=ichar(ch)
      if(ich.ge.z'30'.and.ich.le.z'39') then
        isdigit=.TRUE.
      else
        isdigit=.FALSE.
      endif
      return
      end
