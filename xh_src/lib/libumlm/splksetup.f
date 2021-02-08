c-------------------------------------
      subroutine splksetup()
      parameter (MXKNT=21)
      common/splkprm/spknt(MXKNT),qq0(MXKNT,MXKNT),qq(3,MXKNT,MXKNT)
      dimension qqwk(3,MXKNT)
      data spknt/
     1  -1.0000000E+00, -8.6256000E-01, -7.2996000E-01, -6.0201000E-01, -4.7854000E-01, -3.5940000E-01
     1, -2.4443000E-01, -1.3350000E-01, -2.6450000E-02,  7.6850000E-02,  1.7652000E-01,  2.7270000E-01
     1,  3.6552000E-01,  4.5508000E-01,  5.4150000E-01,  6.2489000E-01,  7.0536000E-01,  7.8300000E-01
     1,  8.5793000E-01,  9.3023000E-01,  1.0000000E+00
     1  /
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
