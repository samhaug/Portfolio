      subroutine isoinc(a,n,idx)
      integer*4 a,c,t
      dimension a(1),idx(1)
      if (n.eq.1) go to 65
      if (n.le.0) go to 60
      do 1 i = 1,n
      idx(i) = i
    1 continue
      n2 = n/2
      n21 = n2 + 2
      ict=1
      i=2
   11 n1=n21-i
      nn=n
      ik=n1
   15 c=a(ik)
      ic=idx(ik)
  100 jk=2*ik
      if (jk.gt.nn) go to 140
      if (jk.eq.nn) go to 120
       if (a(jk+1).le.a(jk)) go to 120
      jk=jk+1
  120 if (a(jk).le. c) go to 140
      a(ik)=a(jk)
      idx(ik)=idx(jk)
      ik=jk
      go to 100
  140 a(ik)=c
      idx(ik)=ic
      go to (3,45) ,ict
    3 if (i.ge.n2) go to 35
      i=i+1
      go to 11
   35 ict=2
      np2=n+2
      i=2
   37 n1=np2-i
      nn=n1
      ik=1
      go to 15
  45  continue
      t = a(1)
      a(1) = a(n1)
      a(n1) = t
      it = idx(1)
      idx(1) = idx(n1)
      idx(n1) = it
      if (i.ge.n) go to 55
      i=i+1
      go to 37
   55 return
   60 write(6,500)
  500 format('error 1 in isoinc')
      stop
   65 idx(1)=1
      return
      end
