c----------------------------------------------------------------------
      subroutine spread(n)
      save
      common/mode/nord,jcom,lord,wcom,qbar,cgp,avert,ahor,phis
     1          ,eif(222,6)
      dimension eifs(1)
      equivalence (eif(1,1),eifs(1))
      do 10 i=1,6
      icol=7-i
      do 10 j=1,n
      irow=1+n-j
   10 eif(irow,icol)=eifs(irow+n*(icol-1))
      return
      end
