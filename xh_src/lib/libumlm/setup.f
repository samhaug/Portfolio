      subroutine setup(lur,luw,luf)
      common/view/prm(40)
      dimension mnem(40)
      data mnem/'ndev','novr','so  ','dels'
     1         ,'npau','isiz','labl',33*'    '/
      data npm/7/
c jeroen
c     data cispace/'    '/,ione/'1   '/
      data cispace/'    '/

      ione = 1
      do 30 i=1,npm
   30 read(luf,1,rec=i,err=99) prm(i)
    1 format(f10.2)
      goto 100
   99 write(luw,2)
    2 format(' no parameters on file')
      do 10 i=1,npm
      write(luw,3) mnem(i)
    3 format(1x,a4)
      read(lur,4) prm(i)
    4 format(f10.2,3x,a4)
      write(luf,4,rec=i) prm(i),mnem(i)
   10 continue
c
  100 continue
      write(luw,14) (mnem(i),prm(i),i=1,npm)
   14 format(4(1x,a4,1x,f8.2,2x))
      write(luw,7)
    7 format(' change parameters?')
      read(lur,12) ifch,xparm
      if(ifch.ne.cispace) goto 120
      goto 150
c
  120 if(ifch.eq.ione) goto 121
      ialph=ifch
      goto 122
  121 read(lur,12) ialph,xparm
   12 format(a4,f10.2)
      if(ialph.eq.cispace) goto 100
  122 do 130 i=1,npm
      k=i
      if(ialph.eq.mnem(k)) goto 140
  130 continue
      write(luw,9)
    9 format(' not recognized')
      goto 121
c
  140 prm(k)=xparm
      write(luf,4,rec=k) prm(k),mnem(k)
      goto 121
c
  150 return
      end
