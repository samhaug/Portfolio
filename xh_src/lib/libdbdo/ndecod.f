
c----------------------------------------------------------------------

      subroutine ndecod(dbuf2,dbuf4,xbuf,lform,im,i1,i2,nend,ifchk)
      integer*2 dbuf2(*)
      integer*4 dbuf4(*)
      real*4 xbuf(*)
      include 'seeddefs.h'
      integer*2 it(2)
      equivalence (it(1),jt)
      dimension map(15)
      parameter(vmult=1./1024.)
      integer*2 kt,minus12/-12/,seven/7/,ten/10/,mask1/4095/
      integer*2 minus8/-8/,right/z'00ff'/
      dimension idif(25)
      ifchk=-1
      num=i2-i1+1
      if(lform.eq.SFMSRO) then
        jj=i1
        do kk=1,num
          kt=dbuf2(jj)
          call byswap2(kt,1)
          xbuf(kk)=srotrn(kt)
          jj=jj+1
        enddo
      else if(lform.eq.SFMCDS) then
        jj=i1
        do kk=1,num
          kt=dbuf2(jj)
          call byswap2(kt,1)
          xbuf(kk)=rstntr(kt)
          jj=jj+1
        enddo
      else if(lform.eq.SFMDWW) then
        jj=i1
        do kk=1,num
          kt=dbuf2(jj)
          call byswap2(kt,1)
          xbuf(kk)=kt
          jj=jj+1
        enddo
      else if(lform.eq.SFMSTM) then
        iaddr=0
        iframe=0
        nd=0
        kk=0
        do while(nd.lt.i2)
          iframe=iframe+1
          iaddr=iaddr+1
          k4=dbuf4(iaddr)
          call byswap4(k4,1)
          k=30
          do j=1,15
            k=k-2
            map(j)=ibits(k4,k,2)
          enddo
          if(iframe.eq.1) then
            iaddr=iaddr+1
            k4=dbuf4(iaddr)
            call byswap4(k4,1)
            iforwd=k4
c           write(6,'(''starting iforwd'',i10)') iforwd
            nd=1
            if(nd.ge.i1.and.nd.le.i2) then
              kk=kk+1
              xbuf(kk)=iforwd
            endif
            iaddr=iaddr+1
            k4=dbuf4(iaddr)
            call byswap4(k4,1)
            irever=k4
            istrt=3
            kstrt=2
          else
            istrt=1
            kstrt=1
          endif
          do j=istrt,15
            iaddr=iaddr+1
            jt=dbuf4(iaddr)
            mapj=map(j)
            if(mapj.eq.1) then
              call byswap2(it,2)
              ngot=4
              idif(1)=ishft(it(1),minus8)
              idif(2)=and(it(1),right)
              idif(3)=ishft(it(2),minus8)
              idif(4)=and(it(2),right)
              do i=1,4
                if(btest(idif(i),7)) idif(i)=or(idif(i),z'ffffff00')
              enddo
            else if(mapj.eq.2) then
              call byswap2(it,2)
              ngot=2
              idif(1)=it(1)
              idif(2)=it(2)
            else if(mapj.eq.3) then
              call byswap4(jt,1)
              ngot=1
              idif(1)=jt
            else
              ngot=0
            endif
            do i=kstrt,ngot
              iforwd=iforwd+idif(i)
              nd=nd+1
              if(nd.ge.i1.and.nd.le.i2) then
                kk=kk+1
                xbuf(kk)=iforwd
c               write(6,'(''kk iforwd='',2i10)') kk,iforwd
              endif
            enddo
            kstrt=1
          enddo
        enddo
        if(nd.eq.nend) then
          if(iforwd.eq.irever) then
            ifchk=0
          else
            ifchk=1
            write(0,'(''ndecod: STEIM1 format error:'',5i10)') 
     1                 i1,i2,nend,iforwd,irever
          endif
        endif
      else if(lform.eq.SFMST2) then  ! Steim 2 format
        iaddr=0
        iframe=0
        nd=0
        kk=0
        do while(nd.lt.i2)
          iframe=iframe+1
          iaddr=iaddr+1
          k4=dbuf4(iaddr)
          call byswap4(k4,1)
          k=30
          do j=1,15
            k=k-2
            map(j)=ibits(k4,k,2)
          enddo
          if(iframe.eq.1) then
            iaddr=iaddr+1
            k4=dbuf4(iaddr)
            call byswap4(k4,1)
            iforwd=k4
            nd=1
            if(nd.ge.i1.and.nd.le.i2) then
              kk=kk+1
              xbuf(kk)=iforwd
            endif
            iaddr=iaddr+1
            k4=dbuf4(iaddr)
            call byswap4(k4,1)
            irever=k4
            istrt=3
            kstrt=2
          else
            istrt=1
            kstrt=1
          endif
          do j=istrt,15
            iaddr=iaddr+1
            jt=dbuf4(iaddr)
            mapj=map(j)
            if(mapj.eq.1) then     ! 4 1-byte differences
              call byswap2(it,2)
              ngot=4
              idif(1)=ishft(it(1),minus8)
              idif(2)=and(it(1),right)
              idif(3)=ishft(it(2),minus8)
              idif(4)=and(it(2),right)
              do i=1,4
                if(btest(idif(i),7)) idif(i)=or(idif(i),z'ffffff00')
              enddo
            else if(mapj.eq.2) then ! 30 15 or 10 bit
              call byswap4(jt,1)
              itest=ibits(jt,30,2)
              if(itest.eq.0) then
                ngot=0
              else if(itest.eq.1) then
                ngot=1
                idif(1)=ibits(jt,0,30)
                if(btest(idif(1),29)) idif(1)=or(idif(1),z'c0000000')
              else if(itest.eq.2) then
                ngot=2
                idif(1)=ibits(jt,15,15)
                idif(2)=ibits(jt,0,15)
                do i=1,ngot
                  if(btest(idif(i),14)) idif(i)=or(idif(i),z'ffff8000')
                enddo
              else if(itest.eq.3) then
                ngot=3
                idif(1)=ibits(jt,20,10)
                idif(2)=ibits(jt,10,10)
                idif(3)=ibits(jt,0,10)
                do i=1,ngot
                  if(btest(idif(i),9)) idif(i)=or(idif(i),z'fffffc00')
                enddo
              endif
            else if(mapj.eq.3) then
              call byswap4(jt,1)
              itest=ibits(jt,30,2)
              if(itest.eq.0) then
                ngot=5
                idif(1)=ibits(jt,24,6)
                idif(2)=ibits(jt,18,6)
                idif(3)=ibits(jt,12,6)
                idif(4)=ibits(jt,06,6)
                idif(5)=ibits(jt,0,6)
                do i=1,ngot
                  if(btest(idif(i),5)) idif(i)=or(idif(i),z'ffffffc0')
                enddo
              else if(itest.eq.1) then
                ngot=6
                idif(1)=ibits(jt,25,5)
                idif(2)=ibits(jt,20,5)
                idif(3)=ibits(jt,15,5)
                idif(4)=ibits(jt,10,5)
                idif(5)=ibits(jt,05,5)
                idif(6)=ibits(jt,0,5)
                do i=1,ngot
                  if(btest(idif(i),4)) idif(i)=or(idif(i),z'ffffffe0')
                enddo
              else if(itest.eq.2) then
                ngot=7
                idif(1)=ibits(jt,24,4)
                idif(2)=ibits(jt,20,4)
                idif(3)=ibits(jt,16,4)
                idif(4)=ibits(jt,12,4)
                idif(5)=ibits(jt,08,4)
                idif(6)=ibits(jt,04,4)
                idif(7)=ibits(jt,00,4)
                do i=1,ngot
                  if(btest(idif(i),3)) idif(i)=or(idif(i),z'fffffff0')
                enddo
              else if(itest.eq.3) then
                ngot=0
              endif
            else
              ngot=0
            endif
            do i=kstrt,ngot
              iforwd=iforwd+idif(i)
              nd=nd+1
              if(nd.ge.i1.and.nd.le.i2) then
                kk=kk+1
                xbuf(kk)=iforwd
              endif
            enddo
            kstrt=1
          enddo
        enddo
        if(nd.eq.nend) then
          if(iforwd.eq.irever) then
            ifchk=0
            write(0,'(''ndecod: STEIM2 format ok:   '',5i10)') 
     1                 i1,i2,nend,iforwd,irever
          else
            ifchk=1
            write(0,'(''ndecod: STEIM2 format error:'',5i10)') 
     1                 i1,i2,nend,iforwd,irever
          endif
        endif

      else if(lform.eq.SFMUSN) then  ! USN format
        iframe=0
        nd=0
        kk=0
        jt=dbuf4(1)
        call byswap4(jt,1)
        iforwd=jt
        kt=dbuf2(3)
        call byswap2(kt,1)
        ndifsr=kt
        nd=nd+1
        if(nd.ge.i1.and.nd.le.i2) then
          kk=kk+1
          xbuf(kk)=iforwd
        endif
c       write(6,'(''starting with ndifsr,iforwd='',2i12)') ndifsr,iforwd
        ibit=48
        ibit0=ibit
        do while(nd.lt.i2)
          iframe=iframe+1
          mapp=0
          call munchbits(dbuf4,ibit,map,mapp,4,2,0)
c         write(6,'(''Frame:'',i5,'' keys'',2i4)') iframe,(map(i),i=1,2)
          ngot=0
          do j=1,2
            call munchbits(dbuf4,ibit,idif,ngot,usnnl(map(j)),usndf(map(j)),1)
          enddo
          do i=1,ngot
            iforwd=iforwd+idif(i)
            nd=nd+1
c           write(6,'(''Data:'',3i12)') nd,iforwd,idif(i)
            if(nd.ge.i1.and.nd.le.i2) then
              kk=kk+1
              xbuf(kk)=iforwd
            endif
          enddo
c         write(6,'(''i1,nd,i2,iforwd'',4i10)') i1,nd,i2,iforwd
          if(mod(iframe,7).eq.0) then
            call munchbits(dbuf4,ibit,idif,ngot,8,1,0)
            nbyts=idif(ngot)
            if(mod(ibit-ibit0,8).ne.0.or.nbyts.ne.(ibit-ibit0)/8) then
              write(6,'(''USNS format: invalid bytelength check'')')
              ifchk=1
            else
              if(ifchk.eq.-1) ifchk=0
            endif
            ibit0=ibit
          endif
        enddo
c       if(nd.eq.nend) then
c         write(6,'(''last sample in record'',i10)') iforwd
c       endif



      else if(lform.eq.SFM32B) then
        jj=i1
        do kk=1,num
          k4=dbuf4(jj)
          call byswap4(k4,1)
          xbuf(kk)=k4
          jj=jj+1
        enddo
      else if(lform.eq.SFMGR3) then
        jj=3*(i1-1)+im
        do kk=1,num
          kt=dbuf2(jj)
          call byswap2(kt,1)
          if(kt.ne.mask1) then
            iexp=ten-and(ishft(kt,minus12),seven)
            ival=and(kt,mask1)
            xbuf(kk)=ishft(ival-2048,iexp)*vmult
          else
            xbuf(kk)=0.0
          endif
          jj=jj+3
        enddo
      else if(lform.eq.SFMGR3D) then
        jj=i1
        do kk=1,num
          kt=dbuf2(jj)
          call byswap2(kt,1)
          if(kt.ne.mask1) then
            iexp=ten-and(ishft(kt,minus12),seven)
            ival=and(kt,mask1)
            xbuf(kk)=ishft(ival-2048,iexp)*vmult
          else
            xbuf(kk)=0.0
          endif
          jj=jj+1
        enddo
      else if(lform.eq.SFM3BT) then
        jbyt=9*(i1-1)+3*(im-1)
        jword=jbyt/2+1
        jsw=mod(jbyt,2)
        do kk=1,num
          it(1)=dbuf2(jword)
          jword=jword+1
          it(2)=dbuf2(jword)
          call byswap4(jt,1)
          if(jsw.eq.0) then
            jt=ishft(jt,-8)
            jsw=1
          else
            jt=and(jt,z'00ffffff')
            jsw=0
            jword=jword+1
          endif
          if(btest(jt,23)) jt=or(jt,z'ff000000')
          xbuf(kk)=jt
          jword=jword+3
        enddo
      else if(lform.eq.SFM3BTD) then
        jbyt=3*(i1-1)
        jword=jbyt/2+1
        jsw=mod(jbyt,2)
        do kk=1,num
          it(1)=dbuf2(jword)
          jword=jword+1
          it(2)=dbuf2(jword)
          call byswap4(jt,1)
          if(jsw.eq.0) then
            jt=ishft(jt,-8)
            jsw=1
          else
            jt=and(jt,z'00ffffff')
            jsw=0
            jword=jword+1
          endif
          if(btest(jt,23)) jt=or(jt,z'ff000000')
          xbuf(kk)=jt
        enddo
      else if(lform.eq.SFMGR4) then 
        jj=3*(i1-1)+im
        do kk=1,num
          kt=dbuf2(jj)
          call byswap2(kt,1)
          iexp=ten-ishft(kt,minus12)
          ival=and(kt,mask1)
          xbuf(kk)=ishft(ival-2048,iexp)*vmult
          jj=jj+3
        enddo
      else if(lform.eq.SFMGR4D) then 
        jj=i1
        do kk=1,num
          kt=dbuf2(jj)
          call byswap2(kt,1)
          iexp=ten-ishft(kt,minus12)
          ival=and(kt,mask1)
          xbuf(kk)=ishft(ival-2048,iexp)*vmult
          jj=jj+1
        enddo
      else if(lform.eq.SFMMSR) then 
        jj=3*(i1-1)+im
        do kk=1,num
          kt=dbuf2(jj)
          call byswap2(kt,1)
          xbuf(kk)=srotrn(kt)
          jj=jj+3
        enddo
      else if(lform.eq.SFMMDW) then 
        jj=3*(i1-1)+im

        do kk=1,num
          kt=dbuf2(jj)
          call byswap2(kt,1)
          xbuf(kk)=kt
          jj=jj+3
        enddo
      else if(lform.eq.SFMMCD) then 
        jj=3*(i1-1)+im
        do kk=1,num
          kt=dbuf2(jj)
          call byswap2(kt,1)
          xbuf(kk)=rstntr(kt)
          jj=jj+3
        enddo
      else
        pause 'ndecod: invalid lform'
      endif
      return
      end
