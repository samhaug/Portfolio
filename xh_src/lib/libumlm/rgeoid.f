c---------------------------------------------------------------------
      subroutine rgeoid(lu,file,lmgeoid,geocof)
      character*(*) file
      dimension geocof(1)
      fac1=6371000.*1.e-6
      fac2=fac1*sqrt(4.*3.1415926)
      fac3=fac2*sqrt(2.)
      open(lu,file=file,status='old')
      k=0
   10 read(lu,'(3x,i1,3x,i1,2x,2f7.3)',end=20) l,m,val1
      lmgeoid=l
      k=k+1
      geocof(k)=val1*fac2
      do i=1,l
        read(lu,'(3x,1x,3x,i1,2x,2f7.3)',end=20) m,val1,val2
        if(mod(m,2).eq.0) then
          fac=fac3
        else
          fac=-fac3
        endif
        k=k+1
        geocof(k)=val1*fac
        k=k+1
        geocof(k)=val2*fac
      enddo
      goto 10
   20 if(k.ne.(lmgeoid+1)**2) pause 'error in rgeoid'
      close(lu)
      return
      end
