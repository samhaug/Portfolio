c-------------------------------------------
      function dspe(ind,x)

      implicit double precision(a-h,o-z)

      parameter (MXKNT=31)
      common/speprm/spknt(MXKNT),qq0(MXKNT,MXKNT),qq(3,MXKNT,MXKNT)
      if(x.ge.-1..and.x.le.1.) then
        dspe=rsple(1,MXKNT,spknt(1),qq0(1,MXKNT-ind),qq(1,1,MXKNT-ind),x)
      else
        dspe=0.
      endif
      return
      end
