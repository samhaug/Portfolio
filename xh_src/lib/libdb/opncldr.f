

c-----------------------------------------------------
      subroutine opncldr(itre,name,istat,iflap,ierr
     1   ,nstak,maxlev,itcldr,mscldr,mtcldr
     1   ,mord,linfo)
      character*(*) name
      include 'dblib.h'
      character*1 exname
      integer*4 jtim(2)
      logical trfind,trnext

c     write(6,'(''opncldr'')')

      lkey=2
      ityp=0
      exname='*'
      if(ibig(itre+OTRLI).lt.1) then
        write(6,*) ibig(itre+OTRLI)
        pause 'opencldr: parent wrong linfo'
      endif
      call tropnn(itre,name,istat,iflap,ierr
     1     ,nstak,maxlev,itcldr
     1     ,mord,lkey,linfo,ityp,exname)
      if(.not.trfind(itre,ibig(itcldr+OTRNM),ibig(itre+OTRLK),iok,ioi))
     1     pause 'opened tree not found'
        if(ibig(ioi).eq.-1) then
          ibig(ioi)=mscldr
          call trtuch(itre)
        else
          mscldr=ibig(ioi)
        endif
          



      jtim(1)=z'7ffffffe'
      jtim(2)=9999
      if(trfind(itcldr,jtim,2,iok,ioi)) pause 'opncldr: large time found'
      if(trnext(itcldr,-1,iok,ioi)) then
        mtcldr=ibig(iok)+1
      else
        mtcldr=z'80000000'
      endif
      return
      end
