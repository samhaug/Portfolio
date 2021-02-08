c-------------------------------------------------------------------
c-------- Programmed by J. H. Woodhouse ----------------------------
c-------------------------------------------------------------------
      subroutine skipfl(lufl)
      include 'openfile.h'
      if(jrecl(lufl).eq.0) then
        call cmtio(jchn(lufl),1,1,ires,ierrno)
        if(ierrno.ne.0) call check('cmtio:forwardfile in skipfl')
        call wait(200)
        jfile(lufl)=jfile(lufl)+1
      else if(jrecl(lufl).lt.0) then
        illn=1
        do while(illn.gt.0)
          call cread(jchn(lufl),illn,4,nrd,ierrno)
          if(ierrno.ne.0) call check('skipfl: tape image error A')
          call clseek(jchn(lufl),4*((illn+3)/4),1,ires,ierrno)
          if(ierrno.ne.0) call check('skipfl: tape image error B')
          call cread(jchn(lufl),illn1,4,nrd,ierrno)
          if(ierrno.ne.0) call check('skipfl: tape image error C')
          if(illn.ne.illn1) stop 'skipfl: tape image error'
        enddo
        jfile(lufl)=jfile(lufl)+1
      endif
      jrec(lufl)=0
      return
      end
