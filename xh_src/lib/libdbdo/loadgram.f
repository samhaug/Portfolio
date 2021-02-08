c-------------------------------------------------------------------------------
      integer function loadgram(igtab,ig,itim1,itim2,lenbuf,iopt,decrate)
      double precision decrate
      parameter (GAPVAL=1.e-20)
      parameter (LENFLT=1)
      dimension itim1(2),itim2(2)
      include '../libdb/dblib.h'
      include 'gramblock.h'
      include 'seeddefs.h'
      include 'seedtrees.h'
      logical same,getcldr,getabr
      dimension key(7)
      character*28 ckey
      equivalence (key,ckey)
      dimension key1(1),ktim(2)
      character*3 cod
      character*200 str200
      character*4 str4
      equivalence (str4,istr4)
      parameter (MXSUBS=3)
      dimension iofc52(MXSUBS),iofc058(MXSUBS),lenrspb(MXSUBS),irefcr(MXSUBS)
      character*16 chnkey
      integer*4 ichnkey(4)
      integer*2 jchnkey(8)
      equivalence (chnkey,ichnkey,jchnkey)
      double precision smpint,dsmpin,tdiffi,terr,terr1,terr2,fctr
      dimension itimrsp(2)
      integer srespsetup

      include 'cbufcm.h'
      include 'rspaddrs.h'

      lencbuf=len(cbuf)

      iadent=igtab+ibig(igtab+OTGETIT)+(ig-1)*LTENTRY
      numsubs=ibig(iadent+OTNSUBS)
      write(ckey,"(5a4)") (ibig(iadent+i-1),i=1,5)
      call byswap4(key(5),1)
      smpint=dsmpin(key(5))
      call byswap4(key(5),1)

      itimrsp(1)=z'7fffffff'
      itimrsp(2)=0
      do isub=1,numsubs
        if(ibig(iadent+LTHEADR+LTSUBEN*(isub-1)+OTSBNPC).gt.0) then
          iadpc1=igtab+ibig(iadent+LTHEADR+LTSUBEN*(isub-1)+OTSBPAD)
          if(itcmp(ibig(iadpc1),itimrsp).lt.0) then
            itimrsp(1)=ibig(iadpc1)
            itimrsp(2)=ibig(iadpc1+1)
          endif
        endif
      enddo
      if(itcmp(itim1,itimrsp).gt.0) then
        itimrsp(1)=itim1(1)
        itimrsp(2)=itim1(2)
      endif

c get station and channel info and responses
      call openstnk(ckey(1:8),1)
      irank=-1

      if(getcldr(itsticl,mssticl,mtsticl,itimrsp,-1,ktim,key1,1,irank)) then
        irefsi=key1(1)
      else if(irank.gt.0) then
        ierr=1
        irefsi=key1(1)
        write(6,*) 'loadgram: Warning. Using last available station info:',irefsi
      else
        irank=-1
        if(getcldr(itsticl,mssticl,mtsticl,itimrsp,+1,ktim,key1,1,irank)) then
          ierr=1
          irefsi=key1(1)
          write(6,*) 'loadgram: Warning. Using next available station info:',irefsi
        else if(irank.gt.0) then
          ierr=1
          irefsi=key1(1)
          write(6,*) 'loadgram: Warning. Using next available station info:',irefsi
        else
          pause 'loadgram: unable to get station info reference'
        endif
      endif

      iofc=0
      iofc50=iofc
      call getblkt(itsblock,irefsi,cod,itp,cbuf(iofc+1:lencbuf),lcbuf,ierr)
      iofc=iofc+lcbuf
      if(cod.ne.'050') pause 'loadgram: station info blockette wrong type'
c here we should get station comments
      do isub=1,numsubs
        if(ibig(iadent+LTHEADR+LTSUBEN*(isub-1)+OTSBNPC).gt.0) then
          write(ckey(21:28),"(2a4)") (ibig(iadent+LTHEADR+LTSUBEN*(isub-1)+i-1),i=1,2)
          chnkey(1:8)=ckey(21:25)//'   '
          ichnkey(3)=key(5)
          call byswap4(key(7),1)
          jchnkey(7)=and(key(7),z'0000ffff')
          jchnkey(8)=and('000000ff'x,ishft(key(7),-16))
          call byswap4(key(7),1)
          call byswap2(jchnkey(7),2)
          call openchnk(chnkey,1)
c here we should get channel comments
          irank=-1
          if(getcldr(itchrcl,mschrcl,mtchrcl,itimrsp,-1,ktim,key1,1,irank)) then
            irefcr(isub)=key1(1)
          else if(irank.gt.0) then
            ierr=1
            irefcr(isub)=key1(1)
            write(6,*) 'loadgram: Warning using last available channel response:',irefcr(isub)
          else
            irank=-1
            if(getcldr(itchrcl,mschrcl,mtchrcl,itimrsp,+1,ktim,key1,1,irank)) then
              ierr=1
              irefcr(isub)=key1(1)
              write(6,*) 'loadgram: Warning using next available channel response:',irefcr(isub)
            else if(irank.gt.0) then
              ierr=1
              irefcr(isub)=key1(1)
              write(6,*) 'loadgram: Warning using next available channel response:',irefcr(isub)
            else
              ierr=7
              irefcr(isub)=0
              pause 'loadgram: unable to get channel response'
            endif
          endif


          if(getabr(itresp,irefcr(isub),str200,lstr200)) then
            iofc52(isub)=iofc

            k=1
            do while(k.lt.lstr200)
              str4=str200(k:k+3)
              call byswap4(istr4,1)
              call getblkt(itsblock,istr4,cod,itp,cbuf(iofc+1:lencbuf),lcbuf,ierr)
              if(k.eq.1.and.cod.ne.'052') pause 'loadgram: expected 052'
              if(k.eq.5) iofc058(isub)=iofc
              iofc=iofc+lcbuf
              if(ierr.ne.0) then
                ierr=9
                pause 'loadgram: unable to get response blockette'
              endif
              k=k+4
            enddo

            lenrspb(isub)=iofc-iofc058(isub)
          else
            pause 'loadgram: unable to get channel response list'
          endif
          call closechn()
        endif
      enddo


      call closestn()
      nwords=0

c  now construct the station block
      call balloc(LGSTBLK,ia)
      nwords=nwords+LGSTBLK
      iastn=ia
      call makestinfo(cbuf(iofc50+1:iofc52(1)),irefsi,numsubs,rbig(iastn),ibig(iastn))

      if(iopt.lt.0) then  ! get only the station info and quit
        ibig(iastn+OGSPACE)=nwords
        loadgram=iastn
        return
      endif


      do isub=1,numsubs
        if((ibig(iadent+LTHEADR+LTSUBEN*(isub-1)+OTSBNPC)).gt.0) then

          i1=iofc52(isub)+1
          i2=iofc058(isub)+lenrspb(isub)
          call stdunfm(cbuf(i1:i2))

          call balloc(1,iach)
          if(mod(iach,2).ne.0) then
            nwords=nwords+1
            call balloc(1,iach)
          endif
          call dalloc(1,iach)
          lchinfo=makechinfo(cbuf(i1:i2),rbig(iach),ibig(iach))
          call balloc(lchinfo,iach)
          nwords=nwords+lchinfo

          call balloc(1,iaresp)
          call dalloc(1,iaresp)
          lenresp=srespsetup(cbuf(i1:i2),iopt
     1          ,SUNCNT,SUNM,SUNMPS,SUNMPS2,SUNNMPS
     1          ,ibig(iaresp),rbig(iaresp),ltalloc())
          call balloc(lenresp,iaresp)
          nwords=nwords+lenresp

          ibig(iach+OGRSBLO)=iaresp-iach
          ibig(iastn+OGSTCHO+isub-1)=iach-iastn
          ibig(iach+OGRSREF)=irefcr(isub)
        else
          ibig(iastn+OGSTCHO+isub-1)=-1
        endif
      enddo


      do isub=1,numsubs
        npiece=ibig(iadent+LTHEADR+LTSUBEN*(isub-1)+OTSBNPC)
        iad0=-1
        ioffe=0
        do ipiece=1,npiece
          iadpc=igtab+ibig(iadent+LTHEADR+LTSUBEN*(isub-1)+OTSBPAD)+(ipiece-1)*LTSBPCE
          isec1=ibig(iadpc)
          ifrc1=ishft(ibig(iadpc+1),-16)
          isec2=ibig(iadpc+2)
          ifrc2=ishft(ibig(iadpc+3),-16)
          nsamp=ibig(iadpc+OTPCNSM)
          lurd=ibig(iadpc+OTPCLUR)
          ibyt=ibig(iadpc+OTPCBYT)
c         write(6,*) 'Piece:',ipiece,nsamp,' samples.'
          if(itcmp(ibig(iadpc),itim1).lt.0) then
c           write(6,*) 'loadgram skipping samples at start'
c           write(6,*) 'Previous start',isec1,ifrc1
            iskip=1.d0+tdiffi(itim1,ibig(iadpc))/smpint
c           write(6,*) 'Skiping:',iskip
            ibyt=ibyt+4*iskip
            nsamp=nsamp-iskip
            call taddi2(isec1,ifrc1,isec1,ifrc1,smpint*iskip)
c           write(6,*) 'New start:',isec1,ifrc1
          endif
          if(itcmp(ibig(iadpc+2),itim2).gt.0) then
c           write(6,*) 'loadgram skipping samples at end'
c           write(6,*) 'Previous end',isec2,ifrc2
            iskip=1.d0+tdiffi(ibig(iadpc+2),itim2)/smpint
            nsamp=nsamp-iskip
c           write(6,*) 'nsamp,iskip',nsamp,iskip
            call taddi2(isec2,ifrc2,isec2,ifrc2,-smpint*iskip)
c           write(6,*) 'New end:',isec2,ifrc2
          endif
          if(nsamp.gt.0) then
            if(iad0.eq.-1) then
              if(lenbuf.ne.-1.and.nsamp.gt.lenbuf) then
                nsamp=lenbuf
              endif
              call balloc(nsamp,iad0)
              call bffi(lurd,1,ibig(iad0),nsamp*4,j,m,ibyt+1)
              call byswap4(ibig(iad0),nsamp)
              nwords=nwords+nsamp
              isec0=isec1
              ifrc0=ifrc1
              isec9=isec2
              ifrc9=ifrc2
              ioff1=0
              ioff2=ioff1+nsamp
              ioffe=ioff2
              ngap=0
              terr=0.
            else
              if(isec2.gt.isec9) then
                isec9=isec2
                ifrc9=ifrc2
              else if(isec2.eq.isec9.and.ifrc2.gt.ifrc9) then
                ifrc9=ifrc2
              endif
              ioff1=(isec1-isec0+(ifrc1-ifrc0)/10000.d0)/smpint+.5d0
              if(lenbuf.ne.-1.and.ioff1+nsamp.gt.lenbuf) then
                nsamp=lenbuf-ioff1
              endif
              if(nsamp.gt.0) then
                ioff2=ioff1+nsamp
                if(ioff2.gt.ioffe) then
                  call balloc(ioff2-ioffe,ia)
                  nwords=nwords+ioff2-ioffe
                  if(ia.ne.iad0+ioffe) pause 'loadgram: unexpected address'
                endif
  
                call balloc(nsamp,iad)
                call bffi(lurd,1,ibig(iad),nsamp*4,j,m,ibyt+1)
                call byswap4(ibig(iad),nsamp)
                if(ioff1.gt.ioffe) then
                  ngap=ngap+ioff1-ioffe
                  do i=iad0+ioffe,iad0+ioff1-1
                    rbig(i)=GAPVAL
                  enddo
c                 write(6,*) 'loadgram: data gap:',ioff1-ioffe,' samples'
                else if(ioff1.lt.ioffe) then
                  same=.TRUE.
                  ia=iad0+ioff1
                  ib=iad
                  do i=1,ioffe-ioff1
                    if(ibig(ia).eq.-1) then
                      ngap=ngap-1
                    else if(rbig(ia).ne.rbig(ib)) then
                      same=.FALSE.
                    endif
                    ia=ia+1
                    ib=ib+1
                  enddo
                  if(same) then
c                   write(6,*) 'loadgram: overlap, no contradiction'
                  else
                    write(6,*) 'loadgram: Warning: Overlap, inconsistent data'
                  endif
                else
c                  write(6,*) 'loadgram: exact join'
                endif

                ia=ioff1+iad0
                ib=iad
                do i=1,nsamp
                  rbig(ia)=rbig(ib)
                  ia=ia+1
                  ib=ib+1
                enddo

                call dalloc(nsamp,iad)
                ioffe=max0(ioff2,ioffe)
           
              endif
              terr1=isec1-isec0+(ifrc1-ifrc0)/10000.d0-smpint*ioff1
              terr2=isec2-isec0+(ifrc2-ifrc0)/10000.d0-smpint*(ioff2-1)
c              write(6,"('Time errors:',2f10.4)") terr1,terr2
              terr=dmax1(terr,dabs(terr1))
              terr=dmax1(terr,dabs(terr2))
            endif
          endif
        enddo
c       end of do over pieces
c        write(6,*) ckey(1:5),ckey(9:13),isub,' ',ngap, '  Missing samples'
c     1   ,'  Max. time error: ',terr
        if(iad0.ge.0) then
          if(lenbuf.ne.-1.and.ioffe.lt.lenbuf) then
            call balloc(lenbuf-ioffe,ia)
            nwords=nwords+lenbuf-ioffe
            do i=ia,ia+lenbuf-ioffe-1
              rbig(i)=0.0
            enddo
          endif
          if(ibig(iastn+OGSTCHO+isub-1).ge.0) then
            iach=iastn+ibig(iastn+OGSTCHO+isub-1)

c adjust start time to match end time.
            terr=isec9-isec0+(ifrc9-ifrc0)/10000.d0-smpint*(ioffe-1)
            if(dabs(terr).gt..01) then
              call taddi2(isec0,ifrc0,isec0,ifrc0,terr)
              write(6,'(''loadgram: start time adjusted by'',f10.4,'' s'')') terr
            endif

            ibig( iach + OGCHSGS )=isec0
            ibig( iach + OGCHSGS+1)=ishft(ifrc0,16)
            ibig( iach + OGCHSGE )=isec9
            ibig( iach + OGCHSGE+1)=ishft(ifrc9,16)
            ibig( iach + OGCHSGA)=iad0-iach
            ibig( iach + OGCHSGL)=ioffe
            ibig( iach + OGCHSGG)=ngap
            ibig( iach + OGCHNPC)=npiece
            if(decrate.gt.0.d0.and.smpint*decrate.lt..9999d0) then
              iaresp=iach+ibig(iach+OGRSBLO)
              ipf=iaresp/LENFLT

              fctr=decrate*smpint
              do ii=1,1000
                iden=ii/fctr+.5d0
                if(dabs(fctr*iden/ii-1).lt.1.d-8) then
                  inum=ii
                  write(6,'(''Decimation by:'',i6,'' / '',i5)') inum,iden
                  goto 24
                endif
              enddo
              write(6,'(''loadgram: Unable to find decimation factor'')')
              goto 25
   24         continue
              minbuf1=ioffe
              n1=2*iden
              do while(n1.lt.minbuf1)
                n1=n1*2
              enddo
              n2=inum*(n1/iden)
              write(6,*) 'Transform lengths: ',n1,n2
              call balloc(n1+2,iat)
              i1=iad0
              i2=iat
              do i=1,ioffe
                rbig(i2)=rbig(i1)
                if(ibig(i2).eq.GAPVAL) rbig(i2)=0.
                i1=i1+1
                i2=i2+1
              enddo
              call remavl(ioffe,rbig(iat))
              do i=ioffe+1,n1+2
                rbig(i2)=0.0
                i2=i2+1
              enddo
              call tfour(rbig(iat),n1/2,1)
              call tfour(rbig(iat),n2/2,-1)
              nsamp=(inum*ioffe+iden-1)/iden
              i1=iad0
              i2=iat
              do i=1,nsamp
                rbig(i1)=rbig(i2)
                i1=i1+1
                i2=i2+1
              enddo
              call dalloc(n1+2,iat)
              call dalloc(ioffe-nsamp,iad0+nsamp)
              nwords=nwords-(ioffe-nsamp)

              rbig(ipf+FRSSRT)=decrate
              ibig( iach + OGCHSGL)=nsamp

   25         continue
            endif
          endif
        else    ! no data
c          iach=iastn+ibig(iastn+OGSTCHO+isub-1)
c          ibig(iach + OGCHSGA)=-1
c          write(6,*) 'loadgram: would have used:', ibig(iastn+OGSTCHO+isub-1)
        endif
      enddo
c     end of do over subchannels


      ibig(iastn+OGSPACE)=nwords

      loadgram=iastn
      return
      end
