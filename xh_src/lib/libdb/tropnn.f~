
c-------------------------------------------------------------------

      subroutine tropnn(itre,name,istat,iflap,ierr
     1  ,nstak,maxlev,itradr
     1  ,mord,lkey,linfo,ityp,exname)
      include "dblib.h"
      parameter (mxlnam=20)
      integer*4 iname(mxlnam)
      character*(*) name,exname


      if(itre.ge.0) then
        lkeyf=ibig(itre+OTRLK)
        if(lkeyf.gt.mxlnam) pause 'tropnn: key too long'
        call  kyread(and(MTRKT,ibig(itre+OTRTP)),lkeyf,name,iname)
c          write(6,'(''T:'',z10,1x,a,3x,20z8.8)') and(MTRKT,ibig(itre+OTRTP)),name,(iname(i),i=1,lkeyf)
      else
        lkeyf=(istlen(name)+3)/4
        if(lkeyf.gt.mxlnam) pause 'tropnn: key too long'
        call  kyread(VTRAK,lkeyf,name,iname)
c       call byswap4(iname,lkeyf)
c          write(6,'(''F:'',z10,1x,a,3x,20z8.8)') VTRAK,name,(iname(i),i=1,lkeyf)
      endif

      call tropnk(itre,iname,lkeyf,istat,iflap,ierr
     1    ,nstak,maxlev,itradr
     1    ,mord,lkey,linfo,ityp,exname)
        return
      end
