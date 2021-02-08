c-------------------------------------------------------------------
c-------- Programmed by J. H. Woodhouse ----------------------------
c-------------------------------------------------------------------
      subroutine bffis(lufl,ifbin,ibuf,nbytes,istat,nread,irec)
      include 'openfile.h'
      dimension ibuf(*)
      krec=irec-1
      if(irec.eq.0) krec=jrec(lufl)
      if(jrecl(lufl).eq.0) then
        if(krec.lt.jrec(lufl)) then
          knt=jrec(lufl)-krec
          do while(knt.ne.0)
            ido=min0(32000,knt)
            call cmtio(jchn(lufl),4,ido,ires,ierrno)
            knt=knt-ido
          enddo
        else if(krec.gt.jrec(lufl)) then
          knt=krec-jrec(lufl)
          do while(knt.ne.0)
            ido=min0(32000,knt)
            call cmtio(jchn(lufl),3,ido,ires,ierrno)
            knt=knt-ido
          enddo
        endif
        call cread(jchn(lufl),ibuf,nbytes,nread,ierrno)
        if(nread.eq.255) nread=0
        istat=2
        if(ierrno.eq.0) then
          if(nread.eq.0) istat=3
        else
          istat=5
          call cperror('cread in bffis')
c          call check('cread in bffis')
        endif
        if(istat.eq.3) goto 30
        jrec(lufl)=1+krec
        return
   30   jfile(lufl)=1+jfile(lufl)
        jrec(lufl)=0


      else if(jrecl(lufl).eq.-1) then ! tape image
        if(krec.lt.jrec(lufl)) then
          knt=jrec(lufl)-krec
          do i=1,knt
            call clseek(jchn(lufl),-4,1,ires,ierrno)
            if(ierrno.ne.0) call check('bffis: tape image error D')
            call cread(jchn(lufl),illn,4,nrd,ierrno)
            if(ierrno.ne.0) call check('bffis: tape image error E')
            call clseek(jchn(lufl),-4*((illn+3)/4)-8,1,ires,ierrno)
            if(ierrno.ne.0) call check('bffis: tape image error E')
            call cread(jchn(lufl),illn1,4,nrd,ierrno)
            if(ierrno.ne.0) call check('bffis: tape image error F')
            if(illn.ne.illn1) stop 'bffis: tape image backspace error'
            call clseek(jchn(lufl),-4,1,ires,ierrno)
            if(ierrno.ne.0) call check('bffis: tape image error G')
          enddo
        else if(krec.gt.jrec(lufl)) then
          knt=krec-jrec(lufl)
          do i=1,knt
            call cread(jchn(lufl),illn,4,nrd,ierrno)
            if(ierrno.ne.0) call check('bffis: tape image error A')
            call clseek(jchn(lufl),4*((illn+3)/4),1,ires,ierrno)
            if(ierrno.ne.0) call check('bffis: tape image error B')
            call cread(jchn(lufl),illn1,4,nrd,ierrno)
            if(ierrno.ne.0) call check('bffis: tape image error C')
            if(illn.ne.illn1) stop 'bffis: tape image error A'
            if(illn.eq.0) then
              write(0,'(''bffis: tape image io error'')')
              istat=5
              return
            endif
          enddo
        endif
        call cread(jchn(lufl),illn,4,nrd,ierrno)
        if(nrd.ne.0) then
          if(illn.gt.0) then
            call cread(jchn(lufl),ibuf,4*((illn+3)/4),nread,ierrnod)
            if(ierrnod.ne.0.or.nread.ne.4*((illn+3)/4))
     1      stop 'bffos: tape image error G'
          else
            nread=0
          endif
          call cread(jchn(lufl),illn1,4,nrd,ierrno)
          if(nrd.ne.4.or.illn.ne.illn1) stop 'bffis: tape image error H'
          istat=2
          nread=illn
          if(ierrnod.eq.0) then
            if(nread.eq.0) istat=3
          else
            istat=5
            call cperror('cread in bffis I')
          endif
        else
          nread=0
          istat=3
        endif
        if(istat.eq.3) goto 38
        jrec(lufl)=1+krec
        return
   38   jfile(lufl)=1+jfile(lufl)
        jrec(lufl)=0


      else  ! regular file
      nb=nbytes
      if(jfile(lufl).ne.200) nb=min0(nb,jrecl(lufl))
        call clseek(jchn(lufl),jrecl(lufl)*krec,0,ires,ierrno)
        if(ierrno.ne.0) call check('clseek in bffis')
        call cread(jchn(lufl),ibuf,nb,nread,ierrno)
        if(ierrno.ne.0) then
          call cperror('cread in bffis')
          write(6,'(''Error:'',i5)') ierrno
          istat=4
          call exit(2)
        else
          istat=2
          if(nread.eq.0) istat=3
          if(istat.ne.3) then
            jrec(lufl)=krec+(nread+jrecl(lufl)-1)/jrecl(lufl)
          else
            jrec(lufl)=krec
          endif
        endif
      endif
      return
      end
