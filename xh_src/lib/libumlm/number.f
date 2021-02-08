      subroutine number(x,y,isize,var,rotdeg,iform)
      character*80 iform,ichar
      character*1 n2
      character*2 n1,n3
c     integer*2 iform(5),ichar(10)
      if(iform(1:2).eq.'(i') write(ichar,iform) int(var)
      if(iform(1:2).ne.'(i') write(ichar,iform) var
      if(iform(1:2).ne.'(1')read(iform,10) n1,nc,n2,n3,n4
      if(iform(1:2).eq.'(1')read(iform,11) n1,nc,n2,n3,n4
      if(n2.eq.')'.or.n2.eq.'.')goto 20
      if(iform(1:2).ne.'(1')read(iform,15) n1,nc,n2,n3
      if(iform(1:2).eq.'(1')read(iform,16) n1,nc,n2,n3
10    format(a2,i1,a1,a2,a4)
11    format(a4,i1,a1,a2,a2)
15    format(a2,i2,a2,a4)
16    format(a4,i2,a2,a2)
20    call symbl1(x,y,isize,ichar,rotdeg,nc)
      return
      end
