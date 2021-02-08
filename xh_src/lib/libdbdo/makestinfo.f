c-------------------------------------------------------------------------

      subroutine makestinfo(cbuf,irefsi,numsubs,rbig,ibig)
      character*(*) cbuf
      dimension rbig(0:*),ibig(0:*)
      include 'seedparam.h'
      include 'seedtrees.h'
      include 'gramblock.h'
      logical getabr
      character*3 cod
      character*100 str100

      ibig(OGSTIRF)=irefsi

      io=0
      cod=cbuf(io+1:io+3)
      if(cod.ne.'050') pause 'makestinfo: blockkette 050 expected'
      io=io+3
      read(cbuf(io+1:io+4),"(i4)") inum
      io=io+4
      call loadchr(ibig(OGSTNAM),LGSTNAM,cbuf(io+1:io+5))   
      io=io+5
      read(cbuf(io+1:io+10),"(e10.6)") rbig(OGSTLAT)
      io=io+10
      read(cbuf(io+1:io+11),"(e11.6)") rbig(OGSTLON)
      io=io+11
      read(cbuf(io+1:io+7),"(e7.1)") rbig(OGSTELV)
      io=io+7
      io=io+7
      call getstr(cbuf,io,str100,lstr100)
      call loadchr(ibig(OGSTSIT),LGSTSIT,str100(1:lstr100))
      read(cbuf(io+1:io+3),"(i3)") inetac
      io=io+3
      if(.not.getabr(itabr(DICTGC),inetac,str100,lstr100)) pause 'getgram: net id not found'
      call loadchr(ibig(OGSTNET),LGSTNET,str100(11:lstr100-1))
c here we should process station comments -- but for now
      ibig(OGSTNCM)=0
      ibig(OGSTCMO)=-1
      ibig(OGSTNCH)=numsubs
      return
      end
