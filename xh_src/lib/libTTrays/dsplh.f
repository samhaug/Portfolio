      function dsplh(ind,x)

      implicit double precision(a-h,o-z)

      parameter (MXKNT=21)
      common/splhprm/spknt(MXKNT),qq0(MXKNT,MXKNT),qq(3,MXKNT,MXKNT)
      if(x.gt.1.or.x.lt.-1) then
       dsplh=0.
       goto 10
      endif

      dsplh=drsple(1,MXKNT,spknt(1),qq0(1,MXKNT-ind),qq(1,1,MXKNT-ind),x)

10    continue
      return
      end
 

