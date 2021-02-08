c-------------------------------------------
      function splk(ind,x)
      parameter (MXKNT=21)
      common/splkprm/spknt(MXKNT),qq0(MXKNT,MXKNT),qq(3,MXKNT,MXKNT)
      splk=rsple(1,MXKNT,spknt(1),qq0(1,MXKNT-ind),qq(1,1,MXKNT-ind),x)
      return
      end
