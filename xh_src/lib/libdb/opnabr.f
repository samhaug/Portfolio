c-----------------------------------------------------------------
      subroutine opnabr(itin,name,istat,iflap,ierr
     1    ,nstak,maxlev,itrabr,itrhash,lastuid
     1    ,mord,exname)
      include 'dblib.h'
      character*(*) name,exname
      logical trfind,trnext
      character*32 extemp
      integer*4 bigid/z'7fffffff'/
      character*200 namei
      namei=name
      lname=istlen(name)
      lkey=1
      linfo=1
      ityp=1
      extemp=exname
c     write(6,'(''opnabr 1'')')
      call tropnn(itin,name(1:lname),istat,iflap,ierr
     1  ,nstak,maxlev,itrabr
     1  ,mord,lkey,linfo,ityp,extemp)
c     write(6,'(''opnabr 2'')')
      if(ierr.ne.0) pause 'opnabr: open error for abbreviations'
      lkey=2
      linfo=0
      ityp=0
      extemp=exname
c     write(6,'(''opnabr 3'')')
      call tropnn(itin,namei(1:lname)//'.h',istat,iflap,ierr
     1  ,nstak,maxlev,itrhash
     1  ,mord,lkey,linfo,ityp,extemp)
c     write(6,'(''opnabr 4'')')
      if(ierr.ne.0) pause 'opnabr: open error for hash table'
      if(trfind(itrabr,bigid,1,iok,ioi)) pause 'opnabr: bigid found'
      if(trnext(itrabr,-1,iok,ioi)) then
        lastuid=ibig(iok)
      else
        lastuid=0
      endif
      return
      end
