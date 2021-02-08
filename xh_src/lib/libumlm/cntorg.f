      subroutine cntorg(work,con,jcon,icon,noverr,m1,m2,m3,
     *n1,n2,n3,klin,ilin)
      dimension ilin(1)
      common /mesh/ nx,nx1,nx2,nx3,ny,ny1,ny2,ny3
      common /ctring/ npause,isize,label,exinc,ifrot
      dimension  work(m3,n3),con(3)
      dimension jcon(icon)
      rnx=float(m2-m1)
      rny=float(n2-n1)
      call dwindo(0.,rny,0.,rnx)
c
c     the next part of the program inserts the buffer points
c     on the matrix work (needed for contouring).
c
      do 16 i = 1,m2
16    work(i,1) = i - 2
      do 7 j = 1,n2
c
c     correct maximum and minimum contour levels are prepared
c     for the contouring subroutine.
c
 7    work(1,j) = j - 2
c     work(2,1)=work(2,1)-.5
c     work(m2,1)=work(m2,1)+.5
c     work(1,2)=work(1,2)-.5
c     work(1,n2)=work(1,n2)+.5
      xmineff=con(1)
      if (noverr.lt.0) noverr=-noverr
      xmax=con(1)+noverr*con(2)
      if (xmineff.le.xmax) goto 88
      xmax=con(1)
      xmineff=con(1)+noverr*con(2)
   88 noverr=noverr+1
c
c     rows are plotted vertically!
c
      call pecntg(work,m2,n2,m3,xmineff,xmax,noverr,jcon,0,0,klin,ilin)
      return
      end
