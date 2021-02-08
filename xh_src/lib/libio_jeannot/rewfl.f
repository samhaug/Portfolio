c-------------------------------------------------------------------
c-------- Programmed by J. H. Woodhouse ----------------------------
c-------------------------------------------------------------------
      subroutine rewfl(lufl)
      include 'openfile.h'
      if(jrecl(lufl).eq.0) then
        if(jfile(lufl).le.0) then
           call rewtp(lufl)
           jfile(lufl)=0
        else
          call cmtio(jchn(lufl),2,1,ires,ierrno)
          if(ierrno.ne.0) call check('cmtio:backfile in rewfl')
          call wait(100)
          call cmtio(jchn(lufl),1,1,ires,ierrno)
          if(ierrno.ne.0) call check('cmtio:forwardfile in rewfl')
          call wait(100)
        endif
      else if(jrecl(lufl).lt.0) then
        if(jfile(lufl).le.0) then
           call rewtp(lufl)
           jfile(lufl)=0
        else
          call clseek(jchn(lufl),-4,1,ires,ierrno)
          if(ierrno.ne.0) call check('rewfl: tape image error A')
          call cread(jchn(lufl),illn,4,nrd,ierrno)
          if(ierrno.ne.0) call check('rewfl: tape image error B')
          call clseek(jchn(lufl),-4*((illn+3)/4)-8,1,ires,ierrno)
          if(ierrno.ne.0) call check('rewfl: tape image error C')
          call cread(jchn(lufl),illn1,4,nrd,ierrno)
          if(ierrno.ne.0.or.nrd.ne.4) call check('rewfl: tape image error D')
          call clseek(jchn(lufl),-4,1,ires,ierrno)
          if(illn.ne.illn1) stop 'rewfl: tape image backspace error A'
          do while(illn.ne.0)
            call clseek(jchn(lufl),-4,1,ires,ierrno)
            if(ierrno.ne.0) call check('rewfl: tape image error D')
            call cread(jchn(lufl),illn,4,nrd,ierrno)
            if(ierrno.ne.0) call check('rewfl: tape image error E')
            call clseek(jchn(lufl),-4*((illn+3)/4)-8,1,ires,ierrno)
            if(ierrno.ne.0) call check('rewfl: tape image error E')
            call cread(jchn(lufl),illn1,4,nrd,ierrno)
            if(ierrno.ne.0) call check('rewfl: tape image error F')
            if(illn.ne.illn1) stop 'rewfl: tape image backspace error'
            call clseek(jchn(lufl),-4,1,ires,ierrno)
          enddo
          call clseek(jchn(lufl),8,1,ires,ierrno)
        endif
      endif
      jrec(lufl)=0
      return
      end
