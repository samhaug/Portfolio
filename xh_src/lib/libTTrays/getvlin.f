      subroutine getvlin(dep,v,dv)

      implicit double precision(a-h,o-z)
      parameter(MXLAY=500)
      common/linmd/depl(MXLAY),vell(MXLAY),nlay

      if(dep.gt.2891) write(6,*) 'WARNING - velocity in outer core!'

      i=1
      ifnd=0
      do while (ifnd.eq.0)
       i=i+1
       if(dep.lt.depl(i).and.dep.ge.depl(i-1)) then
        ifnd=1
        ibt=i
        itp=i-1
        depbt=depl(ibt)
        deptp=depl(itp)
        velbt=vell(ibt)
        veltp=vell(itp)
       endif
      enddo

      ddep=dep-deptp
      delv=velbt-veltp
      delr=depbt-deptp
      dv=-delv/delr

      v=veltp-(ddep*dv)

      end

      


