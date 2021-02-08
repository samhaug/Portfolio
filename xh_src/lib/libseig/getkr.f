c----------------------------------------------------------------------
      subroutine getkr(nord,iatyp,lord,amp,aker,ifgot,iskip,nker)
      save
      parameter (MAXKER=28)
      dimension amp(12),aker(*)
      common/setker/mtot,lnts,lntt,rmp(48),indsfr(330),kntsfr(330)
     1   ,indtor(300),knttor(300),nbatch,lump1,luper1,nparm
      common/getker/b(256,12),bker(256,MAXKER)


      save ibtchl
      data ibtchl/0/
c-- jeroen comment
c     data itt,iss/'t   ','s   '/

      ifgot=0
c-- jeroen comment
c     if(iatyp.ne.iss) goto 10
      if(nord.ge.kntsfr(lord+1)) return
      mdnum=indsfr(lord+1)+nord
      goto 20

c-- jeroen comment
c  10 if(iatyp.ne.itt) pause ' error 1 in getker '
      if(nord.ge.knttor(lord)) return
      mdnum=indtor(lord)+nord

   20 ibatch=(mdnum+255)/256
      if(ibatch.eq.ibtchl) goto 50

      ibtchl=ibatch
      do ivar=1,3
        irecmp=3+nbatch*(ivar-1)+ibatch
        call bffi(lump1,1,b(1,4*(ivar-1)+1),4*256*4,j,m,irecmp)
        call byswap4(b(1,4*(ivar-1)+1),4*256)
      enddo
      write(6,'(''getkr: reading'',2i5)') ibatch+iskip,iskip
      if(luper1.gt.0) then
        call bffi(luper1,1,bker,nparm*256*4,j,m,ibatch+iskip)
        call byswap4(bker,nparm*256)
      endif

   50 ind=mdnum-256*(ibatch-1)
      do 60 i=1,12
   60 amp(i)=b(ind,i)
      if(luper1.gt.0) then
        do 70 i=1,nparm
   70   aker(i)=bker(ind,i)
        nker=nparm
      else
        nker=0
      endif
      ifgot=1
      return
      end
