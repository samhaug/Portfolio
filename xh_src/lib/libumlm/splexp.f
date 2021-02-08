      subroutine splexp(vec1,inc1,n1,vec2,inc2,n2,work)
c
c  work must be dimensioned at least 8*n1.
c  vec2 can overlap, or be identical with vec1
c
      dimension vec1(inc1,1),vec2(inc2,1),work(1)
      fac=float(n2-1)/float(n1-1)
      do 10 i=1,n1
      work(i)=float(i-1)*fac+1.
   10 work(n1+i)=vec1(1,i)
      call rspln(1,n1,work(1),work(n1+1),work(2*n1+1),work(5*n1+1))
      do 20 j=1,n2
   20 vec2(1,j)=rsple(1,n1,work(1),work(n1+1),work(2*n1+1),float(j))
      return
      end
