c-----------------------------------------------------
      subroutine getblockb(code,cod,inum,cbuf,maxch,itp)
      include 'seedtab.h'           
c! we need to know date to implement a fix
c! on 02/13/88 (NWAO SPZ)
c!    02/14/88 (NWAO SPZ)
c!    02/29/88 (TATO SPZ)
c!    03/01/88 (TATO SPZ)
c!    03/16/88 (NWAO SPZ)
c!    07/28/88 (IPAS BZ1, BN1, BE1)
      character*(*) code,cod
      character*(*) cbuf
      character*4 cnum
      character*1 str1
      character*2 str2
      logical skip
   10 call getbytes(1,str1,itp)
      if(itp.eq.0) return
      if(itp.ne.5) then
        if(str1.eq.' ') then
          call bflush
          goto 10
        else
          call getbytes(2,str2,itp)
          cod=str1//str2
        endif
        if(code.ne.'   '.and.cod.ne.code)
     1     pause 'expected blockette not found'
        call getbytes(4,cnum,itp)
        if(iyear1.eq.1988.and.jday1.eq.210.and.cnum.eq.'NMO ') then
          inum=7+Z'07D3'   
c! fix for tape of 7/28/88
          skip=.true.
        else
          read(cnum,"(i4)") inum
          skip=.false.
        endif
        if(inum.eq.3399.and.iyear1.eq.1988.and.jday1.eq.41) inum=33999
        if(inum.eq.3392.and.iyear1.eq.1988.and.jday1.eq.45) inum=33921
        if(inum.eq.3271.and.iyear1.eq.1988.and.jday1.eq.57) inum=32712
        if(inum.eq.3396.and.iyear1.eq.1988.and.jday1.eq.61) inum=33960
        if(inum.eq.2916.and.iyear1.eq.1988.and.jday1.eq.73) inum=29163
        if(inum.eq.2460.and.iyear1.eq.1988.and.jday1.eq.210) inum=24601
        if(inum.eq.2871.and.iyear1.eq.1988.and.jday1.eq.210) inum=28717
        if(inum.eq.2907.and.iyear1.eq.1988.and.jday1.eq.210) inum=29076
        inum=inum-7
        if(inum.gt.maxch.or.skip) then
          call skipbytes(inum)
          inum=0
          write(6,"('blockette ',a3,'  too long -- skipped')") cod
        else
          call getbytes(inum,cbuf,itp)

        endif
      else
        cod='   '   
c! data record
        inum=0
      endif
      return
      end
