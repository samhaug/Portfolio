c---------------------------------------------------------------------
      subroutine  rdcmb(lu,file,lmcmb,cmbcof)
      character*(*) file
      dimension cmbcof(1)
      fac=1000.*1.25336315
      open(lu,file=file,status='old')
      k=0
   10 read(lu,'(3x,i1,3x,i1,2x,2f7.3)',end=20) l,m,val1
      lmcmb=l
      k=k+1
      cmbcof(k)=val1*fac
      do i=1,l
        read(lu,'(3x,1x,3x,i1,2x,2f7.3)',end=20) m,val1,val2
        k=k+1
        cmbcof(k)=val1*fac
        k=k+1
        cmbcof(k)=val2*fac
      enddo
      goto 10
   20 if(k.ne.(lmcmb+1)**2) pause 'error in rdcmb'
      close(lu)
      return
      end
