c --------------------------------------------------------------------------

      subroutine getpt(mod,lmd,phs,lph,del,hdep,fp,ftime)

      parameter(MXDEP=50)
      parameter(MXDEL=250)
      dimension deps(MXDEP),time(MXDEP),y3(MXDEP),p(MXDEP)
      dimension delta(MXDEL),ttime(MXDEL),rayp(MXDEL),y2(MXDEL)
      character*(*)phs,mod
      character*80 ifl

      ifl='/geo/home/jritsema/Utils/phstimes/'//phs(1:lph)//'.phs.'//mod(1:lmd)
      open(21,file=ifl,form='unformatted',status='old',err=1000)

      read(21) ndel,ndep,(deps(k),k=1,ndep)
      do i=1,ndep
       read(21) (delta(k),k=ndel,1,-1),(ttime(k),k=ndel,1,-1),(rayp(k),k=ndel,1,-1)
       call spline(delta,ttime,ndel,1e32,1e32,y2)
       call splint(delta,ttime,y2,ndel,del,time(i))
       call spline(delta,rayp,ndel,1e32,1e32,y2)
       call splint(delta,rayp,y2,ndel,del,p(i))
      enddo

      close(21)

      call spline(deps,time,ndep,1e31,1e31,y3)
      call splint(deps,time,y3,ndep,hdep,ftime)
      call spline(deps,p,ndep,1e31,1e31,y3)
      call splint(deps,p,y3,ndep,hdep,fp)

      return

1000  stop 'appropriate phase file not found'

      end

c ------------------------------------------------------------------
