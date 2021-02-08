      subroutine pecntg(array,mdim,ndim,idima,locntr,hicntr,
     x  ncntr,wkarea,exsc,exlf,klin,lines)
c
c ********  the slac unified graphics system (vax-11 version)  ********
c *                      contour plot subroutine                      *
c *                                                                   *
c *                                                                   *
c *  the calling sequence is:                                         *
c *  array is a rectangular floating point array of dimension mdim    *
c *  and ndim; mdim and ndim are fixed point; locntr and hicntr are   *
c *  floating point; nctr is fixed point; wkarea is a fixed point     *
c *  array of approximate dimension mdim*ndim/7;         *
c *                                                                   *
c *                          robert c. beach                          *
c *                    computation research group                     *
c *                stanford linear accelerator center                 *
c *                                                                   *
c *********************************************************************
c
      integer       mdim,ndim
      integer       lines(4)
      real          array(idima,1)
      real          locntr,hicntr
      integer       ncntr
      integer*4     wkarea(1)
      real*4        exxr,exxl,exxv,exyv
      integer*2     exsc,exlf
      integer       ncnt,icnt,mcnt,irow,icol,isid
      real          zcnt
      real          xpnt,ypnt,tpnt,xlbl,ylbl
      integer       jrow,jcol,jsid
      integer       krow,kcol,ksid
      integer       bbit,bdfg,infg,mkfg
      real          ivr1,ivr2,dvr1,dvr2
      real          xsav,ysav
      integer*4     pwrs(31)
      integer       xmnb,xmnw,xmno,xmwd,xmlp,xmup,xmp0,xmp1
      integer       iret,jret,kret
c
      integer       int1,int2
c
      common /plotc/ l
      common /ctring/ npause,isize,label,exinc,ifrot
      data          pwrs/
     x            1,          2,          4,          8,
     x           16,         32,         64,        128,
     x          256,        512,       1024,       2048,
     x         4096,       8192,      16384,      32768,
     x        65536,     131072,     262144,     524288,
     x      1048576,    2097152,    4194304,    8388608,
     x     16777216,   33554432,   67108864,  134217728,
     x    268435456,  536870912, 1073741824/
c     data          lines/     0,   334,  3336,    34/
      write(6,'(''klin,lines'',6i10)') klin,(lines(i),i=1,5)
      exxr=-1.0
      exxl=-1.0
      exxv=-1.0
      exyv=1.0
      if((ndim.lt.3).or.(mdim.lt.3)) goto 301
c  compute the contour count.
      kdim = ((mdim-2)*(ndim-1)+ndim+13)/15
      int1=max0(ncntr,2)
      ncnt=int1+(int1-1)*exsc
c
c  loop for each contour.
      do 112 icnt=1,ncnt
c       l=lines(mod(icnt,4)+1)
        l=lines(mod(icnt-1,klin)+1)
        zcnt=locntr+float(icnt-1)*(hicntr-locntr)/float(ncnt-1)
      write(6,10001)zcnt
10001 format(' contour level ''zcnt'' =',g12.5)
      if (npause .ne. 0) pause 'change pen'
        mcnt=mod(icnt-1,exsc+1)
c  generate label if necessary.
c  clear segment bit map.
        do 101 int1=1,kdim
          wkarea(int1)=0
  101   continue
c  set flag to indicate boundarys being processed.
        bdfg=1
c  process lower and upper boundary.
        do 104 icol=3,ndim
          irow=3
          isid=1
          iret=1
          go to 401
  102     irow=mdim
          isid=3
          iret=2
          go to 401
  103     continue
  104   continue
c  process left and right boundary.
        do 107 irow=3,mdim
          icol=3
          isid=0
          iret=3
          go to 401
  105     icol=ndim
          isid=2
          iret=4
          go to 401
  106     continue
  107   continue
c  set flag to indicate boundarys not being processed.
        bdfg=0
c  process interior sides of surface patches.
        if (ndim.lt.4) go to 111
        do 110 icol=4,ndim
          do 109 irow=3,mdim
            isid=0
            iret=5
            go to 401
  108       continue
  109     continue
  110   continue
  111   call anmode
  112 continue
      goto 201
 301  write(6,302) ndim,mdim
 302  format(1x,'no contouring: ndim = ',i3,' mdim = ',i3)
 201  return
c
c
c  internal routine to process the isid-th side of the
c  (irow,icol)-th surface patch.  if the side has not been
c  checked before, then the contour is examined to see if it
c  crosses the side.  if it does not, the side is marked as
c  having been checked.  if the contour crosses the side, the
c  contour is followed until it is complete and all affected
c  sides are marked as having been checked.
  401 jrow=irow
      jcol=icol
      jsid=isid
c  do any contours begin at this side?
      kret=1
      go to 851
  402 if (mkfg.eq.1) go to 471
      jret=1
      go to 501
  403 if (infg.eq.0) go to 463
c  start drawing the contour curve.
      jret=1
      go to 601
  404 bbit=2
      jret=1
      go to 701
  405 bbit=0
c  find the other side of the patch.
  411 jsid=mod(jsid+2,4)
      kret=2
      go to 851
  412 if (mkfg.eq.1) go to 414
      jret=2
      go to 501
  413 if (infg.ne.0) go to 421
      kret=3
      go to 801
  414 jsid=mod(jsid+1,4)
      kret=4
      go to 851
  415 if (mkfg.eq.1) go to 417
      jret=3
      go to 501
  416 if (infg.ne.0) go to 421
      kret=5
      go to 801
  417 jsid=mod(jsid+2,4)
      kret=6
      go to 851
 418  jret=4
      go to 501
 419  continue
c  draw current part of the contour.
  421 jret=2
      go to 701
c  mark the line processed.
  431 kret=7
      go to 801
c  find the adjacent surface patch.
  441 if (jsid.eq.3) go to 444
      if (jsid.eq.2) go to 443
      if (jsid.eq.1) go to 442
      if (jcol.le.3) go to 461
      jcol=jcol-1
      jsid=2
      go to 451
  442 if (jrow.le.3) go to 461
      jrow=jrow-1
      jsid=3
      go to 451
  443 if (jcol.ge.ndim) go to 461
      jcol=jcol+1
      jsid=0
      go to 451
  444 if (jrow.ge.mdim) go to 461
      jrow=jrow+1
      jsid=1
c  check for closure of the contour line.
  451 if ((jrow.eq.irow).and.(jcol.eq.icol).and.(jsid.eq.isid))
     x  go to 471
      go to 411
c  finish an open curve.
  461 jret=2
      go to 601
  462 jrow=irow
      jcol=icol
      jsid=isid
  463 kret=8
      go to 801
c  the contour line is now complete.
  471 go to (102,103,105,106,108),iret
c
c  internal routine to determine if the (jrow,jcol,jsid)-th
c  side is intersected by the current contour line.  if the
c  answer is yes, infg is set to one and the coordinates
c  of the intersection are saved in (xpnt,ypnt).
c  first, obtain the independent and dependent variables.
 501  continue
      if (mkfg.ne.0) go to 510
      if (jsid.eq.3) go to 505
      if (jsid.eq.2) go to 503
      if (jsid.eq.1) go to 502
      dvr1=array(jrow-1,jcol-1)
      dvr2=array(jrow,jcol-1)
      xpnt=array(1,jcol-1)
      go to 504
  502 dvr1=array(jrow-1,jcol-1)
      dvr2=array(jrow-1,jcol)
      ypnt=array(jrow-1,1)
      go to 506
  503 dvr1=array(jrow-1,jcol)
      dvr2=array(jrow,jcol)
      xpnt=array(1,jcol)
  504 ivr1=array(jrow-1,1)
      ivr2=array(jrow,1)
      go to 507
  505 dvr1=array(jrow,jcol-1)
      dvr2=array(jrow,jcol)
      ypnt=array(jrow,1)
  506 ivr1=array(1,jcol-1)
      ivr2=array(1,jcol)
c  check for an intersection.
 507  continue
      if (((dvr1.lt.zcnt).and.(dvr2.lt.zcnt)).or.
     x  ((dvr1.ge.zcnt).and.(dvr2.ge.zcnt))) go to 510
c  compute the other coordinate.
      tpnt=ivr1+(zcnt-dvr1)*(ivr2-ivr1)/(dvr2-dvr1)
      if (mod(jsid,2).eq.0) go to 508
      xpnt=tpnt
      go to 509
  508 ypnt=tpnt
c  return with intersection.
  509 infg=1
      go to 511
c  return without intersection.
  510 infg=0
 511  continue
      go to (403,413,416,419),jret
c
c  internal routine to label a contour if a label is
c  required.  the label is positioned at the proper offset
c  from (xpnt,ypnt).
  601 if ((bdfg.eq.0).or.(exlf.ne.0).or.(mcnt.ne.0).or.(label.eq.0))
     x  go to 606
      xlbl=xpnt
      ylbl=ypnt
c  get the coordinates of the label.
      if (jsid.eq.3) go to 604
      if (jsid.eq.2) go to 603
      if (jsid.eq.1) go to 602
      xlbl=xlbl-3.5*exinc
      angle=0.0
      go to 605
  602 ylbl=ylbl-3.5*exinc
      angle=90.0
      go to 605
  603 xlbl=xlbl+0.5*exinc
      angle=0.0
      go to 605
  604 ylbl=ylbl+0.5*exinc
      angle=90.0
c  produce the label.
  605 call number(xlbl,ylbl,isize,zcnt,angle,'(f5.0)')
  606 go to (404,462),jret
c
c  internal procedure to draw a line to the point (xpnt,ypnt).
  701 if (bbit.eq.0.and.l.ne.0) go to 703
      call plot(xpnt,ypnt,bbit)
      go to 704
 703  call plot(xpnt,ypnt,4)
 704  xsav=xpnt
      ysav=ypnt
      go to (405,431),jret
c
c  801 is an internal routine to mark the (jrow,jcol,jsid)-th
c  line as having been processed.  851 is an internal routine
c  to test if the (jrow,jcol,jsid)-th line has been marked.  if
c  it has, mkfg is set to one.
  801 mkfg=0
      go to 852
  851 mkfg=1
  852 krow=jrow
      kcol=jcol
      ksid=jsid
      if (ksid.ne.2) go to 853
      ksid=0
      kcol=kcol+1
      go to 854
  853 if (ksid.ne.3) go to 854
      ksid=1
      krow=krow+1
  854 xmnb=2*((krow-3)*(ndim-1)+(kcol-3))+ksid
      xmnw=1+xmnb/30
      xmno=1+mod(xmnb,30)
      xmp0=pwrs(xmno)
      xmwd=wkarea(xmnw)
      if (mkfg.eq.0) go to 855
      xmup=xmwd/xmp0
      if (mod(xmup,2).eq.0) mkfg=0
      go to 856
  855 xmp1=pwrs(xmno+1)
      xmlp=mod(xmwd,xmp0)
      xmup=xmwd/xmp1
      wkarea(xmnw)=xmup*xmp1+xmp0+xmlp
  856 go to (402,412,414,415,417,418,441,471),kret
      end
