c--------------------------------------
      subroutine ldget(req,gflag,gram,ifstat,iflap,ierr)
      character*2 gflag
      character*(*) gram,req
      include 'gramdb.h'
      include '../libdb/dblib.h'
C     dimension rbig(0:1)
C     equivalence (ibig,rbig)
      character*5 stn
      character*5 chn
      character*200 line
      integer opengram
      character*200 reqi

      parameter(MXDFVOL=15)
      character*80 dfvols
      character*60 dfnames
      common/cmdfvols/ndfvol,idfvols(MXDFVOL),dfvols(MXDFVOL),dfnames(MXDFVOL)
      common/vlprm/idvol,tpfmt,itpfmt

      lreq=istlen(req)

      lu=77
      open(lu,file=req,status='old',iostat=ioerr)
      if(ioerr.ne.0) then
        write(6,*) 'Unable to open request file'
        ierr=9
        return
      endif
      rewind lu

      call balloc(1,ioff)
      numr=0
      ndfvol=0
  100 read(lu,"(a200)",end=99) line
      if(line(1:9).eq.'#Volume :') then
        read(line(11:16),'(i6)')  ivol
        isaw=0
        i=0
        do while(isaw.eq.0.and.i.lt.ndfvol)
          i=i+1
          if(idfvols(i).eq.ivol) isaw=1
        enddo
        if(isaw.eq.0) then
          ndfvol=ndfvol+1
          idfvols(ndfvol)=ivol
          if(ndfvol.gt.MXDFVOL) pause 'ldget: too many volumes'
          ip=17
          do while(line(ip:ip).ne.'''')
            ip=ip+1
          enddo
          i1=0
          ip=ip+1
          do while(line(ip:ip).ne.'''')
            i1=i1+1
            dfvols(ndfvol)(i1:i1)=line(ip:ip)
            ip=ip+1
          enddo
          do i=i1+1,len(dfvols(ndfvol))
            dfvols(ndfvol)(i:i)=' '
          enddo
          ip=ip+1
          do while(line(ip:ip).ne.'''')
            ip=ip+1
          enddo
          i2=0
          ip=ip+1
          do while(line(ip:ip).ne.'''')
            i2=i2+1
            dfnames(ndfvol)(i2:i2)=line(ip:ip)
            ip=ip+1
          enddo
          do i=i2+1,len(dfnames(ndfvol))
            dfnames(ndfvol)(i:i)=' '
          enddo
  
          write(6,'(a)') 'ldget: '//line(11:16)//' '
     1     //dfvols(ndfvol)(1:i1)//' '//dfnames(ndfvol)(1:i2)
        endif
          
      else if(line(1:2).eq.gflag) then
        read(line,"(2x,1x,i6,1x,i3,1x,i6
     1           )",end=99)
     1            ivol,ifil,irec

        call balloc(53,ia)
        ibig(ia)=ivol
        ibig(ia+1)=ifil
        ibig(ia+2)=irec
        read(line,"(50a4)") (ibig(ia+k),k=3,52)
        numr=numr+1
      endif
      goto 100
   99 continue
      call balloc(numr,iind)
      call balloc(53,iwrk)
      call alphabr(ibig(ioff+1),53,numr,1,3,53,ibig(iind),ibig(iwrk))
      open(78,file=reqi(1:lreq)//'.ord')
      io=ioff
      do i=1,numr
        write(line,"(50a4)") (ibig(io+j),j=4,53)
        lline=istlen(line)
        write(78,"(200a1)") (line(j:j),j=1,lline)
        io=io+53
      enddo
      rewind 78
      call dalloc(53,iwrk)
      call dalloc(numr,iind)
      call dalloc(53*numr+1,ioff)

      iadgtr=opengram(gram,ifstat,iflap,ierr)
         call balloc(1,ixx)
cxy      write(6,*) 'after opengram',iadgtr,'mem=',ixx
         call dalloc(1,ixx)
      if(ierr.ne.0) then
        close(lu)
        return
      endif
      do i=1,numr

        read(78,"(2x,1x,i6,1x,i3,1x,i6,1x,i6,1x,1x
     1           ,i3,1x,a5,1x,1x,a5,1x
     1           ,1x,e10.4,1x,i2
     1           ,1x,i4,1x,i3,1x,i2,1x,i2,1x,f6.3
     1           ,1x,1x,i4,1x,i3,1x,i2,1x,i2,1x,f6.3
     1           ,1x,i4,1x,i3,1x,i2,1x,i2,1x,f6.3,1x
     1           ,1x,i4,1x,i3,1x,i2,1x,i2,1x,f6.3
     1           )",end=99)
     1            ivol,ifil,irec,nrecs
     1           ,inet,stn,chn,hertz,lfmt
     1           ,jyl,jdl,ihl,iml,fsecl
     1           ,jyi1,jdi1,ihi1,imi1,fseci1
     1           ,jyi2,jdi2,ihi2,imi2,fseci2
     1           ,jyk,jdk,ihk,imk,fseck

         call balloc(1,ixx)
cxy         write(6,*) 'before retrv mem=',ixx
         call dalloc(1,ixx)
        call rtrv(iadgtr,ivol,ifil,irec,nrecs,inet,stn,chn,hertz,lfmt
     1           ,jyl,jdl,ihl,iml,fsecl
     1           ,jyk,jdk,ihk,imk,fseck
     1           ,jyi1,jdi1,ihi1,imi1,fseci1
     1           ,jyi2,jdi2,ihi2,imi2,fseci2
     1           ,ierr)
         call balloc(1,ixx)
cxy      write(6,*) 'after retrv mem=',ixx
         call dalloc(1,ixx)

      enddo
      call closfl(5,iostat)
      idvol=-1
      close(78)
      call cunlink(reqi(1:lreq)//'.ord\0',ires,ierrno)
      call balloc(1,ixx)
cxy   write(6,*) 'calling closegram',iadgtr,'mem=',ixx
      call dalloc(1,ixx)

      call closegram(iadgtr)
cxy   write(6,*) 'closegram through'
      close(lu)
      return
      end
