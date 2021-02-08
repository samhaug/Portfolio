cprog stloca
      subroutine stloca(name,id,stla,stlo)
      common/stdata/ nsta,index(60),istnam(60),stlat(60),stlong(60),
     1elev(60)
      common/idasta/ nida,idaind(30),idanam(30),slaida(30),
     1sloida(30),elvida(30)
c
      do 20 ista=1,nsta
      ist=ista
      if(istnam(ist).eq.name) goto 30
   20 continue
      goto 10
   30 stla=stlat(ist)
      stlo=stlong(ist)
      id=index(ist)
      return
   10 do 40 ista=1,nida
      ist=ista
      if(idanam(ist).eq.name) goto 50
   40 continue
      pause ' station not found'
   50 stla=slaida(ist)
      stlo=sloida(ist)
      id=idaind(ist)
      return
      end
