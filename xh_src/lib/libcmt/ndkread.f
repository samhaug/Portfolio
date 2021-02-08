c ---------------------------------------------------------------------------------

      subroutine ndkread(iu,irec,ifend)

      include '../include/ndk.h'

      character*81 cbuf(5)
      character*1 typ(3)
      dimension nstyp(3),nctyp(3),ictyp(3)

      call bffi(iu,1,cbuf,5*81,istat,nread,irec)
 
      if(istat.ne.2) then
        ifend=1
        return
      else
        ifend=0
      endif

      read(cbuf(1),'(a4,1x,
     1  i4,1x,i2,1x,i2,1x,
     1  i2,1x,i2,1x,f4.1,1x,
     1  f6.2,1x,f7.2,1x,f5.1,1x
     1  f3.1,1x,f3.1,1x,
     1  a24
     1     )') isour,
     1    lyear,month,iday,
     1    ih,imin,fsec,
     1    eplat,eplon,depth,
     1    xmb,xms,
     1    region

      read(cbuf(2),'(a16,3(1x,a1,1x,i3,i5,i4),1x,
     1    a6,1x,a6,f5.1   
     1    )') event,
     1        (typ(i),nstyp(i),nctyp(i),ictyp(i),i=1,3),
     1        typinv,typstf,durt

      read(cbuf(3),'(9x,f9.1,f4.1,f7.2,f5.2,f8.2,f5.2,f6.1,f5.1,1x,a4,1x,a16)') 
     1   torg,errt,epa,erra,epo,erro,xd,errd,typdep,tstamp

      read(cbuf(4),'(i2,6(f7.3,f6.3))')
     1     iexp,(xm(i),xerr(i),i=1,6)


      read(cbuf(5),'(a3,3(f8.3,i3,i4),f8.3,2(i4,i3,i5))')
     1  version,(ev(i),ipl(i),iaz(i),i=1,3),sc,(istr(i),idip(i),islp(i),i=1,2)

      levent=istlen(event)
      if(lyear.lt.2005.and.levent.ne.8) stop 'unexpected event name format pre 2005'
      if(lyear.ge.2005.and.levent.ne.14) stop 'unexpected event name format post 2005'
      if(typ(1).ne.'B'.or.typ(2).ne.'S'.or.typ(3).ne.'M') then
        write(0,'(a)') cbuf(2)
        write(0,'(3a1)') typ
        stop 'unexpected data type'
      endif

      isb=nstyp(1)
      icb=nctyp(1)
      icutb=ictyp(1)

      iss=nstyp(2)
      ics=nctyp(2)
      icuts=ictyp(2)

      ism=nstyp(3)
      icm=nctyp(3)
      icutm=ictyp(3)

      end

