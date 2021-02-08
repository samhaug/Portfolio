c------------------------------
      function tn(n,x)
      if(n.eq.0) then
        t1=1.
      else if(n.eq.1) then
        t1=x
      else
        t0=1
        t1=x
        xx=2.*x
        do i=2,n
          t2=xx*t1-t0
          t0=t1
          t1=t2
        enddo
      endif
      n4=4*n*n
      tn=t1*sqrt(float(n4-1)/float(n4-2))
      return
      end
