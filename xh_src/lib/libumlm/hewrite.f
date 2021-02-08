      subroutine hewrite(lu,file,x,nstr,lmax,mask,lask,inorm)
      dimension x(*),mask(*),lask(*)
      character*(*) file
      character*132 abuf
      character*80 form
      open(lu,file=file)

      sqth=sqrt(.5)
      leny=0
      do 60 l=0,lmax
      if(lask(l+1).ne.0) leny=leny+2*l+1
   60 continue

      write(form,'(''(10x,i5,1x,'',i3,''i1,1x,i3,1x,80i1)'')') lmax+1
      write(lu,form) lmax,(lask(i+1),i=0,lmax),nstr,(mask(i),i=1,nstr)

      ik=0
      do 20 ip=1,nstr
      do 704 l=0,lmax
      if(lask(l+1).ne.0.and.mask(ip).ne.0) then
        ik=1+ik
        ik1=ik+2*l
        if(inorm.eq.1) x(ik)=x(ik)*sqth
        write(lu,'(1p11e12.4)')(x(i),i=ik,ik1)
        ik=ik1
      endif
  704 continue
   20 continue
      lenf=0
      do 22 i=1,len(file)
      ii=i
      if(file(i:i).eq.' '.or.file(i:i).eq.char(0)) goto 23
   22 continue
   23 ii=ii-1
      write(6,'(''model to  '',1x,80a1)') (file(i:i),i=1,ii)
      write(6,'(i4,'' parameters:  mask '',80i1)') nstr,(mask(i),i=1,nstr)
      write(6,'(4x,'' lmax ='',i4,'':  mask '',80i1)') lmax,(lask(i+1),i=0,lmax)
      close(lu)
      return
      end
