c --------------------------------------------------------------------------

      subroutine readbnc(mod,lmd,phs,lph,nbncchk)

      parameter(MXDEP=30)
      parameter(MXDEL=101)
      parameter(MXBNC=4)
      common/deltmp/delta(MXDEL,MXDEP),delbnc(MXDEL,MXDEP,MXBNC),
     1              deps(MXDEP),ndel,ndep,nbnc
      common/delspl/delspln(MXDEL,MXDEP,MXBNC)

      character*(*)phs,mod
      character*80 ifl

      ifl='/geo/home/jritsema/Utils/phstimes/'//phs(1:lph)//'.bnc.'//mod(1:lmd)
c     write(6,*) 'opening ',ifl
      open(521,file=ifl,form='unformatted',status='old',err=1000)

      read(521) nbnc,ndep,ndel
      if(nbnc.ne.nbncchk) then
       write(6,*) 'phs, nbnc, nbncchk',phs,nbnc,nbncchk
       stop'READBNC: nbncchk.ne.nbnc from bnc file'
      endif

      do i=1,ndep
       read(521) deps(i),(delta(k,i),k=1,ndel)
c      write(6,*) 'deps ',i,deps(i)
       do j=1,nbnc
        read(521) (delbnc(k,i,j),k=1,ndel)

c       write(6,*) delbnc(1,i,j)
c       if(i.eq.15) then
c        write(6,*) ndel
c        do k=1,ndel
c         write(6,*) k,delta(k,i),delbnc(k,i,j)
c        enddo
c       endif

        call spline(delta(1,i),delbnc(1,i,j),ndel,1e32,1e32,delspln(1,i,j))

       enddo
      enddo

      close(111)
      close(521)

      return

1000  stop 'appropriate bounce file not found'
 
      end

c --------------------------------------------------------------------------

      subroutine getbnc(del,hdep,delb)

      parameter(MXDEP=30)
      parameter(MXDEL=101)
      parameter(MXBNC=4)
      common/deltmp/delta(MXDEL,MXDEP),delbnc(MXDEL,MXDEP,MXBNC),
     1              deps(MXDEP),ndel,ndep,nbnc
      common/delspl/delspln(MXDEL,MXDEP,MXBNC)
      dimension ptmp(MXDEP),delb(MXBNC),y3(MXDEP)

      do i=1,MXBNC
       delb(i)=0.
      enddo

      do j=1,nbnc
       do i=1,ndep
        call splint(delta(1,i),delbnc(1,i,j),delspln(1,i,j),ndel,del,ptmp(i))
c       write(6,*) ndel,del,deps(i),ptmp(i)
       enddo

       call spline(deps,ptmp,ndep,1e32,1e32,y3)
       call splint(deps,ptmp,y3,ndep,hdep,delb(j))
      enddo

      end


