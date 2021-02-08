
c---------------------------------------------------------------
      subroutine gheader0(jbuf,iy,id,ih,im,fs,nsamp,smpin,ibytdta)
      include 'seedparam.h'
      character*4 tpfmt
      common/vlprm/idvol,tpfmt,itpfmt
      integer*2 jbuf(*)
      dimension ibit(8)
      double precision smpin
      character*5 str5
      character*2 str2
      character*3 str3
      if(itpfmt.eq.TPFSEED) then
        call seedhdr(jbuf,str5,str2,str3,iy,id,ih,im,fs
     1  ,nsamp,smpin,iblks,corr,iflgs,ibytdta)
cxy      write(6,*) str5,str2//str3,nsamp,'  -- from gheader0'
      else if(itpfmt.eq.TPFNDTF) then
        call head80(jbuf,idno,iy,id,ih,im,fs,ifmt,nchan,
     1           irate,ibit,nsampl)

        nsamp=nsampl/nchan
        smpin=1.d0/irate
        ibytdta=20
        iy=1900+iy
      else
        pause 'gheader: unsupported tape format'
      endif
      return
      end
