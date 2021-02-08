
c-------------------------------------------------------------------
c-------- Programmed by J. H. Woodhouse ----------------------------
c-------------------------------------------------------------------
      subroutine opnflc(lufl,namein,iap,ifile,irec,istat,lrec,inewi)
c  inew=0 > old
c  inew=1 > new
c  inew=2 > fresh
c  inew=3 > unknown
c  istat=3 > new file exists
c  istat=4 > old file does not exist
c only old and new are legal for tape images on the jukebox
c inew is ignored for mag tape
      character*(*) namein
      character*80 path,name,fgetenv,home
      character*81 pathn
      character*1 null
      include 'openfile.h'
      common/optdr/ifopt(nlu)
      include 'oasstat.h'
      common/ercod/ierl
      character*160 cat2s
      save ifirst
      data ifirst/0/
      integer o20666
      parameter (o20666=6+8*(6+8*(6+8*(0+8*2))))
      integer*4 ihbuf(4)
      character*16 ahbuf
      equivalence (ihbuf,ahbuf)
      null=char(0)
  79  ifoaso=0
      inew=inewi
      if(lufl.gt.nluuse) then
        write(6,*) 'lu=',lufl
        stop 'opnfil: lu out of range'
      endif
      ierl=0

      iopt=0
      if(lrec.lt.0) iopt=1
      istat=0
      if(ifirst.eq.0) then
        ifirst=1
        do 20 i=1,nlu
   20   jchn(i)=0
      endif

      if(lufl.le.0) then
        do i=nluuse+1,nlu
          if(jchn(i).eq.0) then
            lufl=i
            goto 71
          endif
        enddo
        write(0,'(''opnflc: trying to open'',i5)') lufl
        stop 'opnflc: no available lu'
   71   continue
      endif
C
      lnamein=istlen(namein)
      if(lnamein.gt.2.and.namein(1:2).eq.'~/') then
        home=fgetenv('HOME',lhome)
        if(lhome+lnamein-1.gt.len(opnnam(lufl)) ) stop 'openflc: name too long'
        opnnam(lufl)=home(1:lhome)//namein(2:lnamein)
      else
        if(lnamein.gt.len(opnnam(lufl))) pause 'openflc: name too long'
        opnnam(lufl)=namein(1:lnamein)
      endif
c     path=namein
c     lpath=lnamein
      path=opnnam(lufl)
      lpath=istlen(path)

      if(path(1:5).eq.'/opt/') then
        name=path
        lname=istlen(name)
        call oasopen()
        ifoaso=1
        call omount(name(6:lname),inew,istat,idev,path,lpath)
        if(istat.ne.0) goto 99
        ifopt(lufl)=1
      else 
       ifopt(lufl)=0
      endif
      if(iap.eq.1.or.iap.eq.5) then
c       read only
        isunop=0
        if(inew.ne.0.and.inew.ne.3) then
          write(0,*) 'opnflc: read only file not old'
          call exit(2)
        endif
        inew=0
      else
c       read/write
        isunop=2
      endif

      if(inew.eq.0.or.inew.eq.3.or.inew.eq.1) then
        if(ifopt(lufl).eq.0.or.itchan(idev).lt.0) then
          call copen(path(1:lpath)//null,jchn(lufl),isunop,ierrno,0,0)
          if(ierrno.ne.0)  then
            if(inew.eq.3.or.inew.eq.1) then
              inew=2
            else
              jchn(lufl)=0
              istat=4
              goto 99
            endif
          else if(inew.eq.1.and.ifopt(lufl).eq.0) then
            call cclose(jchn(lufl),ires,ierrno)
            jchn(lufl)=0
            istat=3
            goto 99
          endif
          if(ifopt(lufl).ne.0) then
            itchan(idev)=jchn(lufl)
            do i=1,MXJTAP
              if(i.ne.idev.and.itchan(i).ge.0) then
                call cclose(itchan(i),ires,ierrno)
              endif
            enddo
          endif
        else
          jchn(lufl)=itchan(idev)
          do i=1,MXJTAP
            if(i.ne.idev.and.itchan(i).ge.0) then
              call cclose(itchan(i),ires,ierrno)
            endif
          enddo
          call cclose(itchan(idev),ires,ierrno)
          call copen(path(1:lpath)//null,jchn(lufl),isunop,ierrno,0,0)
          if(ierrno.ne.0) call check('opnflc: after copen')
          itchan(idev)=jchn(lufl)
        endif
      endif

      if(inew.eq.2) then
        pathn=cat2s(path(1:lpath),null,lpathn)
        call rcreao(pathn(1:lpathn),jchn(lufl))
      endif
      isuntyp=0
      call ffstat(lufl,lent,isuntyp,isize)
 
c     write(6,'(''sun file mode (octal): '',o20,z12,i12,z12)') isuntyp,isuntyp,isize,isize
      if(isuntyp.eq.o20666) then
c       call cstexc(jchn(lufl),ires,ierrno)
        jrecl(lufl)=0
        jfile(lufl)=ifile
        jrec(lufl)=irec
        if(ifile.gt.0) call cmtio(jchn(lufl),1,ifile,ires,ierrno)
        if(irec.gt.0)  call cmtio(jchn(lufl),3,irec,ires,ierrno)
      else
        isti=0
        if(isize.ge.16) then
          call cread(jchn(lufl),ihbuf,16,nread,ierrno)
          if(nread.eq.16.and.ierrno.eq.0.and.ahbuf.eq.'Tape_Image      ') then
            isti=1  ! this is a tape image
          endif
        endif
        if(isti.eq.0) then
          jrecl(lufl)=iabs(lrec)
          jfile(lufl)=isuntyp
          if(iopt.eq.1) then
            jfile(lufl)=200
          endif
          jrec(lufl)=irec
          lenglu(lufl)=(isize+jrecl(lufl)-1)/jrecl(lufl)
          if(iap.eq.3.or.iap.eq.5.or.iap.eq.6)
     1       jrec(lufl)=lenglu(lufl)+irec
          jrec(lufl)=max0(0,jrec(lufl))
        else
          jrecl(lufl)=-1
          jfile(lufl)=0
          if(ifile.gt.0) call tposn(lufl,ifile)
          if(irec.gt.0) then
            do i=1,irec
              call cread(jchn(lufl),illn,4,nrd,ierrno)
              call clseek(jchn(lufl),illn,1,ires,ierrno)
              call cread(jchn(lufl),illn1,4,nrd,ierrno)
              if(illn.ne.illn1) stop 'opnflc: tape image error'
              if(illn.eq.0) stop 'opnflc: file mark in tape image'
            enddo
            jrec(lufl)=irec
          endif
        endif
      endif

   99 continue
      if(ifoaso.ne.0) then
        call oasclose()
        ifoaso=0
      endif
      return
      end
