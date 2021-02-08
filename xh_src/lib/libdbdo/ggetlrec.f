

c---------------------------------------------------------------
      subroutine ggetlrec(ifil,ireci)
      include 'seedparam.h'
      include 'seedbuf.h'
      character*4 tpfmt
      common/vlprm/idvol,tpfmt,itpfmt
      if(itpfmt.eq.TPFSEED) then
        call getlrec(ireci)
      else
        irec=ireci
        if(irec.lt.igot1.or.irec.gt.igot2.or.ifil.ne.igotf) then
          call tposn(5,ifil)
          iblock=1+(irec-1)/nlrblk
          nbyts=lrec*nlrblk
          call bffi(lut,1,ibuf,nbyts,j,mgot,iblock)
          if(mgot.lt.nbyts) then
            write(6,*) 'ggetlrec: *** Warning *** short block'
            mgot=nbyts
          endif
          igot1=1+(iblock-1)*nlrblk
          lrgot=mgot/lrec
          igot2=igot1+lrgot-1
          igotf=ifil
          ibyte=0
          i2bias=0
          i4bias=0
        endif
        if(irec.lt.igot1.or.irec.gt.igot2) then
          pause 'ggetlrec: io error?'
        endif
        i2bias=(irec-igot1)*(lrec/2)
        i4bias=i2bias/2
      endif
      return
      end
