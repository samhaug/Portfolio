c---------------------------------------------------------------------
      subroutine stdize(block,itp,block1,lblock)
      character*(*) block,block1
      include 'seeddefs.h'
      include 'seedtrees.h'
      include 'seedcommun.h'
      character*10 form
      character*200 mess
      character*3 cod
      character*1 fmlett
c First map abbreviations
c     write(6,*) 'stdize: stt',itim1vol(1),itim2vol(1),'  ['//block(1:30)
      ngstdt=0
      ngstdi=0
      ngstdk=0
      cod=block(1:3)
      block1(1:7)=cod//'    '
      ient=0
      k=0
      lb=7
      lb0=len(block)
   10 continue
      kl=k
      call getfield(cod,itp,block(8:lb0),k,indcd,ient,ileve,mess,lmess,icdstat)
      if(ient.lt.0) goto 20
      if(ient.eq.0) goto 10
      fmlett=fstr(ient,indcd)(1:1)
      if(fmlett.eq.'t'.or.fmlett.eq.'s') then
        lmess=istlen(mess(1:lmess))
        lmess=lmess+1
        mess(lmess:lmess)='~'
      endif
      itest=(entstat(ient,indcd)/MXDICTS)*MXDICTS
      if(itest.eq.INSERT) then
        do i=1,lmess
          mess(i:i)='0'
        enddo
      else if(itest.eq.LOOKUP) then
        idc=entstat(ient,indcd)-LOOKUP
        read(mess(1:lmess),*) idkey
        ngstdk=1+ngstdk
        if(ngstdk.gt.MXSTDK) pause 'stdize: too many keys extracted'
        kgotstd(ngstdk)=idkey
        if(idkey.ne.0.and.kstr.ne.0) then
          if(kabbrmap(idkey,idc).ne.0) then
            idkey=kabbrmap(idkey,idc)
          else
            pause 'stdize: abbreviation not known'
          endif
        else if(idc.ne.DICTUT) then
          write(6,*) 'stdize: Warning *** zero dict key'
        endif
        form='('//fstr(ient,indcd)//')'
        write(mess(1:lmess),form) idkey
        do i=1,lmess
          if(mess(i:i).eq.' ') mess(i:i)='0'
        enddo
        if(k-kl.ne.lmess) pause 'stdize: string wrong length'
      else if(itest.eq.ISZERO.or.itest.eq.ISGOTN) then
        if(fmlett.eq.'i') then
          read(mess(1:lmess),*) ival
          ngstdi=1+ngstdi
          if(ngstdi.gt.MXSTDI) pause 'stdize: too many ints extracted'
          igotstd(ngstdi)=ival
          if(itest.eq.ISZERO) then
            do i=1,lmess
              mess(i:i)='0'
            enddo
          endif
        else if(fmlett.eq.'s') then
          if(itest.eq.ISZERO) then
            lmess=1
            mess(1:1)='~'
          endif
        else if(fmlett.eq.'t') then
          ngstdt=1+ngstdt
          if(ngstdt.gt.MXSTDT) pause 'stdize: too many times extracted'
          tgotstd(ngstdt)=mess(1:lmess)
          if(itest.eq.ISZERO) then
            lmess=1
            mess(1:1)='~'
          endif
        else
          pause 'stdize: trying to zero wrong type'
        endif
      endif
      block1(lb+1:lb+lmess)=mess(1:lmess)
      lb=lb+lmess

      goto 10
   20 continue






        lblock=lb
        write(block1(4:7),"(i4)") lblock
        do i=4,7
          if(block1(i:i).eq.' ') block1(i:i)='0'
        enddo
c       write(6,*) 'stdize: end',itim1vol(1),itim2vol(1)
        return
        end
