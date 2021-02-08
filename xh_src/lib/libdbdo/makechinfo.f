


c-------------------------------------------------------------------------

        function makechinfo(cbuf,rbig,ibig)
        character*(*) cbuf
        dimension rbig(0:*),ibig(0:*)
        include 'seeddefs.h'
        include 'seedtrees.h'
        include 'gramblock.h'
        character*3 cod
        character*100 str100
        character*52 instrt
        common/instumnt/linstrt,instrt

        io=0
        cod=cbuf(io+1:io+3)
        if(cod.ne.'052') pause 'makechinfo: expecting blockette 052'
        io=io+3
        read(cbuf(io+1:io+4),"(i4)") inum
        io=io+4
        call loadchr(ibig(OGCHLID),1,cbuf(io+1:io+2))
        io=io+2
        call loadchr(ibig(OGCHCID),1,cbuf(io+1:io+3))
c      write(6,'(''makechinfo:'',a)') cbuf(io+1:io+3)
        io=io+3
        read(cbuf(io+1:io+4),"(i4)") ibig(OGCHSUB)
c      write(6,'(''makechinfo: ibig(OGCHSUB)='',i4)') ibig(OGCHSUB)

        io=io+4
        read(cbuf(io+1:io+3),"(i3)") inst
        io=io+3
c       if(.not.getabr(itabr(DICTGC),inst,str100,lstr100)) pause 'getgram: inst not found'
c       call loadchr(ibig(OGCHINS),LGCHINS,str100(11:lstr100-1))
        call loadchr(ibig(OGCHINS),LGCHINS,instrt(1:linstrt))
        call getstr(cbuf,io,str100,lstr100)
        call loadchr(ibig(OGCHOCM),LGCHOCM,str100(1:lstr100))
        read(cbuf(io+1:io+3),"(i3)") iunit
        io=io+3
        ibig(OGCHUNS)=iunit       
        read(cbuf(io+1:io+3),"(i3)") iunit
        io=io+3
        ibig(OGCHUNC)=iunit 
        read(cbuf(io+1:io+10),"(f10.6)") rbig(OGCHLAT)
        io=io+10
        read(cbuf(io+1:io+11),"(f11.6)") rbig(OGCHLON)
        io=io+11
        read(cbuf(io+1:io+7),"(f7.1)") rbig(OGCHELV)
        io=io+7
        read(cbuf(io+1:io+5),"(f5.1)") rbig(OGCHDEP)
        io=io+5
        read(cbuf(io+1:io+5),"(f5.1)") rbig(OGCHAZM)
        io=io+5
        read(cbuf(io+1:io+5),"(f5.1)") rbig(OGCHDIP)
        io=io+5
        read(cbuf(io+1:io+4),"(i4)") iform
        io=io+4
c       ibig(OGCHFMT)=locfmc(iform)
        ibig(OGCHFMT)=iform
        io=io+2
        read(cbuf(io+1:io+10),"(e10.4)") hertz
        io=io+10
        ibig(OGCHKHZ)=icrate(hertz)
        read(cbuf(io+1:io+10),"(e10.4)") rbig(OGCHDRF)
        io=io+10
        io=io+4
        call getstr(cbuf,io,str100,lstr100)
        call gettim(cbuf,io,iyear,jday,ihr,min,fsec)
        call gettim(cbuf,io,iyear,jday,ihr,min,fsec)
        io=io+1
        makechinfo=LGCHBLK
        makechinfo=makechinfo+mod(makechinfo,2)
        return
        end
