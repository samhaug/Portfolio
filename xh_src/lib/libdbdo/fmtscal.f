c----------------------------------------------------------
      subroutine fmtscal(iar,str,lstr)
      integer iar(*)
      character*(*) str


      parameter (MXDUMP=1500)
      character*2 prefx
      character*32 dumpfls
      common/fmtcommun/itypcl,ndump,ldumpfls(MXDUMP),dumpfls(MXDUMP),ncrefs,icrefs(MXDUMP),prefx

      if(itypcl.eq.0) then
        write(str,"(a2,'.',i10)") prefx,iar(1)
        lstr=13
        ip=0
        do j=1,lstr
          if(str(j:j).ne.' ') then
            ip=ip+1
            str(ip:ip)=str(j:j)
          endif
        enddo
        lstr=ip
        lstr1=lstr
      else if(itypcl.eq.1) then
        write(str,"(a2,'.',i10,'(',i10,')')") prefx,iar(1),iar(2)
        lstr=25
        ip=0
        do j=1,lstr
          if(str(j:j).ne.' ') then
            ip=ip+1
            str(ip:ip)=str(j:j)
          endif
        enddo
        lstr=ip
        lstr1=1
        do while(str(lstr1:lstr1).ne.'(')
          lstr1=lstr1+1
        enddo
        lstr1=lstr1-1
      else if(itypcl.eq.2) then
        mask=z'007fffff'
        write(str,"(a2,'.',i10,'(',i5,':',i10,')')")
     1      prefx,iar(1),ishft(iar(2),-23),and(iar(2),mask)
        lstr=31
        ip=0
        do j=1,lstr
          if(str(j:j).ne.' ') then
            ip=ip+1
            str(ip:ip)=str(j:j)
          endif
        enddo
        lstr=ip
        lstr1=1
        do while(str(lstr1:lstr1).ne.'(')
          lstr1=lstr1+1
        enddo
        lstr1=lstr1-1

      endif
      if(ndump.ge.0) then
        do i=1,ndump
          if(str(1:lstr1).eq.dumpfls(i)) goto 99
        enddo
        ndump=1+ndump
        if(ndump.le.MXDUMP) then
          dumpfls(ndump)=str(1:lstr1)
          ldumpfls(ndump)=lstr1
        endif
   99   continue
      endif
      if(ncrefs.ge.0) then
        if(str(1:3).eq.'cr.') then
          read(str(4:lstr),*) ic
          do i=1,ncrefs
            if(ic.eq.icrefs(i)) goto 98
          enddo
          ncrefs=ncrefs+1
          if(ncrefs.le.MXDUMP) then
            icrefs(ncrefs)=ic
          endif
        endif
   98   continue
      endif
      return
      end
