      subroutine getker(nord,iatyp,lord,amp,aker,ifgot)
      dimension amp(12),aker(10)
      common/setkr/mtot,lnts,lntt,rmp(48),indsfr(330),kntsfr(330)
     1   ,indtor(300),knttor(300),nbatch,lump1,luper1
      common/getkr/b(256,12),bker(256,10)


      save ibtchl
      data ibtchl/0/
c jeroen comment
c     data itt,iss/'t   ','s   '/

      ifgot=0
c     if(iatyp.ne.iss) goto 10
      if(nord.ge.kntsfr(lord+1)) return
      mdnum=indsfr(lord+1)+nord
      goto 20

c  10 if(iatyp.ne.itt) pause ' error 1 in getker '
      if(nord.ge.knttor(lord)) return
      mdnum=indtor(lord)+nord

   20 ibatch=(mdnum+255)/256
      if(ibatch.eq.ibtchl) goto 50

      ibtchl=ibatch
      do 30 ivar=1,3
      irecmp=3+nbatch*(ivar-1)+ibatch
   30 call bffi(lump1,1,b(1,4*(ivar-1)+1),4*256*4,j,m,irecmp)
      call bffi(luper1,1,bker,10*256*4,j,m,ibatch)

   50 ind=mdnum-256*(ibatch-1)
      do 60 i=1,12
   60 amp(i)=b(ind,i)
      do 70 i=1,10
   70 aker(i)=bker(ind,i)
      ifgot=1
      return
      end
