c-----------------------------------------------------------------
      subroutine lparse(file,prompt,delim,suffix,commds,ncommds,doit)
      include 'margli.h'
      character*(*) file,suffix
      character*20 commds(*)
      character*160 fbuf
      character*160 cat2s
      character*1 prompt,delim
      logical quoted
      common/parslu/lluu
      external doit
      data ilev/0/
      parameter (MXVARS=40)
      character*20 varnms
      character*80 vars
      common/variab/nvars,varnms(MXVARS),vars(MXVARS)

      character*200 stringi,strj(MXLEVLL),string1
      dimension ipj(MXLEVLL),lstrj(MXLEVLL)
      character*200 string
      character*1 c
      character*80 swt,temp,getmli,temp1
      dimension num(2)
      data lubase/32/
      save 
      integer*4 lus(MXLEVLL),ierrlv(MXLEVLL)
      parameter (NCOMDS=3)
      character*20 comds(NCOMDS)
      data comds(1)/'check_syntax'/
      data comds(2)/'echo'/
      data comds(3)/'set'/
      logical cisv
c#if ( ! ( defined(MachineA) || defined(Machinel) ) )
c--jeroen
c#if ( ! ( defined(MachineA)  ) )
      call starttimesup()
c#endif
      ilev=ilev+1
      ierrlv(ilev)=0
      if(file.eq.'/dev/tty') then
        lus(ilev)=5
      else
        lus(ilev)=lubase+ilev
        fbuf=cat2s(file,suffix,lfbuf)
        open(lus(ilev),file=fbuf(1:lfbuf),status='old',iostat=ierr)
        if(ierr.ne.0) then
          open(lus(ilev),file=file,status='old',iostat=ierr)
          if(ierr.ne.0) then
            write(0,*) 'Unable to open:',file
            lus(ilev)=0
            ierrlv(ilev)=1
            goto 200
          endif
        endif
      endif
      lstrj(ilev)=0
      ipj(ilev)=1
 1000 if(ipj(ilev).gt.lstrj(ilev)) then
        if(lus(ilev).eq.5) write(6,"(a1,$)") prompt
        lstrj(ilev)=0
 1020   continue
c#if ( ! ( defined(MachineA) || defined(Machinel) ) )
c#if ( ! ( defined(MachineA) ) )
        call chektimesup(ival)
c#endif
        if(ival.ne.0) goto 100
        read(lus(ilev),"(a200)",end=100) stringi
        if(stringi(1:1).eq.'#'.and.lstrj(ilev).eq.0) goto 1000
        lstringi=istlen(stringi)
        if(lus(ilev).ne.5) write(6,'(a)') prompt//stringi(1:lstringi)
        strj(ilev)(lstrj(ilev)+1:lstrj(ilev)+lstringi)=stringi(1:lstringi)
        lstrj(ilev)=lstrj(ilev)+lstringi
        if(strj(ilev)(lstrj(ilev):lstrj(ilev)).eq.'\\') then
          lstrj(ilev)=lstrj(ilev)-1
          goto 1020
        endif
        ipj(ilev)=1
      endif
      lstring=0
      do while(ipj(ilev).le.lstrj(ilev).and.strj(ilev)(ipj(ilev):ipj(ilev)).ne.delim)
        lstring=1+lstring
        string(lstring:lstring)=strj(ilev)(ipj(ilev):ipj(ilev))
        ipj(ilev)=1+ipj(ilev)
      enddo
      ipj(ilev)=ipj(ilev)+1


      if(lstring.eq.0) goto 1000
      lstring=lstring+1
      string(lstring:lstring)=' '

c Resolve variables and arguments. An argument is of the form
c $99 or $'-swt'99 $'-swt'2-3 terminated by a non-number, or ${'-swt'99} or ${'-swt'2-3}
c A variable is of the form $name terminated by a non-alphanumeric
c or ${name}. A '$' within single quotes is treated literally.

c     write(6,'(a)') 'Input:'//string(1:lstring)
      quoted=.FALSE.
      ip=0
      do while(ip.lt.lstring)
        ip=ip+1
        if(string(ip:ip).eq.'$'.and..not.quoted) then
          ipd=ip
          ip=ip+1
          if(string(ip:ip).eq.'{') then
            ip=ip+1
            is1=ip
            do while(string(ip:ip).ne.'}')
              ip=ip+1
            enddo
            is2=ip-1
            ip=ip+1
          else if(string(ip:ip).ge.'0'.and.string(ip:ip).le.'9') then
            is1=ip
            ip=ip+1
            do while(string(ip:ip).ge.'0'.and.string(ip:ip).le.'9')
              ip=ip+1
            enddo
            if(string(ip:ip).eq.'-') then
              ip=ip+1
              if(string(ip:ip).eq.'*') then
                ip=ip+1
              else
                do while(string(ip:ip).ge.'0'.and.string(ip:ip).le.'9')
                  ip=ip+1
                enddo
              endif
            endif
            is2=ip-1
          else if(string(ip:ip).eq.'*') then
            is1=ip
            ip=ip+1
            is2=ip-1
          else if(string(ip:ip).eq.'''') then
            is1=ip
            ip=ip+1
            do while(string(ip:ip).ne.'''')
              ip=ip+1
            enddo
            ip=ip+1
            if(string(ip:ip).eq.'*') then
              ip=ip+1
            else
              do while(string(ip:ip).ge.'0'.and.string(ip:ip).le.'9')
                ip=ip+1
              enddo
              if(string(ip:ip).eq.'-') then
                ip=ip+1
                if(string(ip:ip).eq.'*') then
                  ip=ip+1
                else
                  do while(string(ip:ip).ge.'0'.and.string(ip:ip).le.'9')
                    ip=ip+1
                  enddo
                endif
              endif
            endif
            is2=ip-1
          else if( (string(ip:ip).ge.'a'.and.string(ip:ip).le.'z') 
     1               .or.(string(ip:ip).ge.'A'.and.string(ip:ip).le.'Z')
     1                ) then
            is1=ip
            is2=ip
            ip=ip+1
            do while((string(ip:ip).ge.'a'.and.string(ip:ip).le.'z') 
     1               .or.(string(ip:ip).ge.'A'.and.string(ip:ip).le.'Z')
     1               .or.(string(ip:ip).ge.'0'.and.string(ip:ip).le.'9'))
              is2=is2+1
              ip=ip+1
            enddo
          endif
          ipnext=ip
          if(string(is1:is1).eq.'''') then
            ip=is1+1
            lswt=0
            do while(string(ip:ip).ne.'''')
              lswt=lswt+1
              swt(lswt:lswt)=string(ip:ip)
              ip=ip+1
            enddo
            if(lswt.eq.0) then
              lswt=1
              swt(1:1)=' '
            endif
            ip=ip+1


            if(string(ip:ip).eq.'*') then
              inum=1
              inum1=9999
            else
              inum=0
              do while(string(ip:ip).ge.'0'.and.string(ip:ip).le.'9')
                inum=inum*10+ichar(string(ip:ip))-ichar('0')
                ip=ip+1
              enddo
              inum1=inum
              if(string(ip:ip).eq.'-') then
                ip=ip+1
                if(string(ip:ip).eq.'*') then
                  inum1=9999
                else
                  inum1=0
                  do while(string(ip:ip).ge.'0'.and.string(ip:ip).le.'9')
                    inum1=inum1*10+ichar(string(ip:ip))-ichar('0')
                    ip=ip+1
                  enddo
                endif
              endif
            endif
          else if(string(is1:is1).ge.'0'.and.string(is1:is1).le.'9') then
            lswt=1
            swt(1:1)=' '
            ip=is1
            inum=0
            do while(string(ip:ip).ge.'0'.and.string(ip:ip).le.'9')
              inum=inum*10+ichar(string(ip:ip))-ichar('0')
              ip=ip+1
            enddo
            inum1=inum
            if(string(ip:ip).eq.'-') then
              ip=ip+1
              if(string(ip:ip).eq.'*') then
                inum1=9999
              else
                inum1=0
                do while(string(ip:ip).ge.'0'.and.string(ip:ip).le.'9')
                  inum1=inum1*10+ichar(string(ip:ip))-ichar('0')
                  ip=ip+1
                enddo
              endif
            endif
          else if(string(is1:is1).eq.'*') then
            lswt=1
            swt(1:1)=' '
            inum=1
            inum1=9999
          else
            lswt=0
          endif
          if(lswt.gt.0) then
            ilev=ilev-1
c           do i=inum,inum1
c             write(6,'(''Calling getmli'',2i3,'':'',a)') lswt,i,swt(1:lswt)
c           enddo
            ltemp=0
            do i=inum,inum1
              temp1=getmli(swt(1:lswt),i,ltemp1)
              if(ltemp1.gt.0) then
                if(i.gt.inum) then
                  ltemp=ltemp+1
                  temp(ltemp:ltemp)=' '
                endif
                temp(ltemp+1:ltemp+ltemp1)=temp1(1:ltemp1)
                ltemp=ltemp+ltemp1
              else
                goto 1104
              endif
            enddo
 1104       continue
            ilev=ilev+1
          else   ! a variable
            call getvar(string(is1:is2),temp,ltemp)
          endif
          string1=string(1:ipd-1)//temp(1:ltemp)//string(ipnext:lstring)
          string=string1
          lstring=ipd-1+ltemp+lstring-ipnext+1
          ip=ipd-1+ltemp
        else if(string(ip:ip).eq.'''') then
          quoted=.not.quoted
        endif

      enddo
c     write(6,'(a)') 'Output:'//string(1:lstring)


C      mode=1
C      is1=0
C      quoted=.FALSE.
C      do is=1,lstring
C        c=string(is:is)
C        cisv=.FALSE.
C        if(   (c.ge.'a'.and.c.le.'z')
C     1    .or.(c.ge.'A'.and.c.le.'Z')
C     1    .or.(c.ge.'0'.and.c.le.'9') ) cisv=.TRUE.
C        if(c.eq.'''') quoted=.not.quoted
C        goto (1001,1002,1003,1004,1005),mode
Cc skipping spaces
C 1001   if((c.ne.' '.and.c.ne.'$'.and.c.ne.'%').or.quoted) then
C          is1=1+is1
C          string1(is1:is1)=c
C          mode=2
C        else if(c.eq.'$') then
C          inum=1
C          num(1)=-1
C          num(2)=-1
C          lswt=-1
C          mode=3
C        else if(c.eq.'%') then
C          mode=5
C          lswt=0
C        endif
C        goto 1099
Cc accumulating argument
C 1002   if(c.eq.' '.and..not.quoted) then
C          is1=is1+1
C          string1(is1:is1)=c
C          mode=1
C        else
C          is1=is1+1
C          string1(is1:is1)=c
C        endif
C        goto 1099
Cc accumulating num
Cc1003   if(c.eq.' ') then
C 1003   if(c.ne."'".and.c.ne.'-'.and.c.ne.'*'.and.(c.lt.'0'.or.c.gt.'9')) then
C          if(num(1).lt.0.and.num(2).lt.0) then
C            num(1)=0
C            num(2)=99999
C          else if(num(1).eq.99999.and.num(2).lt.0) then
C            num(1)=1
C            num(2)=99999
C          else if(num(1).lt.0) then
C            num(1)=0
C          else if(num(2).lt.0) then
C            num(2)=num(1)
C          endif
C          num(2)=max0(num(2),num(1))
C          if(lswt.lt.0) then
C            ia=num(1)
C            do while(ia.le.numali(ilev-1).and.ia.le.num(2))
C              do i=iptli(ia+1,ilev-1),iptli(ia+2,ilev-1)-1
C                is1=is1+1
C                string1(is1:is1)=lineli(ilev-1)(i:i)
C              enddo
C              is1=1+is1
C              string1(is1:is1)=' '
C              ia=ia+1
C            enddo
C          else
C            ilev=ilev-1
C            do ia=num(1),num(2)
C              temp=getmli(swt(1:lswt),ia,ltemp)
C              if(ltemp.le.0) goto 1103
C              do i=1,ltemp
C                is1=1+is1
C                string1(is1:is1)=temp(i:i)
C              enddo
C              is1=1+is1
C              string1(is1:is1)=c
C            enddo
C 1103       continue
C            ilev=ilev+1
C          endif
C          mode=1
C        else if(c.eq."'".and.lswt.lt.0) then
C          lswt=0
C          mode=4
C        else if(c.eq.'-') then
C          inum=2
C          num(inum)=-1
C        else
C          ic=ichar(c)
C          if(ic.ge.z'30'.and.ic.le.z'39') then
C            if(num(inum).lt.0) num(inum)=0
C            num(inum)=num(inum)*10+ic-z'30'
C          else if(c.eq.'*') then
C            num(inum)=99999
C          else
C            write(0,*) 'Error decoding count variable'
C            ierrlv(ilev)=3
C            goto 200
C          endif
C        endif
C        goto 1099
Cc accumulating swt
C 1004   if(c.eq."'") then
C          mode=3
C        else
C          lswt=lswt+1
C          swt(lswt:lswt)=c
C        endif
C        goto 1099
C 1005   if(.NOT.cisv) then
C          call getvar(swt(1:lswt),temp,ltemp)
C          string1(is1+1:is1+ltemp+1)=temp(1:ltemp)//c
C          is1=is1+ltemp+1
C          mode=1
C        else
C          lswt=lswt+1
C          swt(lswt:lswt)=c
C        endif
C1099    continue
C      enddo

C      string=string1(1:is1)
C      lstring=istlen(string)

      ic1=iststa(string)
      lcom=ic1
      do while(lcom.lt.lstring.and.string(lcom:lcom).ne.' ')
        lcom=lcom+1
      enddo
      if(string(lcom:lcom).eq.' ') lcom=lcom-1

      knt=0
      do i=1,NCOMDS
        if(string(ic1:lcom).eq.comds(i)(1:lcom-ic1+1)) then
          knt=knt+1
          icom=i
          modec=1
        endif
      enddo
      do i=1,ncommds
        if(string(ic1:lcom).eq.commds(i)(1:lcom-ic1+1)) then
          knt=knt+1
          icom=i
          modec=2
        endif
      enddo
      if(knt.gt.1) then
        write(0,*) 'Ambiguous command:',string(1:lstring)
        ierrlv(ilev)=1
        goto 200
      else if(knt.eq.0) then
c#if ( defined(MachineA) || defined(Machinel) )
c      stop 'lparse would call itself'
c#else
        call margsu(string(ic1:lstring))
c       call lparse(string(ic1:lcom),prompt,delim,suffix,commds,ncommds,doit)
c#endif
        call lparseh(string(ic1:lcom),prompt,delim,suffix,commds,ncommds,doit)
      else
        call margsu(string(ic1:lstring))
c do command
        if(modec.eq.1) then
          goto (1,2,3),icom
    1     continue
c                                      check_syntax
            ilev=ilev-1
            call chekmli(string(lcom+2:lstring),ierr)
            ilev=ilev+1
            if(ierr.ne.0) then
              ierrlv(ilev)=7
              goto 200
            endif
 
          goto 1100
    2     continue
          write(6,*) string(lcom+2:lstring)
          goto 1100
    3     continue
          ii=lcom+2
          do while(string(ii:ii).eq.' ')
            ii=ii+1
          enddo
          ii0=ii
          do while(string(ii:ii).ne.' ')
            ii=ii+1
          enddo
          ii1=ii-1
          do while(string(ii:ii).eq.' ')
            ii=ii+1
          enddo

          call setvar(string(ii0:ii1),string(ii:lstring))
          goto 1100
 1100     continue
        else if(modec.eq.2) then
          lluu=lus(ilev)
          call doit(icom,ierr)
          if(ierr.ne.0) then
            ierrlv(ilev)=8
            goto 200
          endif
        endif
c       goto 1000
      endif
      goto 1000

  200 continue
      if(lus(ilev).eq.5) then
        ierrlv(ilev)=0
        goto 1000
      else
        ierr=ierrlv(ilev)
        if(lus(ilev).ne.0.and.lus(ilev).ne.5) close(lus(ilev))
        ilev=ilev-1
        if(ilev.gt.0.and.lus(ilev).ne.5)  ierrlv(ilev)=ierr
        return
      endif
  100 continue
      if(lus(ilev).ne.0.and.lus(ilev).ne.5) close(lus(ilev))
      ilev=ilev-1
      return
      end


c--------------------------------------------
      subroutine setvar(name,value)
      character*(*) name,value
      parameter (MXVARS=40)
      character*20 varnms
      character*80 vars
      common/variab/nvars,varnms(MXVARS),vars(MXVARS)
      data nvars/0/
      ivar=0
      do i=1,nvars
        if(name.eq.varnms(i)) ivar=i
      enddo
      if(ivar.eq.0) then
        nvars=nvars+1
        if(nvars.gt.MXVARS) stop 'setvar: Too many variables'
        varnms(nvars)=name
        ivar=nvars
      endif
      vars(ivar)=value
c     write(6,'(''setvar:'',a,a)') vars(ivar),value
      return
      end

c----------------------------------------------
      subroutine getvar(name,value,lvalue)
      character*(*) name,value
      parameter (MXVARS=40)
      character*20 varnms
      character*80 vars
      common/variab/nvars,varnms(MXVARS),vars(MXVARS)
      value=' '
      ivar=0
      do i=1,nvars
        if(name.eq.varnms(i)) ivar=i
      enddo
      if(ivar.ne.0) value=vars(ivar)
      lvalue=istlen(value)
c     write(6,'(''getvar:'',a,a)') name,value
      ret