      subroutine tposn(lufl,ipfile)
      include 'openfile.h'
      if(jrecl(lufl).gt.0) pause 'tposn: Attempt to position non-tape device'
      if(jrecl(lufl).eq.0) then ! tape
        if(jfile(lufl).eq.ipfile) then
        else if(ipfile.gt.jfile(lufl)) then
          call cmtio(jchn(lufl),1,ipfile-jfile(lufl),ires,ierrno)
          if(ierrno.ne.0) call check('cmtio in tposn A')
          jfile(lufl)=ipfile
          jrec(lufl)=0
        else if(ipfile.lt.jfile(lufl)) then
          if(ipfile.eq.0) then
            call rewtp(lufl)
          else
            call cmtio(jchn(lufl),2,jfile(lufl)-ipfile+1,ires,ierrno)
            if(ierrno.ne.0) call check('cmtio in tposn B')
            call cmtio(jchn(lufl),1,1,ires,ierrno)
            if(ierrno.ne.0) call check('cmtio in tposn C')
            jfile(lufl)=ipfile
          endif
          jrec(lufl)=0
        endif
      else ! tape image
        if(jfile(lufl).eq.ipfile) then
        else if(ipfile.gt.jfile(lufl)) then
          do i=1,ipfile-jfile(lufl)
            illn=1
            do while(illn.gt.0)
              call cread(jchn(lufl),illn,4,nrd,ierrno)
              if(ierrno.ne.0) call check('tposn: tape image error A')
              call clseek(jchn(lufl),4*((illn+3)/4),1,ires,ierrno)
              if(ierrno.ne.0) call check('tposn: tape image error B')
              call cread(jchn(lufl),illn1,4,nrd,ierrno)
              if(ierrno.ne.0) call check('tposn: tape image error C')
              if(illn.ne.illn1) stop 'tposn: tape image error'
            enddo
          enddo
          jfile(lufl)=ipfile
          jrec(lufl)=0
        else if(ipfile.lt.jfile(lufl)) then
          if(ipfile.eq.0) then
            call clseek(jchn(lufl),16,0,ires,ierrno)
          else
            do i=1,jfile(ipfile)-ipfile
              illn=1
              do while(illn.ne.0)
                call clseek(jchn(lufl),-4,1,ires,ierrno)
                if(ierrno.ne.0) call check('tposn: tape image error D')
                call cread(jchn(lufl),illn,4,nrd,ierrno)
                if(ierrno.ne.0) call check('tposn: tape image error E')
                call clseek(jchn(lufl),-4*((illn+3)/4)-8,1,ires,ierrno)
                if(ierrno.ne.0) call check('tposn: tape image error E')
                call cread(jchn(lufl),illn1,4,nrd,ierrno)
                if(ierrno.ne.0) call check('tposn: tape image error F')
                if(illn.ne.illn1) stop 'tposn: tape image backspace error'
              enddo
              call clseek(jchn(lufl),8,1,ires,ierrno)
            enddo
         endif
          jfile(lufl)=ipfile
          jrec(lufl)=0
        endif
      endif
      return
      end
