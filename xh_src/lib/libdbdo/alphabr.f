      subroutine alphabr(ialph,id1,n,ncost1,ncost2,ncolsm,idx,iwk)
      dimension ialph(id1,*),iwk(*),idx(*)
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
   15 do 91 i9=1,ncolsm
   91 iwk(i9)=ialph(i9,ik)
      ic=idx(ik)
  100 jk=2*ik
      if(jk.gt.nn) goto 140
      if(jk.eq.nn) goto 113
      do 93 i9=ncost1,ncost2
      if(ialph(i9,jk+1).lt.ialph(i9,jk)) goto 113
      if(ialph(i9,jk+1).gt.ialph(i9,jk)) goto 94
   93 continue
      goto 113
   94 continue
  110 jk=jk+1
  113 do 98 i9=ncost1,ncost2
      if(ialph(i9,jk).lt.iwk(i9)) goto 140
      if(ialph(i9,jk).gt.iwk(i9)) goto 99
   98 continue
      goto 140
   99 continue
  130 do 191 i9=1,ncolsm
  191 ialph(i9,ik)=ialph(i9,jk)
      idx(ik)=idx(jk)
      ik=jk
      goto 100
  140 do 192 i9=1,ncolsm
  192 ialph(i9,ik)=iwk(i9)
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
      do 291 i9=1,ncolsm
      it9=ialph(i9,1)
      ialph(i9,1)=ialph(i9,n1)
      ialph(i9,n1)=it9
  291 continue
      it=idx(1)
      idx(1)=idx(n1)
    4 idx(n1)=it
      if(i.ge.n) goto 55
      i=i+1
      goto 37
   55 return
   60 pause 'error 1 in alphab'
   65 idx(1)=1
      return
      end
