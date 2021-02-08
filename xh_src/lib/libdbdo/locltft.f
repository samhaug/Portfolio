      integer*4 function locltft(str)
      character*1 str
      include 'seedparam.h'
      if(str.eq.'A') then
        locltft=STRFTA
      else if(str.eq.'D') then
        locltft=STRFTD
      else if(str.eq.'B') then
        locltft=STRFTB
      else
        write(6,*) str
        pause 'unknown transfer function type'
        locltft=0
      endif
      return
      end



