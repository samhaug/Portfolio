c-------------------------------------------------------------------
c-------- Programmed by J. H. Woodhouse ----------------------------
c-------------------------------------------------------------------
      subroutine bffos(lufl,ifbin,ibuf,nbytes,istat,irec)
      include 'openfile.h'
      dimension ibuf(*)
      parameter (IOPT=0)
      krec=irec-1
      if(irec.eq.0) krec=jrec(lufl)
      kchn=jchn(lufl)
      if(jrecl(lufl).eq.0) then
        if(krec.lt.jrec(lufl)) then
          call cmtio(jchn(lufl),4,jrec(lufl)-krec,ires,ierrno)
        else if(krec.gt.jrec(lufl)) then
          call cmtio(jchn(lufl),3,krec-jrec(lufl),ires,ierrno)
        endif
        ierrno=0
        call cwrite(jchn(lufl),ibuf,nbytes,ires,ierrno)
        if(ierrno.ne.0.or.ires.ne.nbytes) then
          call cperror('cwrite in bffos')
          call wait(10000)
          ierrno=0
          call cwrite(jchn(lufl),ibuf,nbytes,ires,ierrno)
          if(ierrno.ne.0.or.ires.ne.nbytes) then
            call cperror('cwrite in bffos on retry')
            istat=4
          else
            write(0,*) 'bffos: retry succeeded: block offset=',krec
            istat=2
          endif
        else
          istat=2
        endif
        jrec(lufl)=1+krec
      else if(jrecl(lufl).gt.0) then
        nb=nbytes
        if(jfile(lufl).ne.200) nb=min0(nbytes,jrecl(lufl))
        call clseek(jchn(lufl),jrecl(lufl)*krec,IOPT,ires,ierrno)
        if(ierrno.ne.0) call check('clseek in bffos')
        call cwrite(jchn(lufl),ibuf,nb,ires,ierrno)
        if(ierrno.ne.0.or.ires.ne.nbytes) call check('cwrite in bffos')
        istat=2
        jrec(lufl)=krec+(nb+jrecl(lufl)-1)/jrecl(lufl)
        lenglu(lufl)=max0(lenglu(lufl),jrec(lufl))
      else
        if(krec.ne.jrec(lufl)) stop 'bffos: nonsequential write to tape image'
        call cwrite(jchn(lufl),nbytes,4,ires,ierrno)
        call cwrite(jchn(lufl),ibuf,4*((nbytes+3)/4),ires,ierrno)
        call cwrite(jchn(lufl),nbytes,4,ires,ierrno)
        jrec(lufl)=1+krec
      endif
      return
      end
