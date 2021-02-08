c---------------------------------------------------------
      subroutine openstnk(cstnkey,iflap)
      character*8 cstnkey
      include 'seeddefs.h'
      include 'seedtrees.h'
      include '../libdb/dblib.h'

      character*5 station
      integer*4 key(2)
      character*8 ckey
      equivalence (key,ckey)
      character*80 exname,str80
      logical getabr

      ckey=cstnkey
      call byswap4(key(2),1)
      netukey=and(z'00ffffff',key(2))
      call byswap4(key(2),1)
      station=ckey(1:5)
      if(station.eq.stnopen.and.netukey.eq.inetopen) return
      call closestn()

      nstak=3
      maxlev=3
      mord=31
      lkey=3
      linfo=1
      ityp=2
      exname='*'

      call tropnn(itstns,cstnkey,STUNK,iflap,ierr
     1    ,nstak,maxlev,itstn
     1    ,mord,lkey,linfo,ityp,exname)


      nstak=3
      maxlev=3
      mord=31
      lkey=4
      linfo=1
      ityp=2
      exname='*'

      call tropnn(itrttsr,cstnkey,STUNK,iflap,ierr
     1    ,nstak,maxlev,itsttsr
     1    ,mord,lkey,linfo,ityp,exname)



c     nstak=3
c     maxlev=3
      nstak=5
      maxlev=6
      mord=11
      lkey=4
      linfo=0
c      ityp=3
      ityp=2
      exname='*'
      call tropnn(itstn,'channels',STUNK,iflap,ierr
     1    ,nstak,maxlev,itchns
     1    ,mord,lkey,linfo,ityp,exname)

      nstak=3
      maxlev=7
      mord=21
      linfo=2
      msstccl=10 00000
      call opncldr(itstn,'comments',STUNK,iflap,ierr
     1   ,nstak,maxlev,itstccl,msstccl,mtstccl
     1   ,mord,linfo)

      nstak=3
      maxlev=7
      mord=21
      linfo=1
      mssticl=300 00000
      call opncldr(itstn,'info',STUNK,iflap,ierr
     1   ,nstak,maxlev,itsticl,mssticl,mtsticl
     1   ,mord,linfo)

      inetopen=netukey
      stnopen=station


      if(.not.getabr(itabr(DICTGC),inetopen,str80,lstr80))
     1         pause 'openstn: network abbreviation not found'
      netopen='['//str80(11:lstr80-1)//']'
      lnetopen=lstr80-9

      return
      end
