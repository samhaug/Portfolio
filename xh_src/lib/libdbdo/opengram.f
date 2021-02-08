c----------------------------------------------------------
      integer function opengram(gram,ifstat,iflap,ierr)
      character*(*) gram
      include 'gramdb.h'
      include '../libdb/dblib.h'
      character*80 exname
      call closestn()
      nstak=1
      maxlev=3
      mord=5
      lkey=5
      linfo=0
      ityp=2
      exname='*'
      call balloc(LNGRMHD,ia)
      lgram=istlen(gram)
      call tropnn(-1,gram(1:lgram),ifstat,iflap,ierr
     1    ,nstak,maxlev,ibig(ia+OGHITG)
     1    ,mord,lkey,linfo,ityp,exname)
    
      if(ierr.ne.0) then
        write(6,'(2a)') 'opengram: unable to open:',gram(1:lgram)
        call dalloc(LNGRMHD,ia)
        return
      endif
      nstak=3
      maxlev=3
      mord=51
      lkey=7
      linfo=0
      ityp=2
      exname='*'
      call tropnn(ibig(ia+OGHITG),'channels',STUNK,iflap,ierr
     1  ,nstak,maxlev,ibig(ia+OGHTGS)
     1  ,mord,lkey,linfo,ityp,exname)
      opengram=ia
      ibig(ia+OGHNOP)=0
      return
      end
