

c-------------------------------------------------------------------

      subroutine trdelk(itre)
      include "dblib.h"
      logical trnext,trfind
      la=ibig(itre+OTRKO)
      lam1=la-1
      lam2=la-2
      mord=ibig(itre+OTROR)
      lkey=ibig(itre+OTRLK)
      linfo=ibig(itre+OTRLI)
      istak=ibig(itre+OTRST)
      ilev=ibig(itre+OTRLV)
      iptha=ibig(itre+OTRPA)+ilev
      ikeya=ibig(itre+OTRKY)+ilev
      ipthd=ibig(iptha)
      ikeyd=ibig(ikeya)
      if(ipthd.lt.0) pause 'trdelk: no current key'
      call stakgt(istak,ipthd,ibrec)
c ! pointer to current key
      kd=ibrec+2+ikeyd*la

c Save current key
      call balloc(lkey,iadck)
      do i=0,lkey-1
        ibig(iadck+i)=ibig(kd+i)
      enddo

      nkey=ibig(ibrec)-1
c ! not a leaf
      if(ibig(kd-1).ge.0) then
        if(.not.trnext(itre,-1,iok,ioi)) pause 'trdelk: no successor'
        ilev=ibig(itre+OTRLV)
        ipa1=ibig(ibig(itre+OTRPA)+ilev)
        ike1=ibig(ibig(itre+OTRKY)+ilev)
        call stakgt(istak,ipa1,ibrec)
        nkey=ibig(ibrec)-1
        if(ike1.ne.nkey) pause 'trdelk: successor not last'
        call balloc(lam1,is1)
c ! pointer to current key
        k=ibrec+2+ike1*la
        do i=0,lam2
          ibig(is1+i)=ibig(k+i)
        enddo
        ibig(ibrec)=nkey
        call staktc(istak)

        call stakgt(istak,ipthd,ibrec)
        do i=0,lam2
          ibig(kd+i)=ibig(is1+i)
        enddo
        call staktc(istak)
        call dalloc(lam1,is1)
      else
        do i=kd,ibrec+1+nkey*la
          ibig(i)=ibig(i+la)
        enddo
        ibig(ibrec)=nkey
        call staktc(istak)
        ipa1=ipthd
      endif
c ! get the record which may be short
   10 call stakgt(istak,ipa1,ibrec)
      nkey=ibig(ibrec)
c ! underflow
      if(nkey.lt.mord/2) then
c ! borrow from brothers
        if(ilev.gt.0) then
c ! first try on the right
          do idr=1,-1,-2
            idir=idr
            iptha=ibig(itre+OTRPA)+ilev
            ikeya=ibig(itre+OTRKY)+ilev
            ipa2=ibig(ibig(itre+OTRPA)+ilev-1)
            ike2=ibig(ibig(itre+OTRKY)+ilev-1)
            if(idir.lt.0) then
              call stakgt(istak,ipa2,ibrec)
              ike2=ike2-1
              if(ike2.ge.0) then
                ipa3=ibig(ibrec+1+ike2*la)
                call stakgt(istak,ipa3,ibrec)
                if(ibig(ibrec).gt.mord/2) then
                  call trrotk(istak,ipa1,ike2,ipa2,ipa3,idir,la)
                  goto 99
                else
                  call trbmrg(istak,ipa1,ike2,ipa2,ipa3,idir,la,mord)
                  ipa1=ipa2
                  ilev=ilev-1
                  goto 10
                endif
              endif
            else
              call stakgt(istak,ipa2,ibrec)
              if(ike2.lt.ibig(ibrec)) then
                ipa3=ibig(ibrec+1+ike2*la+la)
                call stakgt(istak,ipa3,ibrec)
                if(ibig(ibrec).gt.mord/2) then
                  call trrotk(istak,ipa1,ike2,ipa2,ipa3,idir,la)
                  goto 99
                else
                  call trbmrg(istak,ipa1,ike2,ipa2,ipa3,idir,la,mord)
                  ipa1=ipa2
                  ilev=ilev-1
                  goto 10
                endif
              endif
            endif
          enddo
c ! root can be short
        else
          if(ibig(ibrec).gt.0) then
            goto 99
c ! root has disappeared
          else
            ifadr=ibig(ibrec+1)
            ibig(itre+OTRFR)=ifadr
              itref=ibig(itre+OTRFA)
c ! look for father
              if(itref.ge.0) then
                if(trfind(itref,ibig(itre+OTRNM)
     1             ,ibig(itre+OTRLN),iok,ioi)) then
                  ibig(iok+ibig(itref+OTRLK))=ifadr
                  call trtuch(itref)
                else
                  pause 'addrotr: father not found'
                endif
              else
                lu=ibig(ibig(itre+OTRST)+OSTLU)
c ! update root
                call bffobs4(lu,1,ifadr,4,j,ODRFR*4+1)
              endif
            endif
          endif
        endif
   99   continue
c Reposition
        if(trfind(itre,ibig(iadck),lkey,iok,ioi)) 
     1     pause 'trdelk: deleted key found'
        call dalloc(lkey,iadck)
        return
        end
