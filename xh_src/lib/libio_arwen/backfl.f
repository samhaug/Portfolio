c-------------------------------------------------------------------
c-------- Programmed by J. H. Woodhouse ----------------------------
c-------------------------------------------------------------------
      subroutine backfl(lufl)
      include 'openfile.h'
      dimension izeros(2)
      if(jrecl(lufl).eq.0) then
        if(jrec(lufl).eq.0) then
          if(jfile(lufl).le.1) then
            call rewtp(lufl)
            jfile(lufl)=0
            jrec(lufl)=0
            return
          else
            call cmtio(jchn(lufl),2,2,ires,ierrno)
            if(ierrno.ne.0) call check('cmtio:backfile in backfl')
            call cmtio(jchn(lufl),1,1,ires,ierrno)
            if(ierrno.ne.0) call check('cmtio:forwardfile in backfl')
            jrec(lufl)=0
            jfile(lufl)=jfile(lufl)-1
          endif
        else
          write(0,'(''backfl: tape error C'')') 
          call exit(2)
        endif
      else if(jrecl(lufl).lt.0) then
        if(jrec(lufl).eq.0) then
          if(jfile(lufl).le.1) then
            call rewtp(lufl)
            jfile(lufl)=0
            jrec(lufl)=0
            return
          else
            call clseek(jchn(lufl),-8,1,ires,ierrno)
            if(ierrno.ne.0) call check('backfl: tape image error A')
            call cread(jchn(lufl),izeros,8,nrd,ierrno)
            if(ierrno.ne.0) call check('backfl: tape image error B')
            if(izeros(1).ne.0.or.izeros(2).ne.0.or.nrd.ne.8) then
              write(0,'(''backfl: tape image error C'',2i10)') izeros
              call exit(2)
            endif
            call clseek(jchn(lufl),-8,1,ires,ierrno)
            illn=1
            do while(illn.ne.0)
              call clseek(jchn(lufl),-4,1,ires,ierrno)
              if(ierrno.ne.0) call check('backfl: tape image error D')
              call cread(jchn(lufl),illn,4,nrd,ierrno)
              if(ierrno.ne.0) call check('backfl: tape image error E')
              call clseek(jchn(lufl),-4*((illn+3)/4)-8,1,ires,ierrno)
              if(ierrno.ne.0) call check('backfl: tape image error E')
              call cread(jchn(lufl),illn1,4,nrd,ierrno)
              if(ierrno.ne.0) call check('backfl: tape image error F')
              call clseek(jchn(lufl),-4,1,ires,ierrno)
              if(illn.ne.illn1) stop 'backfl: tape image backspace error'
            enddo
            call clseek(jchn(lufl),8,1,ires,ierrno)
            jrec(lufl)=0
            jfile(lufl)=jfile(lufl)-1
          endif
        endif
      else 
        call rewfl(lufl)
      endif
      return
      end
