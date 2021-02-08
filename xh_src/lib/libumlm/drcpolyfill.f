c---------------------------------------------------------------------
      subroutine drcpolyfill(arect,ifinbl,ibackg,ifoutline)

      parameter (nbuf=20000)
      parameter (nind=2000)
      parameter (nout2=nbuf*2)
      common/cbuf/ip,is,xc,yc,ind(nind),xy(2,2,nind),buf(2,nbuf)
      dimension xny(nout2)
      equivalence (xny(1),buf(1,1))
      logical segop
      common/clog/segop

      dimension arect(2,2)

      real*4 rww(4),rwv(4),cww(4),cwv(4),w(4),v(4)
      real*4 xybox(8)
      parameter (MXPBUF=10000)
      dimension xpbuf(MXPBUF),ypbuf(MXPBUF)
      integer*2 ncode,icode(1),npoly,ix,iy,nvert,wkid
     1   ,itran,ier,ipend,iorgx,iorgy,one
     1   ,style,index,color,ifblank,color1
     1   ,wx1,wy1,wx2,wy2
     1   ,npolyaddr,nvertaddr
     1   ,macro0,fill0,text0,alpha0
     1   ,macro,fill,text,alpha
     1   ,ihit,iwid,zero,four

      data ncode/1/,icode(1)/z'12'/,wkid/1/
     1   ,one/1/
     1   ,ifblank/0/
     1   ,wx1/0/,wy1/0/,wx2/1279/,wy2/1023/
     1   ,macro0/z'2000'/,fill0/z'0800'/,text0/z'0800'/,alpha0/z'1000'/
     1   ,macro/z'0000'/,fill/z'4000'/,text/z'0000'/,alpha/z'0000'/
     1   ,zero/0/,four/4/

      ipbuf=0
      call jsegs(xy(1,1,1),xy(2,1,1),2,is,arect,ifinbl
     1  ,ind(is+2),nind-is-1,nout,buf(1,ip+1),2*(nbuf-ip))
      do 245 jj1=is+2,is+2+nout-1
      ii1=iabs(ind(jj1))
      if(ii1.gt.is) then
      else
      endif
  245 continue


       call qfilcol(kcolor)
       call filcol(ibackg)
       call filrect(arect)
       call filcol(kcolor)



      ii=is+1
      nvert=0
      ifbeg=1

      do 10 i=1,nout
      ii=1+ii

      if(ifbeg.eq.1) then
        ilook=ind(ii)
        itest=0
        ifbeg=0
        nvert=0
        npoly=0
      else
        itest=ind(ii)
      endif

      if(itest.eq.ilook) then
        npoly=1+npoly
        ifbeg=1
        call polyfil(ifoutline,xpbuf,ypbuf,1,ipbuf)
      call tsend
        ipbuf=0
        goto 10
      endif

      if(ind(ii).gt.is) then
        i4=ind(ii)-is
        ijx=1+mod(i4-1,2)
        ijy=1+(i4-1)/2
        nvert=nvert+1
        xlast=arect(1,ijx)
        ylast=arect(2,ijy)
        
        pxlast=xlast
        pylast=ylast
          ipbuf=1+ipbuf
          xpbuf(ipbuf)=pxlast
          ypbuf(ipbuf)=pylast
        goto 10
      endif

      iseg=iabs(ind(ii))
      inc=1
      if(ind(ii).lt.0) inc=-1
      isfr=ind(iseg)
      if(inc.eq.-1) isfr=ind(iseg+1)-1
      np=ind(iseg+1)-ind(iseg)

      do 20 ik=1,np

      if(nvert.eq.0.or.(
     1  (xlast.ne.buf(1,isfr).or.ylast.ne.buf(2,isfr)).and.
     1  (xstart.ne.buf(1,isfr).or.ystart.ne.buf(2,isfr))  ))  then
        nvert=nvert+1
        xlast=buf(1,isfr)
        ylast=buf(2,isfr)
        
        pxlast=xlast
        pylast=ylast
          ipbuf=1+ipbuf
          xpbuf(ipbuf)=pxlast
          ypbuf(ipbuf)=pylast

        if(nvert.eq.1) then
          xstart=xlast
          ystart=ylast
        endif

      endif

   20 isfr=isfr+inc

   10 continue

      return
      end

