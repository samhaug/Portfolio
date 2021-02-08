      subroutine setupa(file,lur,luw,luf,mnem,prm,ifa)
      character*4 alph
      character*(*) file
      dimension mnem(1),prm(1)
      data ispace/'    '/,ione/'1   '/
      npm=mnem(1)
      close(luf,iostat=ierr)
      open(luf,file=file,access='direct',recl=80,status='unknown'
     1   ,form='formatted')
      inc=0
      do 35 i=1,npm
   35 prm(i)=0.
      ip=0
      do 30 i=1,npm
      ir=i
      read(luf,1,rec=i,err=99) ptes,ites
    1 format(f10.2,3x,a4)
      do 33 ii=1,npm
      ip=1+mod(ip,npm)
      if(ites.eq.mnem(ip+1)) then
        if(ip.ne.i) inc=1
        prm(ip)=ptes
        goto 30
      endif
   33 continue
   30 continue
      if(inc.eq.0) goto 100

   99 write(luw,2)
    2 format('parameter file not current')
      do 36 i=1,npm
   36 write(luf,1,rec=i) prm(i),mnem(i+1)
    4 format(f10.2,3x,a4)
  100 continue
      if(ifa.ne.0) return
      write(luw,14) (mnem(i+1),prm(i),i=1,npm)
   14 format(4(1x,a4,1x,f8.2,2x))
      write(luw,7)
    7 format(' change parameters?')
      read(lur,12) alph,xparm
c     call upper(alph)
      read(alph,'(a4)') ifch
      if(ifch.ne.ispace) goto 120
      goto 150
c
  120 if(ifch.eq.ione) goto 121
      ialph=ifch
      goto 122
  121 read(lur,12) alph,xparm
c      call upper(alph)
      read(alph,'(a4)') ialph
   12 format(a4,f10.2)
      if(ialph.eq.ispace) goto 100
  122 do 130 i=1,npm
      k=i
      if(ialph.eq.mnem(k+1)) goto 140
  130 continue
      write(luw,9)
    9 format(' not recognized')
      goto 121
c
  140 prm(k)=xparm
      write(luf,4,rec=k) prm(k),mnem(k+1)
      goto 121
c
  150 close(luf)
      return
      end
