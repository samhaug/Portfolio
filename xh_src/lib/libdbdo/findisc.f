      subroutine findisc(string,ttol,dtol,ifound,ierr)
      character*(*) string
      dimension itimev(2),itc1(2),itc2(2),itim(2),ibuf(11)
      integer*2 jbuf(22)
      equivalence (ibuf,jbuf)
      character*80 iscstr,iscstrm,stringc
      double precision dttol
      dttol=ttol

      ierr=0

      lstring=istlen(string)
      ip=1
      do while(string(ip:ip).ne.'@'.and.ip.lt.lstring)
        ip=ip+1
      enddo
      call inttime(stringc(1:ip-1)//'~',itimev(1))

      ip=ip+1
      ip1=ip
      do while(string(ip1:ip1).ne.','.and.ip1.le.lstring)
        ip1=ip1+1
      enddo
      read(string(ip:ip1-1),*) xlatev
      ip=ip1+1
      ip1=ip
      do while(string(ip1:ip1).ne.','.and.ip1.le.lstring)
        ip1=ip1+1
      enddo
      read(string(ip:ip1-1),*) xlonev
      ip=ip1+1
      ip1=ip
      do while(string(ip1:ip1).ne.','.and.ip1.le.lstring)
        ip1=ip1+1
      enddo
      read(string(ip:ip1-1),*) xdepev
      if(ip1.le.lstring) then
        ip=ip1+1
        ip1=ip
        do while(string(ip1:ip1).ne.','.and.ip1.le.lstring)
          ip1=ip1+1
        enddo
        read(string(ip:ip1-1),*) xmagev
      else
        xmagev=0.
      endif

      call itimadd(itimev,itc1,-dttol)
      call itimadd(itimev,itc2,dttol)

      lu=-1
      call openfl(lu,'/home/eeyore1/john/dta/bheader.bin',1,0,0,istat,44)
      call ffstat(lu,lent,iftyp,isize)
      num=isize/44
      ir=1
      ifeq=0
      ient=1
      ilb=0
      iub=num+1
  100 call bffi(lu,1,ibuf,44,j,m,ient)
      jyear=jbuf(1)
      month=jbuf(2)
      iday=jbuf(3)
      ih=jbuf(4)
      min=jbuf(5)
      fsec=.1*jbuf(6)
      call datjul(month,iday,jyear,jday)
      call timsec(jyear,jday,ih,min,fsec,itim(1))
      it=10000*amod(fs,1.0)
      itim(2)=ishft(it,16)

      if(itcmp(itc1,itim).lt.0) then
        iub=ient
        goto 400
      else if(itcmp(itc1,itim).eq.0) then
        ifeq=1
        iub=ient
        goto 500
      else
        ilb=ient
        goto 400
      endif
  400 continue
      if(iub-ilb.eq.1) goto 500
      if(ient.eq.1) then
        ient=num
        goto 100
      endif
      ient=(iub+ilb)/2
      goto 100
  500 continue
      if(ifeq.eq.1) ilb=max0(1,iub-1)
      ir=ilb+1
      ifound=0
  223 call bffi(lu,1,ibuf,44,j,m,ir)
      if(j.eq.2) then
        jyear=jbuf(1)
        month=jbuf(2)
        iday=jbuf(3)
        ih=jbuf(4)
        min=jbuf(5)
        fsec=.1*jbuf(6)
        eplat=.01*jbuf(8)
        eplong=.01*jbuf(10)
        depth=.1*jbuf(12)
        nrep=jbuf(15)
        xmb=.1*jbuf(16)

        call datjul(month,iday,jyear,jday)
        call timsec(jyear,jday,ih,min,fsec,itim)
        it=10000*amod(fs,1.0)
        itim(2)=ishft(it,16)
        if(itcmp(itim,itc2).lt.0) then
          call delaz(eplat,eplong,xlatev,xlonev,delta,azep,azst)
          if(delta.le.dtol) then
            ifound=ifound+1
            nrepm=-1
            io=0
            call puttim(iscstr,io,jyear,jday,ih,min,fsec)
            write(iscstr(io:80),'(''@'',1x,f5.2,'','',1x,f6.2,'','',f5.1)')
     1         abs(eplat),abs(eplong),depth
            if(eplat.lt.0.) then
              iscstr(io+1:io+1)='-'
            else
              iscstr(io+1:io+1)='+'
            endif
            if(eplong.lt.0.) then
              iscstr(io+8:io+8)='-'
            else
              iscstr(io+8:io+8)='+'
            endif
            liscstr=istlen(iscstr)
            do i=1,liscstr
              if(iscstr(i:i).eq.' ') iscstr(i:i)='0'
            enddo
            write(6,'(7x,a,'' mb='',f3.1,i6,'' reporting'')') iscstr(1:liscstr),xmb,nrep
            if(nrep.gt.nrepm) then
              nrepm=nrep
              iscstrm=iscstr
              liscstrm=liscstr
            endif
          endif
          ir=ir+1
          goto 223
        endif
      endif
      if(nrepm.ge.0) call setvar('event',iscstrm(1:liscstrm))
      call closfl(lu,kk)
      lu=-1
      return
      end


     
