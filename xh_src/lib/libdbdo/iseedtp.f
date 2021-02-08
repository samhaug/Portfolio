c-----------------------------------------------------------
      function iseedtp(typ)
      character*1 typ
      include 'seeddefs.h'
      if(typ.eq.'V') then
        iseedtp=STPV
      else if(typ.eq.'A') then
        iseedtp=STPA
      else if(typ.eq.'S') then
        iseedtp=STPS
      else if(typ.eq.'T') then
        iseedtp=STPT
      else if(typ.eq.'D') then
        iseedtp=STPD
      else
        pause 'unexpected type'
      endif
      return
      end
