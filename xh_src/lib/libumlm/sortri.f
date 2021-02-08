c---------------------------------------------------------------------
      subroutine sortri(alph,ind,n,idx)
      dimension alph(1),idx(1),ind(1)
      if(n.eq.1) goto 65
      if(n.eq.0) return
      if(n.lt.0) goto 60
      do 1 i=1,n
      idx(i)=i
    1 continue
      n2=n/2
      n21=n2+2
      ict=1
      i=2
   11 n1=n21-i
      nn=n
      ik=n1
   15 awk=alph(ik)
      iwk=ind(ik)
      ic=idx(ik)
  100 jk=2*ik
      if(jk.gt.nn) goto 140
      if(jk.eq.nn) goto 113
      if(alph(jk+1).lt.alph(jk)) goto 113
      if(alph(jk+1).gt.alph(jk)) goto 94
      if(ind(jk+1).lt.ind(jk)) goto 113
      if(ind(jk+1).gt.ind(jk)) goto 94
      goto 113
   94 continue
  110 jk=jk+1
  113 if(alph(jk).lt.awk) goto 140
      if(alph(jk).gt.awk) goto 99
      if(ind(jk).lt.iwk) goto 140
      if(ind(jk).gt.iwk) goto 99
      goto 140
   99 continue
  130 alph(ik)=alph(jk)
      ind(ik)=ind(jk)
      idx(ik)=idx(jk)
      ik=jk
      goto 100
  140 alph(ik)=awk
      ind(ik)=iwk
      idx(ik)=ic
      goto (3,45),ict
    3 if(i.ge.n2) goto 35
      i=i+1
      goto 11
   35 ict=2
      np2=n+2
      i=2
   37 n1=np2-i
      nn=n1
      ik=1
      goto 15
   45 continue
      at9=alph(1)
      alph(1)=alph(n1)
      alph(n1)=at9
      it9=ind(1)
      ind(1)=ind(n1)
      ind(n1)=it9
      it=idx(1)
      idx(1)=idx(n1)
    4 idx(n1)=it
      if(i.ge.n) goto 55
      i=i+1
      goto 37
   55 return
   60 pause 'error 1 in sortri'
   65 idx(1)=1
      return
      end
