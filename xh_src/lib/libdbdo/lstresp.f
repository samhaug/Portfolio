c----------------------------------------------------------

      subroutine lstresp(iopt,ierr)

      parameter (MXDUMP=1500)
      character*2 prefx
      character*32 dumpfls
      common/fmtcommun/itypcl,ndump,ldumpfls(MXDUMP),dumpfls(MXDUMP),ncrefs,icrefs(MXDUMP),prefx
      character*16 str

      if(ncrefs.gt.MXDUMP) then 
        ncrefs=MXDUMP
        ifover=1
      else
        ifover=0
      endif

      call verbsave(isave)
      call verbosity(2)
      do ir=1,ncrefs
        write(str,'(''cr.'',i10)') icrefs(ir)
        ip=0
        do i=1,13
          if(str(i:i).ne.' ') then
            ip=ip+1
            str(ip:ip)=str(i:i)
          endif
        enddo
        write(6,'(a)') 'Response: '//str(1:ip)
        call tryresp(icrefs(ir),iopt,0,istage,freq1,freq2,freqstep)
      enddo
      call verbosity(isave)

      if(ifover.ne.0) write(6,*) 'lstresp: *** Warning *** Not all responses listed'
      return
      end
