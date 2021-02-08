c---------------------------------------------------------------------
      subroutine rddivc(lu,file,lmax,cof)
      dimension cof((lmax+1)**2)
      character*(*) file
      data r4pi/3.5449077/
      sq2=sqrt(2.)
      open(lu,file=file,status='old')
      k=0
      do l=0,lmax
      do m=0,l
        read(lu,'(2x,i2,3x,i2,1x,4e11.4)') ll,mm,div1,div2,curl1,curl2
        if(ll.ne.l.or.mm.ne.m) pause 'error 1'
        k=k+1
        cof(k)=div1*r4pi
        if(m.ne.0) then
          cof(k)=cof(k)*2.
          k=k+1
          cof(k)=-div2*r4pi*2.
        endif
      enddo
      enddo
      close(lu)
      return
      end
