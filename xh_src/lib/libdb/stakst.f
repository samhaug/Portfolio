c-------------------------------------------------------------------

      subroutine stakst(istadr)
      include "dblib.h"
      write(6,"('stack:',i8,'  ibot:',i4)") istadr,ibig(istadr+OSTBM)
      ip=ibig(istadr+OSTBM)
   10 ip=ibig(ibig(istadr+OSTBL)+ip)
      write(6,"('ip',i2,' fp',i7,' bp',i7
     1 ,' usp',i7,' us',i3,' usp',i7,' us',i3 )")
     1   ip,ibig(ibig(istadr+OSTFT)+ip)
     1  ,ibig(ibig(istadr+OSTBT)+ip)
     1  ,ibig(istadr+OSTUF)+ip
     1  ,ibig(ibig(istadr+OSTUF)+ip)
     1  ,ibig(ibig(istadr+OSTBT)+ip)
     1  ,ibig(ibig(ibig(istadr+OSTBT)+ip))
      if(ip.ne.ibig(istadr+OSTBM)) goto 10
      return
      end
