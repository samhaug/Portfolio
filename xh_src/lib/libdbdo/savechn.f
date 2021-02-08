c-------------------------------------------------------------------

      subroutine savechn()
      include 'seeddefs.h'
      include 'seedcommun.h'
      include 'seedtrees.h'
      include '../libdb/dblib.h'
      integer*4 itim1(2),itim2(2)
      integer*2 jtim1(4),jtim2(4)
      equivalence (itim1,jtim1),(itim2,jtim2)
      character*24 tcha1,tcha2
      integer*4 cinfo(2)
      parameter (MXKEYS=50)
      integer*4 keys(MXKEYS)
      character*(MXKEYS*4) ckeys
      equivalence (keys,ckeys)
      character*3 rcodes(MXKEYS)
      dimension ikey(2)
      dimension key(2)
      character*8 ckey
      equivalence (key,ckey)
      character*5 tcode
      logical getcldr,trfind,trnext
      read(chnsub,"(i4)") isub
c     call openchn(chnlocid,chnname,ichnrate,ichnlfmt,isub,4)

      if(nchblocks.eq.0) return
      
      nkeys=0

      k1=iadchblock(1)+1
      k2=iadchblock(2)
      if(strings(k1:k1+2).eq.'052') then
        call setabrn(itsblock,itsblockh,lssblock
     1         ,ikey(1),strings(k1:k2),tmpblk,ifound)
        call perform(nhash)
c        if(nhash.gt.1) write(6,*) strings(k1:k1+19),'  nhash=',nhash

        tcha1=tgotstdchn(1,1)
        tcha2=tgotstdchn(2,1)
c       write(6,*) stnopen,' ',chnlocid,chnname,' ',chnsub,':',tcha1,' to ',tcha2
        call inttime(tgotstdchn(1,1),itim1)
        call inttime(tgotstdchn(2,1),itim2)
c       write(6,'(a,i4,4z10)') 'intimvol in   ', itcmp(itim2,itim1) , itim1,itim2
        call intimvol(itim1,itim2,itim1vol,itim2vol,ierr)
c       write(6,'(a,i4,8z10)') 'intimvol found', itcmp(itim2,itim1) , itim1,itim2,itim1vol,itim2vol

        if(ierr.eq.0.and.itcmp(itim1,itim2vol).eq.-1) then
c       if(ierr.eq.0) then


c Make sure the right version of the station is open
          irank=-1
          if(getcldr(itsticl,mssticl,mtsticl,itim1,-1,ktim,key1,1,irank)) then
          else
            tcode=stnopen
            call closestn()
            key(2)=0
            ckey(1:5)=tcode
            if(trfind(itstns,key,2,iok,ioi)) pause 'savechn: small found'
            do while(trnext(itstns,1,iok,ioi).and.ckey(1:5).eq.tcode)
              key(1)=ibig(iok)
              key(2)=ibig(iok+1)
              call byswap4(key,2)
              if(ckey(1:5).eq.tcode) then
                call openstnk(ckey,4)
                irank=-1
                if(getcldr(itsticl,mssticl,mtsticl,itim1,-1,ktim,key1,1,irank)) then
                  goto 87
                else
                endif
              endif
            enddo
            write(6,*) 'savechn: No version of station found. Item not saved in info calendar'
     1        ,stnopen//chnlocid//chnname
            goto 88
c           pause 'savechn: No version of station found'
          endif

   87     continue

          call openchn(chnlocid,chnname,ichnrate,ichnlfmt,isub,4)




          inrank=-3
          call setcldr(itchicl,mschicl,mtchicl,itim1,itim2,ikey(1),1,inrank)
        else
          write(6,*) 'savechn: Time error. Item not saved in info calendar'
     1        ,stnopen//chnlocid//chnname
        endif
   88   continue
        nkeys=nkeys+1
        keys(nkeys)=ikey(1)
        ii1=2
      else
        ii1=1
      endif

c     nkeys=0


      do i=ii1,nchblocks
        k1=iadchblock(i)+1
        k2=iadchblock(i+1)
        if(strings(k1:k1+2).eq.'059') then
          call inttime(tgotstdchn(1,i),itim1)
          call inttime(tgotstdchn(2,i),itim2)
          call intimvol(itim1,itim2,itim1vol,itim2vol,ierr)
c         if(ierr.eq.0) then
          if(ierr.eq.0.and.itcmp(itim1,itim2vol).eq.-1) then
            cinfo(1)=kgotstdchn(1,i)
            if(kstr.ne.0) cinfo(1)=kabbrmap(cinfo(1),DICTCT)
            cinfo(2)=igotstdchn(1,i)
            inrank=-3
            call setcldr(itchccl,mschccl,mtchccl,itim1,itim2,cinfo,2,inrank)
          else
            write(6,*) 'savechn: Time error. Channel comment not saved in info calendar'
     1        ,stnopen//chnlocid//chnname,tgotstdchn(1,i),tgotstdchn(2,i)
            ierr=0
          endif

        else
          call setabrn(itsblock,itsblockh,lssblock
     1             ,ikey(1),strings(k1:k2),tmpblk,ifound)
        call perform(nhash)
c        if(nhash.gt.1) write(6,*) strings(k1:k1+19),'  nhash=',nhash


          nkeys=nkeys+1
          if(nkeys.gt.MXKEYS) pause 'savechn: too many channel blockettes'
          keys(nkeys)=ikey(1)
          rcodes(nkeys)=strings(k1:k1+2)

        endif
      enddo

      if(nkeys.gt.0) then
        call setabrn(itresp,itresph,lsresp
     1             ,ikey(1),ckeys(1:nkeys*4),tmpblk,ifound)
        call perform(nhash)
c        if(nhash.gt.1) write(6,*) 'cr',(keys(iii),iii=1,nkeys),'  nhash=',nhash


        call inttime(tgotstdchn(1,1),itim1)
        call inttime(tgotstdchn(2,1),itim2)
        call intimvol(itim1,itim2,itim1vol,itim2vol,ierr)
c       if(ierr.eq.0) then
        if(ierr.eq.0.and.itcmp(itim1,itim2vol).eq.-1) then

          inrank=-3
          call setcldr(itchrcl,mschrcl,mtchrcl,itim1,itim2,ikey(1),1,inrank)

c         write(6,*) '      Response:',ikey(1),':',(keys(i),'.',rcodes(i),i=1,nkeys)
        else
          write(6,*) 'savechn: Time error. Item not saved in resp calendar'
     1        ,stnopen//chnlocid//chnname
        endif
      else 
        write(6,*) '      No response.'
     1        ,stnopen//chnlocid//chnname


      endif




      return
      end
