

 

c-----------------------------------------------------------------------
      subroutine putblockb(cod,inum,cbuf,itp,iflush)
      character*(*) cod
      character*(*) cbuf
      character*4 cnum
   10 call putbytes(3,cod,itp,1,iflush)
      write(cnum,"(i4)") inum+7
      do i=1,4
        if(cnum(i:i).eq.' ') cnum(i:i)='0'
      enddo
      call putbytes(4,cnum,itp,0,0)
      call putbytes(inum,cbuf,itp,0,0)
      return
      end
