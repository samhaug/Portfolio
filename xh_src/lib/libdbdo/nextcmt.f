      subroutine nextcmt(ifep,xlami,xlama,xlomi,xloma
     1                  ,ifdp,xdpmi,xdpma
     1                  ,ifm0,xm0mi,xm0ma
     1                  ,ifmw,xmwmi,xmwma
     1                  ,ifmb,xmbmi,xmbma
     1                  ,ifms,xmsmi,xmsma
     1                  ,ifin,tcmt1,tcmt2
     1                  ,ifinit
     1                  ,string,lstring,cmnam,lcmnam,ifdone
     1                  ,ifcen,ierr)
      character*(*) tcmt1,tcmt2,string,cmnam
      character*8 event
      common/cmtbin/ idum,event,isour,
     1  lyear,month,iday,ih,min,fsec,eplat,
     1eplong,depth,xmb,xms,ireg(6),isb,icb,icutb,ism,icm,icutm,
     2torg,jh,jmin,xsec,errt,epa,xlat,ins,erra,epo,xlon,iew,erro,xd,
     3errd,durt,iexp,xm(6),xerr(6),ev(3),
     4ipl(3),iaz(3),sc,istr(2),idip(2),
     5islp(2),idumm

      common/mxcmt/lunxcm,num,ircmt
      data lunxcm/-1/
      dimension itc1(2),itc2(2),itim(2)
      character*80 temp
      include 'catbuf.h'


      call strcache(tcmt1g,k1tcmt1,k2tcmt1)
      call strcache(tcmt2g,k1tcmt2,k2tcmt2)


      ierr=0

      if(ifin.gt.0) then
        call inttime(ctbf(k1tcmt1:k2tcmt1)//'~',itc1)
        call inttime(ctbf(k1tcmt2:k2tcmt2)//'~',itc2)
      endif

      if(ifinit.ne.0.or.lunxcm.lt.0) then
        lunxcm=-1
        call openfl(lunxcm,'/home/eeyore1/john/dta/allorder.bin',1,0,0,istat,292)
        call ffstat(lunxcm,lent,iftyp,isize)
        num=isize/292
        ircmt=1
        if(ifin.gt.0) then
          ifeq=0
          ient=1
          ilb=0
          iub=num+1
  100     call bffi(lunxcm,1,idum,40,j,m,ient)
          jyear=1900+mod(lyear,1900)
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
  400     continue
          if(iub-ilb.eq.1) goto 500
          if(ient.eq.1) then
            ient=num
            goto 100
          endif
          ient=(iub+ilb)/2
          goto 100
  500     continue
          if(ifeq.eq.1) ilb=max0(1,iub-1)
          ircmt=ilb+1
        endif
      endif
  222 continue
      call bffi(lunxcm,1,idum,292,j,m,ircmt)
      if(j.ne.2) goto 223
      ircmt=ircmt+1
      jyear=1900+mod(lyear,1900)
      call datjul(month,iday,jyear,jday)
      call timsec(jyear,jday,ih,min,fsec,itim(1))
      it=10000*amod(fs,1.0)
      itim(2)=ishft(it,16)
      xm0=sc*10.**(iexp-26)
      xmw=.667*alog10(xm0*1.e+26)-10.73


      if(ifin.gt.0.and.itcmp(itim,itc2).gt.0) goto 223

      if(ifep.gt.0) then
        if(eplat.lt.xlami.or.eplat.gt.xlama) goto 222
        t1=amod(eplong-xlomi+720.,360.)
        t2=amod(xloma-xlomi+720.,360.)
        if(t2.lt..01) t2=360.
        if(t1.gt.t2) goto 222
      endif
      if(ifdp.gt.0.and.(xd.lt.xdpmi.or.xd.gt.xdpma)) goto 222
      if(ifm0.gt.0.and.(xm0.lt.xm0mi.or.xm0.gt.xm0ma)) goto 222
      if(ifmw.gt.0.and.(xmw.lt.xmwmi.or.xmw.gt.xmwma)) goto 222
      if(ifmw.gt.0.and.(xmw.lt.xmwmi.or.xmw.gt.xmwma)) goto 222
      if(ifmb.gt.0.and.(xmb.lt.xmbmi.or.xmb.gt.xmbma)) goto 222
      if(ifms.gt.0.and.(xms.lt.xmsmi.or.xms.gt.xmsma)) goto 222

        cmnam=event(2:8)
        lcmnam=7
        jyear=1900+mod(lyear,1900)
        call datjul(month,iday,jyear,jday)
        io=0
        if(ifcen.le.0) then
          call puttim(string,io,jyear,jday,ih,min,fsec)   ! pde time
          write(string(io:80),'(''@'',1x,f5.2,'','',1x,f6.2,'','',f5.1)')
     1       abs(eplat),abs(eplong),depth                 ! pde lat lon dep
          if(eplat.lt.0.) then
            string(io+1:io+1)='-'
          else
            string(io+1:io+1)='+'
          endif
          if(eplong.lt.0.) then
            string(io+8:io+8)='-'
          else
            string(io+8:io+8)='+'
          endif
        else
          call puttim(string,io,jyear,jday,jh,jmin,xsec) ! centroid time
          write(string(io:80),'(''@'',1x,f5.2,'','',1x,f6.2,'','',f5.1)')
     1       abs(epa),abs(epo),xd                      ! centroid lat lon dep
          if(epa.lt.0.) then
            string(io+1:io+1)='-'
          else
            string(io+1:io+1)='+'
          endif
          if(epo.lt.0.) then
            string(io+8:io+8)='-'
          else
            string(io+8:io+8)='+'
          endif
        endif
        lstring=istlen(string)
        do i=1,lstring
          if(string(i:i).eq.' ') string(i:i)='0'
        enddo
        lstring=istlen(string)
        call setvar('cmtname',cmnam(1:lcmnam))
        call setvar('evtname',cmnam(5:6)//cmnam(1:4)//cmnam(7:7))
        call setvar('eventtime',string(1:21))
        call setvar('event',string(1:lstring))
        write(temp,'(f3.1)') xmw
        call setvar('mw',temp(1:3))
        write(temp,'(f3.1)') xmb
        call setvar('mb',temp(1:3))
        write(temp,'(f3.1)') xms
        call setvar('ms',temp(1:3))
        goto 255

  223 ifdone=1
      lstring=0
      call closfl(lunxcm,kk)
      lunxcm=-1
  255 continue

      call struncache(tcmt2g,k1tcmt2,k2tcmt2)
      call struncache(tcmt1g,k1tcmt1,k2tcmt1)

      return
      end
