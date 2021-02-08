c----------------------------------------------------------


      subroutine eatblock(inum,cbuf,cod,itp)
      character*(*) cod,cbuf
      include 'seeddefs.h'
      include 'seedcommun.h'
      include 'seedtrees.h'
      character*1 fmlett
      character*3 chnnmsv
      character*200 mess
      character*4 fmtvers
      double precision dsmpin
      dimension itim1(2),itim2(2),itval1(2),itval2(2)
      parameter (MXBLOCK=20000)
      character*(MXBLOCK) tempstr
      save mode,itval1,itval2
      if(inum+7.gt.MXBLOCK) pause 'eatblock: increase MXBLOCK'
      if(itp.eq.STPV) then
        if(cod.eq.'010') then
          volblock=cbuf(1:inum)
          lvolblock=inum
          io=0
          fmtvers=cbuf(io+1:io+4)
          if(fmtvers.eq.'NDTF') then
            ifmultf=1
          else if(fmtvers.eq.'SROF') then
            ifmultf=1
          else if(fmtvers.eq.'HGLF') then
            ifmultf=1
          else if(fmtvers.eq.'IDAF') then
            ifmultf=1
          else if(fmtvers.eq.'GSPF') then
            ifmultf=1
          else if(fmtvers.eq.'02.0'.or.fmtvers.eq.' 2.0') then
            ifmultf=0
          else if(fmtvers.eq.'02.1'.or.fmtvers.eq.' 2.1') then
            ifmultf=0
          else if(fmtvers.eq.'02.3'.or.fmtvers.eq.' 2.3') then
            ifmultf=0
          else if(fmtvers.eq.'02.4'.or.fmtvers.eq.' 2.4') then
            ifmultf=0
          else
            pause 'eatblock: unknown tape format'
          endif
          io=6
          call gettim(volblock(1:lvolblock),io,iy,id,ih,im,fs)
          ifs=fs+.5
          fs=ifs
          call timsec(iy,id,ih,im,fs,itim1vol(1))
          call gettim(volblock(1:lvolblock),io,iy,id,ih,im,fs)
          ifs=fs+.5
          fs=ifs
          call timsec(iy,id,ih,im,fs,itim2vol(1))

          nmsegs=0
        endif
      else if(itp.eq.STPA) then
        ient=0
        kstart=kstr
        idkey=-1
        k=0
   10   continue
        call getfield(cod,itp,cbuf(1:inum),k,indcd,ient,ileve,mess,lmess,icdstat)
        if(ient.lt.0) goto 20
        if((entstat(ient,indcd)/MXDICTS)*MXDICTS.eq.INSERT) then
          idc=entstat(ient,indcd)-INSERT
          read(mess(1:lmess),*) idkey
          do i=1,lmess
            mess(i:i)='0'
          enddo
        endif
        fmlett=fstr(ient,indcd)(1:1)
        if(fmlett.eq.'t'.or.fmlett.eq.'s') then
          lmess=lmess+1
          mess(lmess:lmess)='~'
        endif
        astrings(kstr+1:kstr+lmess)=mess(1:lmess)
        kstr=kstr+lmess
        if(kstr.gt.MXASTRINGS) pause 'eatblock: astrings exceeded'
        goto 10
   20   if(idkey.gt.0) then
          if(idkey.gt.MXABRS) pause 'eatblock: abbreviation code too large'
          kabbr(idkey,idc)=kstart+1
          labbr(idkey,idc)=kstr-kstart
c          write(6,*) idc,idkey
c     1       ,'['//astrings(kstart+1:kstr)//']'
        else
          kstr=kstart   ! discard the NULL unit abbreviation
        endif

      else if(itp.eq.STPS) then
        if(cod.eq.'050') then
          read(cbuf,"(a5)") stncall
          io=40
          call getstr(cbuf,io,mess,lmess)
          read(cbuf(io+1:io+3),"(i3)") netid
          if(kstr.ne.0) netid=kabbrmap(netid,DICTGC)

c         do i=1,nstnc
c           if(stncall.eq.stncalls(i)) then
c             if(netid.ne.netids(i)) then
c               pause 'eatblock: inconsistent network ids'
c             endif
c             goto 209
c           endif
c         enddo
          nstnc=1+nstnc
          if(nstnc.gt.MXSTNC) then
            pause 'eatblock: too many stations'
          else
            stncalls(nstnc)=stncall
            netids(nstnc)=netid
            iadchnc(nstnc)=nchnc
            iadchnc(nstnc+1)=nchnc
          endif
c 209     continue

          nstblocks=0
          kad=1
          mode=1
        else if(cod.eq.'051') then
          mode=1

        else if(cod.eq.'052') then
          read(cbuf,"(a2,a3,a4)") chnlocid,chnname,chnsub
c         write(6,*) 'eatblock:'//chnlocid//':'//chnname//':'//chnsub//':'
          io=12
          do while(cbuf(io:io).ne.'~')
            io=io+1
          enddo
          io=io+49
          read(cbuf(io+1:io+4),"(i4)") idkey

          io=io+6
          read(cbuf(io+1:io+10),"(e10.5)") srate
          io=io+24
          io=io+1
          do while(cbuf(io:io).ne.'~')
            io=io+1
          enddo
          call gettim(cbuf,io,iiy,iid,iih,iim,ffs)
          call timsec(iiy,iid,iih,iim,ffs,itim1(1))
          it=10000*amod(ffs,1.0)
          itim1(2)=ishft(it,16)
          call gettim(cbuf,io,iiy,iid,iih,iim,ffs)
          call timsec(iiy,iid,iih,iim,ffs,itim2(1))
          it=10000*amod(ffs,1.0)
          itim2(2)=ishft(it,16)






          idc=DICTFT
          if(kabbr(idkey,idc).ne.0) then
            i1=kabbr(idkey,idc)
            i2=i1+labbr(idkey,idc)-1
            lfmt=0
            io=i1+7
            do while(astrings(io:io).ne.'~')
              io=io+1
            enddo
            io=io+4
            do ii=1,nknown
              if(astrings(io+1:i2).eq.fknown(iknow(ii):iknow(ii+1)-1))  then
                if(lfmt.eq.0) then
                  lfmt=locfkn(ii)
                else
                  pause 'eatblock: duplicate known format'
                endif
              endif
            enddo
            if(lfmt.eq.0) then
              write(6,*) 'eatblock: *** Unknown format ***'
              call wrtblk(6,astrings(i1:i1+2),STPA,astrings(i1+7:i2),1,0)
              ierr=9
            endif
          else
            pause 'eatblock: format unknown'
          endif
          ichnlfmt=lfmt

          ichnrate=icrate(srate)



c Establish correspondence between station/channel and rate/format
          nchnc=1+nchnc
          if(nchnc.gt.MXCHNC) pause 'eatblock: too many channels'
          iadchnc(nstnc+1)=nchnc
          krates(nchnc)=ichnrate
          lfmts(nchnc)=ichnlfmt
          chnids(nchnc)=chnlocid//chnname
          itim1052(1,nchnc)=itim1(1)
          itim1052(2,nchnc)=itim1(2)
          itim2052(1,nchnc)=itim2(1)
          itim2052(2,nchnc)=itim2(2)


          
          
          nchblocks=0
          kad=iadstblock(nstblocks+1)
          mode=2
        else
          mode=2
        endif
        if(mode.eq.1) then
          nstblocks=nstblocks+1
          if(nstblocks.gt.MXSTNBLKS) pause 'too many station blockettes'
          iadstblock(nstblocks)=kad
c          write(6,*) 'stdize  in:',cod//'    '//cbuf(1:inum)
          tempstr=cod//'    '//cbuf(1:inum)
          call stdize(tempstr(1:inum+7),STPS
     1      ,strings(kad+1:MXSTRINGS),lblock)
c          write(6,*) 'stdize out:',strings(kad+1:kad+lblock)
          kad=kad+lblock
          iadstblock(nstblocks+1)=kad
          if(kad.gt.MXSTRINGS) pause 'eatblock: strings exceeded'
          do i=1,ngstdi
            igotstdstn(i,nstblocks)=igotstd(i)
          enddo
          do i=1,ngstdk
            kgotstdstn(i,nstblocks)=kgotstd(i)
          enddo
          do i=1,ngstdt
            tgotstdstn(i,nstblocks)=tgotstd(i)
          enddo
        else if(mode.eq.2) then
          nchblocks=1+nchblocks
          if(nchblocks.gt.MXCHNBLKS) pause 'too many channel blockettes'
          iadchblock(nchblocks)=kad
c          write(6,*) 'stdize  in:',cod//'    '//cbuf(1:inum)
          tempstr=cod//'    '//cbuf(1:inum)
          call stdize(tempstr(1:inum+7),STPS
     1      ,strings(kad+1:MXSTRINGS),lblock)
c          write(6,*) 'stdize out:',strings(kad+1:kad+lblock)
          kad=kad+lblock
          iadchblock(nchblocks+1)=kad
          if(kad.gt.MXSTRINGS) pause 'eatblock: strings exceeded'
          do i=1,ngstdi
            igotstdchn(i,nchblocks)=igotstd(i)
          enddo
          do i=1,ngstdk
            kgotstdchn(i,nchblocks)=kgotstd(i)
          enddo
          do i=1,ngstdt
            tgotstdchn(i,nchblocks)=tgotstd(i)
          enddo

        endif
          
      else if(itp.eq.STPT) then
        if(cod.eq.'074') then
          if(nmsegs.eq.0) then
            io=0
            stncall=cbuf(io+1:io+5)
            io=io+5
            chnlocid=cbuf(io+1:io+2)
            io=io+2
            chnname=cbuf(io+1:io+3)
            io=io+3

             
          else if(cbuf(1:10).ne.stncall//chnlocid//chnname) then
            write(6,'(a)') cbuf(1:10)
            write(6,'(a)') stncall//chnlocid//chnname
            pause 'eatblock: wrong channel in blockette 074'
            nmsegs=0
          endif


          nmsegs=nmsegs+1
          if(nmsegs.gt.MXSEGS) pause 'eatblocks: too many segments'
          io=10

          call gettim(cbuf,io,jy,jd,ih,im,fs)
          call timsec(jy,jd,ih,im,fs,itimseg(1,nmsegs))
          iit=10000*amod(fs,1.0)
          itimseg(2,nmsegs)=ishft(iit,16)

          if(ifmultf.ne.0) then
            read(cbuf(io+1:io+6),"(z2,i4)") ifl1,irc1
            if(and(ifl1,z'ffffff00').ne.0.or.and(irc1,z'ff800000').ne.0)
     1        pause 'eatblock: file or record out of range'
            indrec=or(ishft(ifl1,23),irc1)
          else
            read(cbuf(io+1:io+6),"(i6)") irc1
            indrec=irc1
          endif
          io=io+6
          itimseg(6,nmsegs)=indrec
          io=io+2
          call gettim(cbuf,io,jy,jd,ih,im,fs)
          call timsec(jy,jd,ih,im,fs,itimseg(3,nmsegs))
          iit=10000*amod(fs,1.0)
          itimseg(4,nmsegs)=ishft(iit,16)

          if(ifmultf.ne.0) then
            read(cbuf(io+1:io+6),"(z2,i4)") ifl2,irc2
            if(ifl2.ne.ifl1) pause 'eatblock: segment ends in different file'
            if(and(irc2,z'ff800000').ne.0) pause 'eatblock: record out of range'
          else
            read(cbuf(io+1:io+6),"(i6)") irc2
          endif
          io=io+6
          itimseg(7,nmsegs)=irc2-irc1+1
          itimseg(5,nmsegs)=idvolm
          io=io+2

          if(nmsegs.eq.1) then
 876        netid=0
            do ii=1,nstnc
              if(stncalls(ii).eq.stncall) then
                isthere=0
                do jj=iadchnc(ii)+1,iadchnc(ii+1)
c                 write(6,'(a)') 'eatblock: '
c    1                 //stncall//chnlocid//chnname//'--'//chnids(jj)
                  if(chnids(jj).eq.chnlocid//chnname) then
                    isthere=1
                  endif
                enddo
                if(isthere.ne.0) then
                  if(netid.eq.0.or.netid.eq.netids(ii)) then
                    netid=netids(ii)
                  else
                    write(6,*) 'eatblock:  Warning: ambiguous netid:'
     1                ,stncall,'  netids: ',netid,netids(ii)
                    netid=netids(ii)
                  endif
                endif
              endif
            enddo

            if(netid.eq.0) then
              write(6,'(a)') 'eatblock: netid not found for data piece: '
     1           //stncall//chnlocid//chnname
              chnnmsv=chnname
              if(chnname(3:3).eq.'N') chnname(3:3)='2'
              if(chnname(3:3).eq.'E') chnname(3:3)='3'
              if(chnname.ne.chnnmsv) then
                write(6,'(a)') 'eatblock: Trying:'//chnlocid//chnname
                goto 876
              else
                write(6,'(a)') 'eatblock: Data piece ignored'
                nmsegs=nmsegs-1
                goto 888
              endif
            endif
          endif



          if(nmsegs.eq.1.or.jchfmt.eq.-1
     1                    .or.itcmp(itimseg(1,nmsegs),itval1).lt.0
     1                    .or.itcmp(itimseg(1,nmsegs),itval2).ge.0) then
            ichrate=-1
            jchfmt=-1
            do ii=1,nstnc
              if(stncalls(ii).eq.stncall) then
                do jj=iadchnc(ii)+1,iadchnc(ii+1)
                  if(chnids(jj).eq.chnlocid//chnname) then
                    if(itcmp(itimseg(1,nmsegs),itim1052(1,jj)).ge.0
     1                       .and.itcmp(itimseg(1,nmsegs),itim2052(1,jj)).lt.0) then
                      if((ichrate.eq.-1.and.jchfmt.eq.-1)
     1                    .or.(ichrate.eq.krates(jj).and.jchfmt.eq.lfmts(jj))) then
                        ichrate=krates(jj)
                        jchfmt=lfmts(jj)
                        itval1(1)=itim1052(1,jj)
                        itval1(2)=itim1052(2,jj)
                        itval2(1)=itim2052(1,jj)
                        itval2(2)=itim2052(2,jj)
                      else
                        write(6,*) stncalls(ii)//chnids(jj)
                        rate1=1.d0/dsmpin(ichrate)
                        rate2=1.d0/dsmpin(krates(jj))
                        write(6,"('Rate was: ',1pe10.4,'  Now: ',e10.4)") rate1, rate2
                        write(6,"('Local format was: ',i2,'  Now: ',i2)") jchfmt,lfmts(jj)
               
                        pause 'eatblock: ambiguous rate//format info'
                      endif
                    endif
                  endif
                enddo
              endif
            enddo

          endif

        else
        endif
        lfmtseg(nmsegs)=jchfmt
        ichrseg(nmsegs)=ichrate
  888   continue
      else
        pause 'eatblock: unknown type'
      endif
      return
      end
