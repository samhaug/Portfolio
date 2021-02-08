c --------------------------------------------------------------------------

      subroutine readphs(mod,lmd,phs,lph,hdepmx)

      parameter(MXDEP=50)
      parameter(MXDEL=250)
      common/phstmp/delta(MXDEL,MXDEP),ttime(MXDEL,MXDEP),rayp(MXDEL,MXDEP),
     1              deps(MXDEP),ndel,ndep
      common/phsspl/tspln(MXDEL,MXDEP),pspln(MXDEL,MXDEP)
      common/delmnmx/delmnarr(MXDEP),delmxarr(MXDEP),rmnspln(MXDEP),rmxspln(MXDEP)

      character*(*)phs,mod
      character*80 ifl

      ifl='/geo/home/jritsema/Utils/phstimes/'//phs(1:lph)//'.phs.'//mod(1:lmd)
      open(521,file=ifl,form='unformatted',status='old',err=1000)

      read(521) ndel,ndep,(deps(k),k=1,ndep)
c     write(6,*) ndel,ndep,(deps(k),k=1,ndep)
      do i=1,ndep
       read(521,end=10) (delta(k,i),k=ndel,1,-1),(ttime(k,i),k=ndel,1,-1),(rayp(k,i),k=ndel,1,-1)
c      do k=1,ndel
c       write(200+i,*) delta(k,i),ttime(k,i),rayp(k,i)
c      enddo
       call spline(delta(1,i),ttime(1,i),ndel,1.e31,1.e31,tspln(1,i))
       call spline(delta(1,i),rayp(1,i),ndel,1.e31,1.e31,pspln(1,i))

       delmxarr(i)=delta(ndel,i)
       delmnarr(i)=delta(1,i)
c      write(6,*) deps(i),delmnarr(i),delmxarr(i)
      enddo

c     if deltas and t's are not known for all depths then reset ndep
c     this is a quick fix to deal with PS phases that do not exists
c     for deep sources
10    continue
      if(i.ne.ndep) then
c      write(6,*) 'Warning: delta-t not available for all specified depths'
c      write(6,*) 'Restricting interpolation to depmax = ',deps(i-1)
       ndep=i-1
      endif

      close(521)

c     spline max and minimum distances
      call spline(deps,delmnarr,ndep,1.e31,1.e31,rmnspln)
      call spline(deps,delmxarr,ndep,1.e31,1.e31,rmxspln)

      hdepmx=deps(ndep)

      return

1000  stop 'appropriate phase file not found'
 
      end

c --------------------------------------------------------------------------

      subroutine getphsp(del,hdep,p)

      parameter(MXDEP=50)
      parameter(MXDEL=250)
      common/phstmp/delta(MXDEL,MXDEP),ttime(MXDEL,MXDEP),rayp(MXDEL,MXDEP),
     1              deps(MXDEP),ndel,ndep
      common/phsspl/tspln(MXDEL,MXDEP),pspln(MXDEL,MXDEP)
      dimension ptmp(MXDEP),y3(MXDEP)

      do i=1,ndep
c      write(6,*) del
       call splint(delta(1,i),rayp(1,i),pspln(1,i),ndel,del,ptmp(i))
       do j=1,ndel
c       write(6,*) delta(j,i),rayp(j,i),pspln(j,i)
       enddo
c      write(6,*) deps(i),ptmp(i)
      enddo

      call spline(deps,ptmp,ndep,1.e31,1.e31,y3)
      call splint(deps,ptmp,y3,ndep,hdep,p)

      write(6,11) del,p
11    format('          epc dist ',f8.3,' ray param ',f8.3)

      end

c  --------------------------------------------------------------------------
 
      subroutine getphst(del,hdep,t)
 
      parameter(MXDEP=50)
      parameter(MXDEL=250)
      common/phstmp/delta(MXDEL,MXDEP),ttime(MXDEL,MXDEP),rayp(MXDEL,MXDEP),
     1              deps(MXDEP),ndel,ndep
      common/phsspl/tspln(MXDEL,MXDEP),pspln(MXDEL,MXDEP)
      dimension ttmp(MXDEP),y3(MXDEP)

      do i=1,ndep
       call splint(delta(1,i),ttime(1,i),tspln(1,i),ndel,del,ttmp(i))
      enddo
 
      call spline(deps,ttmp,ndep,1.e31,1.e31,y3)
      call splint(deps,ttmp,y3,ndep,hdep,t)
 
      end

c ------------------------------------------------------------------

      subroutine getphsmnmx(hdep,delmn,delmx)

      parameter(MXDEP=50)
      parameter(MXDEL=250)
      common/phstmp/delta(MXDEL,MXDEP),ttime(MXDEL,MXDEP),rayp(MXDEL,MXDEP),
     1              deps(MXDEP),ndel,ndep
      common/delmnmx/delmnarr(MXDEP),delmxarr(MXDEP),rmnspln(MXDEP),rmxspln(MXDEP)

      if(hdep.gt.deps(ndep)) then
       write(6,*) hdep,deps(ndep)
       stop 'getphsmnmx: depth outside validity of interpolation'
      endif

      call splint(deps,delmnarr,rmnspln,ndep,hdep,delmn)
      call splint(deps,delmxarr,rmxspln,ndep,hdep,delmx)

      end

