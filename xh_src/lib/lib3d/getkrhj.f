c -------------------------------------------------------------------------------------
      subroutine getkrhj(nord,iatyp,lord,amp,aker,ifgot,iskip,nker)
      save
      parameter (MAXKER=34)
      dimension amp(12),aker(*)
      common/setker/mtot,lnts,lntt,rmp(48),indsfr(330),kntsfr(330)
     1   ,indtor(300),knttor(300),nbatch,lump1,luper1,nparm
      common/getker/b(256,12),bker(256,MAXKER)

! mode parameters and kernels are retrieved for a given mode.
! Modes are indexed by mdnum which numbers them in order
! starting with 0 s 0 (mdnum=1) in the order 0s0 :
!
!  0 s 0  mdnum=  1
!   ...
! 37 s 0  mdnum= 38
!-----------------
! 0 s 1   mdnum= 39
!   ...
! 90 s 1  mdnum=129
!------------------
! 0 t 1   mdnum=130
!   ...
! 29 t 1  mdnum=159
!------------------
! 0 s  2  mdnum=160
!   ...
! 88 s 2  mdnum=248
!------------------
!  0 t 2  mdnum=249
!
!  etc
!


c     see comments below on John's original routine
c     save ibtchl
c     data ibtchl/0/

c     data itt, iss /'t   ','s   '/

c jeroen
c we are going to assume that ityp = iss (spheroidal)
      ifgot=0
c     if(iatyp.ne.iss) goto 10
      if(nord.ge.kntsfr(lord+1)) return
      mdnum=indsfr(lord+1)+nord
      goto 20

c  10 if(iatyp.ne.ctt) stop ' error 1 in getker '
c     if(nord.ge.knttor(lord)) return
c     mdnum=indtor(lord)+nord

   20 ibatch=(mdnum+255)/256
      write(6,'(''getkr: ibatch='',i5,'' iskip='',i5,'' mdnum='',i6)') ibatch,iskip,mdnum

c     in John's original routine, there is a check whether a batch has already been read.
c     it does not check, however, whether a new catalogue has been opened. Hence goto statement
c     has been hashed out and batch will always be re-read.
c     This may be slightly inefficient for repeated reads from single catalogue
c     if(ibatch.eq.ibtchl) write(6,*) 'oeioeioei' ! goto 50

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
       amp(i)=b(ind,i)
       write(6,*) 'getkrhj amp',i,amp(i)
   60 continue
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
c ------------------------------------------------------
