c----------------------------------------------------------

      subroutine dumpcal(ierr)

      parameter (MXDUMP=1500)
      character*2 prefx
      character*32 dumpfls
      common/fmtcommun/itypcl,ndump,ldumpfls(MXDUMP),dumpfls(MXDUMP),ncrefs,icrefs(MXDUMP),prefx

      if(ndump.gt.MXDUMP) then 
        ndump=MXDUMP
        ifover=1
      else
        ifover=0
      endif

      if(ndump.gt.0) call show(dumpfls,ldumpfls,ndump,-1,0,ierr)
      if(ifover.ne.0) write(6,*) 'dumpcal: *** Warning *** Not all files dumped'
      return
      end
