c---------------------------------------------------------------------
      subroutine drawc(x,y,arect,ifdraw,ifinit)

      parameter (nbuf=20000)
      parameter (nind=2000)
      parameter (nout2=nbuf*2)
      common/cbuf/ip,is,xc,yc,ind(nind),xy(2,2,nind),buf(2,nbuf)
      dimension xny(nout2)
      equivalence (xny(1),buf(1,1))
      logical segop
      common/clog/segop

      logical pin,cpin,ifcut
      dimension arect(2,2)

      if(ifinit.ne.0) then
        ip=0
        is=0
        xc=.5*(arect(1,1)+arect(1,2))
        yc=.5*(arect(2,1)+arect(2,2))
        segop=.false.
        ind(1)=1
      endif

      if(ifdraw.eq.0) then
        segop=.false.
        ind(is+1)=ip+1

      else
        call bndry(arect,x,y,xc,yc,pin,cpin,ifcut,xb,yb,xcb,ycb)
        ipin=0
        icpin=0
        iicut=0
        if(pin) ipin=1
        if(cpin) icpin=1
        if(ifcut) iicut=1
c       write(6,"('bndry through'/4f8.3,3i2,4f8.3)")
c    1     xc,yc,x,y,icpin,ipin,iicut,xcb,ycb,xb,yb
        if(.not.cpin) then
          segop=.false.
          ind(is+1)=ip+1
        endif

        if(ifcut.and..not.segop) then
          is=is+1
          ip=1+ip
          ind(is)=ip
          buf(1,ip)=xcb
          buf(2,ip)=ycb
          xy(1,1,is)=xcb
          xy(2,1,is)=ycb
          xy(1,2,is)=xcb
          xy(2,2,is)=ycb
          segop=.true.
        endif
        if(ifcut) then
          ip=1+ip
          buf(1,ip)=xb
          buf(2,ip)=yb
          xy(1,2,is)=xb
          xy(2,2,is)=yb
        endif
        if(.not.pin) then
          segop=.false.
          ind(is+1)=ip+1
        endif

      endif

      ind(is+1)=ip+1
      xc=x
      yc=y
      return
      end
