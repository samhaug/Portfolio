c-----------------------------------------------------------------
      subroutine opnseeddb(dbfile,iflap,ierr)
      character*(*) dbfile
      include 'seeddefs.h'
      include 'seedtrees.h'

      data inetopen/0/,stnopen/' '/,chnopen/' '/,itstn/-1/,itchn/-1/


      include '../libdb/dblib.h'
      character*80 exname
      character*200 dbfilei
      dbfilei=dbfile
c     write(6,'(''opnseeddb 1'')')
      call dbexit()
c     write(6,'(''opnseeddb 2'')')
      ldb=istlen(dbfile)
      ierr=0
      itstn=-1
      itchn=-1

      nstak=1
      maxlev=3
      mord=21
      lkey=5
      linfo=0
      ityp=2
      exname='*'
c     write(6,'(''opnseeddb 3'')')
      call tropnn(-1,dbfilei(1:ldb)//'.stn',STUNK,iflap,ierr
     1  ,nstak,maxlev,itrtstn
     1  ,mord,lkey,linfo,ityp,exname)
c     write(6,'(''opnseeddb 4'')')
      if(ierr.ne.0) return
c     write(6,'(''opnseeddb 5'')')

      nstak=1
      maxlev=3
      mord=5
      lkey=5
      linfo=0
      ityp=2
      exname='*'
      call tropnn(-1,dbfilei(1:ldb)//'.blk',STUNK,iflap,ierr
     1  ,nstak,maxlev,itrtblk
     1  ,mord,lkey,linfo,ityp,exname)
      if(ierr.ne.0) return


      nstak=4
      maxlev=5
      mord=51
      lkey=2
      linfo=0
      ityp=2
      exname='*'
      call tropnn(-1,dbfilei(1:ldb)//'.tsr',STUNK,iflap,ierr
     1  ,nstak,maxlev,itrttsr
     1  ,mord,lkey,linfo,ityp,exname)

      if(ierr.ne.0) then
        write(6,*) 'opnseeddb: cannot open .tsr file'
        return
      endif




      do i=1,numdicts
        if(ldictnams(i).ne.0) then
          nstak=1
          maxlev=5
          mord=11
          exname='*'
c          write(6,*) 'Opening:',dictnams(i)(1:ldictnams(i))
c     write(6,'(''opnseeddb 6'')')
          call opnabr(
     1      itrtstn,dictnams(i)(1:ldictnams(i)),STUNK,iflap,ierr
     1      ,nstak,maxlev,itabr(i),itabrh(i),lsabr(i)
     1      ,mord,exname)
c     write(6,'(''opnseeddb 7'')')
          if(ierr.ne.0) return
c     write(6,'(''opnseeddb 8'')')
        endif
      enddo

      nstak=5
      maxlev=11
      mord=51
      exname='*'
c      write(6,*) 'Opening:','station_blockettes'
      call opnabr(
     1      itrtblk,'station_blockettes',STUNK,iflap,ierr
     1      ,nstak,maxlev,itsblock,itsblockh,lssblock
     1      ,mord,exname)
          if(ierr.ne.0) return

      nstak=7
      maxlev=11
      mord=51
      exname='*'
c      write(6,*) 'Opening:','response_abbrevs'
      call opnabr(
     1      itrtblk,'response_abbrevs',STUNK,iflap,ierr
     1      ,nstak,maxlev,itresp,itresph,lsresp
     1      ,mord,exname)
      if(ierr.ne.0) return



      nstak=5
      maxlev=5
      mord=71
      lkey=2
      linfo=0
c      ityp=3
      ityp=2
      exname='*'
      call tropnn(itrtstn,'stations',STUNK,iflap,ierr
     1  ,nstak,maxlev,itstns
     1  ,mord,lkey,linfo,ityp,exname)
      if(ierr.ne.0) then
        write(6,*) 'opnseeddb: cannot open stations'
        return
      endif

      nstak=1
      maxlev=3
      mord=5
      lkey=5
      linfo=0
      ityp=2
      exname='*'
      call tropnn(-1,dbfilei(1:ldb)//'.vlm',STUNK,iflap,ierr
     1  ,nstak,maxlev,itrtvlm
     1  ,mord,lkey,linfo,ityp,exname)
      if(ierr.ne.0) then
        write(6,*) 'unable to open .vlm'
        return
      endif

      nstak=7
      maxlev=11
      mord=51
      exname='*'
      call opnabr(
     1      itrtvlm,'volume_abbrevs',STUNK,iflap,ierr
     1      ,nstak,maxlev,itvlabr,itvlabrh,lsvlabr
     1      ,mord,exname)

      if(ierr.ne.0) then
        write(6,*) 'unable to open volume_abbrevs'
        return
      endif

      nstak=7
      maxlev=11
      mord=51
      exname='*'
      call opnabr(
     1      itrtvlm,'blfile_abbrevs',STUNK,iflap,ierr
     1      ,nstak,maxlev,itblabr,itblabrh,lsblabr
     1      ,mord,exname)

      if(ierr.ne.0) then
        write(6,*) 'unable to open volume_abbrevs'
        return
      endif

      nstak=5
      maxlev=5
      mord=71
      lkey=1
      linfo=1
      ityp=0
      exname='*'
      call tropnn(itrtvlm,'vl_to_bl',STUNK,iflap,ierr
     1  ,nstak,maxlev,itvlbl
     1  ,mord,lkey,linfo,ityp,exname)
      if(ierr.ne.0) then
        write(6,*) 'opnseeddb: cannot open vl_to_bl'
        return
      endif



    
      return
      end
