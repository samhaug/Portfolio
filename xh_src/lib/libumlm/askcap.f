      subroutine askcap(isiz,i1,i2,j1,j2)
      character*1 head(72,3)
      character*72 hh(3)
      equivalence (head,hh)
      dimension lenh(3)
      call wrtsiz(isiz,icw,ich)
      write(6,51)
   51 format(' type caption'/
     1'*****************************************************************
     2*******')
      lines=0
      do 222 k=1,3
      read(5,52) (head(i,k),i=1,72)
   52 format(72a1)
      llen=73
   55 llen=llen-1
      if(llen.eq.0) goto 56
      if(head(llen,k).eq.' ') goto 55
      lenh(k)=llen
      lines=k
  222 continue
c
   56 if(lines.eq.0) return
      do 223 k=1,lines
      iup=(5*(lines-k)*ich)/4
      call movabs((i1+i2-lenh(k)*icw)/2,j2+iup+(2*ich)/3)
      ichar=lenh(k)
c     call anmode
c     write(11,57)(head(i,k),i=1,ichar)
c  57 format(72a1,$)
      call wrch(hh(k))
  223 continue
      return
      end
