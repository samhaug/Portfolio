
c-------------------------------------
      subroutine splrsetup()
      parameter (MXKNT=11)
      common/splrprm/spknt(MXKNT),qq0(MXKNT,MXKNT),qq(3,MXKNT,MXKNT)
      dimension qqwk(3,MXKNT)
      data spknt/
     1   -1.00000,-0.59207,-0.25499
     1  , 0.02353, 0.25367
     1  , 0.44384, 0.60097, 0.73081
     1  , 0.83810, 0.92675
     1  , 1.00000
     1    /

      do i=1,MXKNT
        do j=1,MXKNT
          if(i.eq.j) then
            qq0(j,i)=1.
          else
            qq0(j,i)=0.
          endif
        enddo
      enddo
      do i=1,MXKNT
        call rspln(1,MXKNT,spknt(1),qq0(1,i),qq(1,1,i),qqwk(1,1))
      enddo
      return
      end
