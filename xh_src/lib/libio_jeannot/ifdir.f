      logical function ifdir(lufl)
      include 'openfile.h'
      dimension ibuf(1)
      call cread(jchn(lufl),ibuf,4,nread,ierrno)
      if(ierrno.eq.21) then
        ifdir=.TRUE.
      else
        ifdir=.FALSE.
        call rewfl(lufl)
      endif
      return
      end
