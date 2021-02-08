      subroutine drawcir(xx,yy,ifdraw,ifinit
     1    ,xs,ys,inc,ixmax,is,ind,ismax)
      dimension xs(inc,ixmax),ys(inc,ixmax),ind(ismax)

      logical segop

      x=xc+xx
      y=yc+yy
      if(ifinit.ne.0) then
        ip=0
        is=0
        segop=.false.
        ind(1)=1
      endif

      if(ifdraw.eq.0) then
        segop=.false.
      else
        if(.not.segop) then
          is=is+1
          ip=1+ip
          ind(is)=ip
          xs(1,ip)=xc
          ys(1,ip)=yc
          segop=.true.
        endif
        ip=1+ip
        xs(1,ip)=x
        ys(1,ip)=y

      endif

      ind(is+1)=ip+1
      if(is+1.gt.ismax) pause 'index too big in drawci'
      if(ip+1.gt.ixmax) pause 'buffer too big in drawci'
      xc=x
      yc=y
      return
      end
