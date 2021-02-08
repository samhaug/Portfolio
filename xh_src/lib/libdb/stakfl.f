

c-------------------------------------------------------------------

      subroutine stakfl(istadr,iforce)
      include "dblib.h"
      ibot=ibig(istadr+OSTBM)
      ibel=ibot
   10 ibel=ibig(ibig(istadr+OSTBL)+ibel)
      ichn=ibig(istadr+OSTUF)+ibel
      it=ibig(ichn)
      if(it.gt.0.or.(iforce.ne.0.and.it.eq.0)) then
        call bffobs4(ibig(istadr+OSTLU),1
     1     ,ibig(ibig(ibig(istadr+OSTBT)+ibel)),ibig(istadr+OSTNB)
     1    ,j,ibig(ibig(istadr+OSTFT)+ibel)+1)
        ibig(ichn)=0
      endif
      if(ibel.ne.ibot) goto 10
      return
      end
