c-------------------------------------------
      function splr(ind,x)
      parameter (MXKNT=11)
      common/splrprm/spknt(MXKNT),qq0(MXKNT,MXKNT),qq(3,MXKNT,MXKNT)
      if(x.ge.-1..and.x.le.1.) then
        splr=rsple(1,MXKNT,spknt(1),qq0(1,MXKNT-ind),qq(1,1,MXKNT-ind),x)
      else
        splr=0.
      endif
      return
      end
