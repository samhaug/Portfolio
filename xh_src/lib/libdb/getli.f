c-------------------------------------------------------------------
      character*80 function getli(ident,nni,nbyts)
      character*(*) ident
      character*80 getgnl

      include "../libio/getgnl.h"
cc      character*80 cline
cc      character*30 swnam(30)
cc      dimension lswnam(30),ifreq(30),nmin(30),nmax(30)
cc     1         ,icnt(30),iopn(30),iptr(30),itable(100,3)

      include "getli.h"
cc      common/cgetli/swnam,cline
cc      common/igetli/nswt,lswnam,ifreq,nmin,nmax
cc     1         ,icnt,iopn,iptr,itable

      getli=getgnl(ident,nni,nbyts
     1  ,swnam,cline,deflt
     1  ,nswt,lswnam,ldeflt,ifreq,nmin,nmax
     1  ,icnt,iopn,iptr,itable)

      return
      end
