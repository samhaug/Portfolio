      subroutine munchbits(in,inp,out,outp,iwd,inum,ifsigned)
      integer*4 in(*),out(*),inp,outp,iwd,inum,ifsigned
      dimension imsk(32)
      data imsk/z'FFFFFFFE',z'FFFFFFFC',z'FFFFFFF8',z'FFFFFFF0',
     1          z'FFFFFFE0',z'FFFFFFC0',z'FFFFFF80',z'FFFFFF00',
     1          z'FFFFFE00',z'FFFFFC00',z'FFFFF800',z'FFFFF000',
     1          z'FFFFE000',z'FFFFC000',z'FFFF8000',z'FFFF0000',
     1          z'FFFE0000',z'FFFC0000',z'FFF80000',z'FFF00000',
     1          z'FFE00000',z'FFC00000',z'FF800000',z'FF000000',
     1          z'FE000000',z'FC000000',z'F8000000',z'F0000000',
     1          z'E0000000',z'C0000000',z'80000000',z'00000000'/
      do i=1,inum
        iend=inp+iwd-1
        i1=mod(iend,32)+1
        iw=iend/32
        nget=min0(i1,iwd)
        inw1=in(iw+1)
        call byswap4(inw1,1)
        ians=ibits(inw1,32-i1,nget)
        if(nget.ne.iwd) then
          inw=in(iw)
          call byswap4(inw,1)
          ians=or(ians,ishft(ibits(inw,0,iwd-nget),nget))
        endif
        if(ifsigned.ne.0.and.btest(ians,iwd-1)) ians=or(ians,imsk(iwd))
        inp=inp+iwd
        outp=outp+1
        out(outp)=ians
      enddo
      return
      end
