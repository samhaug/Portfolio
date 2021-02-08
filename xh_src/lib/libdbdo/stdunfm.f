      subroutine stdunfm(cbuf)
      character*(*) cbuf
      include 'seeddefs.h'
      include 'seedtrees.h'
      character*3 cod
      character*200 mess
      character*20 form
      character*1 fmlett
      logical getabr
      character*52 instrt
      common/instumnt/linstrt,instrt
      lcbuf=len(cbuf)
      lb=0
  100 lb0=lb
      cod=cbuf(lb+1:lb+3)
      lb=lb+3
      itp=ifindtyp(cod,indcd)
      read(cbuf(lb+1:lb+4),'(i4)') inum
      lb=lb+4
      lb1=lb0+inum
      ient=0
      k=0
   10 continue
      call getfield(cod,itp,cbuf(lb0+8:lb1),k,indcd,ient,ileve,mess,lmess,icdstat)
      if(ient.lt.0) goto 20
      if(ient.eq.0) goto 10
      fmlett=fstr(ient,indcd)(1:1)
      if(fmlett.eq.'t'.or.fmlett.eq.'s') lmess=lmess+1
      itest=(entstat(ient,indcd)/MXDICTS)*MXDICTS
      if(itest.eq.LOOKUP) then
        idc=entstat(ient,indcd)-LOOKUP
        if(idc.eq.DICTUT.or.idc.eq.DICTFT) then
          form='('//fstr(ient,indcd)//')'
          read(mess(1:lmess),form) idkey
          if(idc.eq.DICTUT) then
            idkey=locunc(idkey)
          else
            idkey=locfmc(idkey)
          endif
          write(mess(1:lmess),form) idkey
          do i=1,lmess
            if(mess(i:i).eq.' ') mess(i:i)='0'
          enddo
          cbuf(lb+1:lb+lmess)=mess(1:lmess)
        else if(idc.eq.DICTGC) then
          read(mess(1:lmess),*) idkey
          if(.not.getabr(itabr(DICTGC),idkey,mess,lmes)) pause 'stdunfm: generic not found'
          instrt=mess(11:lmes-1)
          linstrt=lmes-11
        endif
      endif
      lb=lb+lmess
      goto 10

   20 continue
      if(lb.lt.lcbuf) goto 100
      return
      end

