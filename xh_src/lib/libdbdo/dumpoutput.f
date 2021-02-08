c----------------------------------------------------------------

      subroutine dumpoutput(gram,ifascii,ifsac,ifseed,ifah,ifahx,ifahx1,prep,time1,time2,iopt,decrate)
      character*(*) gram,prep,time1,time2
      double precision decrate
      include 'gramblock.h'
      include '../libdb/dblib.h'
      integer gramtable,gramnsubs,sggap
      character*200 str
      character*80 ascii,sacnm,seed,ahnm,ahnmx,ahx1
      dimension itim1(2),itim2(2)
      dimension ifexst(LMXCHNL)
      integer opengram
      character*24 time1i,time2i
      time1i=time1
      time2i=time2

      iadgtr=opengram(gram,0,1,ierr)
      if(ierr.ne.0) then
        write(6,'(''dumpoutput: No data'')')
        return
      endif

      lprep=len(prep)
      if(ifseed.gt.0) then
          if(prep(lprep:lprep).ne.'/') then
            seed=prep(1:lprep)//'.seed'
            lseed=lprep+5
          else
            seed=prep(1:lprep)//'seed'
            lseed=lprep+4
          endif
          luseed=-1
          call opnflc(luseed,seed(1:lseed),4,0,0,istat,-1,2)
      else
        lseed=0
      endif

      if(ifascii.gt.0) then
          if(prep(lprep:lprep).ne.'/') then
            ascii=prep(1:lprep)//'.ascii'
            lascii=lprep+6
          else
            ascii=prep(1:lprep)//'ascii'
            lascii=lprep+5
          endif

          lutemp=-1
          call opnflc(lutemp,ascii(1:lascii),4,0,0,kk,-1,2)
          call closfl(lutemp,kk)
          open(77,file=ascii(1:lascii))
      else
        lascii=0
      endif

      if(ifahx1.gt.0) then
          if(prep(lprep:lprep).ne.'/') then
            ahx1=prep(1:lprep)//'.ahx'
            lahx1=lprep+4
          else
            ahx1=prep(1:lprep)//'ahx'
            lahx1=lprep+3
          endif

          luahx1=-1
          call opnflc(luahx1,ahx1(1:lahx1),4,0,0,kk,-1,2)
      else
        lahx1=0
      endif

      if(ifsac.gt.0) then
        sacnm=prep(1:lprep)
        lsacnm=lprep
      else
        lsacnm=0
      endif

      if(ifah.gt.0) then
        ahnm=prep(1:lprep)
        lahnm=lprep
      else
        lahnm=0
      endif

      if(ifahx.gt.0) then
        ahnmx=prep(1:lprep)
        lahnmx=lprep
      else
        lahnmx=0
      endif

      call inttime(time1i//'~',itim1)
      call inttime(time2i//'~',itim2)
      lenbuf=-1

      igtab=gramtable(iadgtr)
      ngram=ibig(igtab+OTNGRAM)

c   Plan the layout of the SEED volume
      if(ifseed.gt.0) then
      endif


      do ig=1,ngram
        nsub=gramnsubs(igtab,ig,ifexst)
        iagram=loadgram(igtab,ig,itim1,itim2,lenbuf,iopt,decrate)
        call sgstation(iagram,str,lstr)
        write(6,"(a)") str(1:lstr)
        do isub=1,nsub
c      write(6,*) 'dumpoutput: isub=',isub,'  ifexst(isub)=',ifexst(isub)
          if(ifexst(isub).ne.0) then
            call sgchannel(isub,iagram,str,lstr)
            write(6,"('\t',a)") str(1:lstr)
c             if(sggap(isub,iagram).eq.0) then
                if(lascii.gt.0) call sgdumpascii(77,isub,iagram)
                if(lsacnm.gt.0) call sgdumpsac(sacnm,lsacnm,isub,iagram)
                if(lahnm.gt.0) call sgdumpah(ahnm,lahnm,isub,iagram)
                if(lahnmx.gt.0) call sgdumpahx(ahnmx,lahnmx,isub,iagram)
                if(lahx1.gt.0) call sgdumpahx1(luahx1,isub,iagram)
                if(lseed.gt.0) call sgdumpseed(luseed,isub,iagram)
c             endif
            endif
        enddo
        call dalloc(ibig(iagram+OGSPACE),iagram)
      enddo

      if(ifseed.gt.0) then
      endif

      call dalloc(ibig(igtab+OTSPACE),igtab)
      call closegram(iadgtr)
      if(ifascii.gt.0) close(77)
      if(ifseed.gt.0) call closfl(luseed,istat)
      if(ifahx1.gt.0) call closfl(luahx1,istat)
      end
