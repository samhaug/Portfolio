      subroutine trlink(itre1,itre2)
c     copy file extension pointers from current entry
c     in itre1 to that in itre2

      include 'dblib.h'

      la1=ibig(itre1+OTRKO)
      ilev1=ibig(itre1+OTRLV)
      lkey1=ibig(itre1+OTRLK)
      linfo1=ibig(itre1+OTRLI)
      lres1=ibig(itre1+OTRNR)
      iptha1=ibig(itre1+OTRPA)+ilev1
      ikeya1=ibig(itre1+OTRKY)+ilev1
      istak1=ibig(itre1+OTRST)
      if(ibig(iptha1).lt.0) pause 'trwrit: no current key'
      lux1=ibig(itre1+OTRUX)
      obotol1=ibig(istak1+OSTBM)
      call stakgt(istak1,ibig(iptha1),ibrec1)
      obotnw1=ibig(istak1+OSTBM)
      if(obotnw1.ne.obotol1) pause 'trwrit: not working as expected'
      k1=ibrec1+2+ibig(ikeya1)*la1+lres1+lkey1+linfo1

      la2=ibig(itre2+OTRKO)
      ilev2=ibig(itre2+OTRLV)
      lkey2=ibig(itre2+OTRLK)
      linfo2=ibig(itre2+OTRLI)
      lres2=ibig(itre2+OTRNR)
      iptha2=ibig(itre2+OTRPA)+ilev2
      ikeya2=ibig(itre2+OTRKY)+ilev2
      istak2=ibig(itre2+OTRST)
      if(ibig(iptha2).lt.0) pause 'trwrit: no current key'
      lux2=ibig(itre2+OTRUX)
      obotol2=ibig(istak2+OSTBM)
      call stakgt(istak2,ibig(iptha2),ibrec2)
      obotnw2=ibig(istak2+OSTBM)
      if(obotnw2.ne.obotol2) pause 'trwrit: not working as expected'
      k2=ibrec2+2+ibig(ikeya2)*la2+lres2+lkey2+linfo2


      if(lux1.ne.lux2) then
        pause 'trlink: attempt to link different files'
      endif
      if(lux1.le.0) then
        pause 'trlink: attempt to link non extendable entries'
      endif
      do i=0,LEXPK-1
        ibig(k2+i)=ibig(k1+i)
      enddo
      call trtuch(itre2)

      return
      end

