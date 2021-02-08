c---------------------------------------------------------------
      subroutine gsetup1(lu,lumes,ierr)
      include 'seedparam.h'
      include 'seedbuf.h'
      character*4 tpfmt
      common/vlprm/idvol,tpfmt,itpfmt
      if(itpfmt.eq.TPFSEED) then
        call setup1(lu,lumes,ierr)
      else if(itpfmt.eq.TPFNDTF.or.itpfmt.eq.TPFSROF.or.itpfmt.eq.TPFHGLF) then
        lut=lu
        lrec=2000
        lrech=lrec/2
        nlrblk=1
        igot1=0
        igot2=0
      else
         pause 'gsetup1: Unsupported tape format'
      endif
      return
      end
