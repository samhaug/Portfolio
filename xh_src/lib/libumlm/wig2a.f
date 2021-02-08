c
c   subroutine wig2a(l1,is,l2,a,id1)
c
c   calculates:
c
c
c   a(m1+l1+1,m2+l2+1)= (-1)**m1  ( l1    is    l2 )
c                                 (-m1   m1-m2  m2 )
c
c   for all m1 (-l1.le.m1.le.l1)
c   and all m2 (-l2.le.m2.le.l2)
c
c   program and algorithm by j. h. woodhouse
c
c   wig2a is the same as wig2, but written in more
c   transparent fortran.
c
      subroutine wig2(l1,is,l2,a,id1)
      implicit double precision (a-h,o-z)
      double precision a
      dimension a(-l1:id1-l1-1,-l2:l2)
      dfloat(n)=n
c
c     zero left hand side of matrix
c
      do m1=-l1,l1
        do m2=-l2,0
          a(m1,m2)=0.d0
        enddo
      enddo

      if((is.ge.iabs(l1-l2)).and.(is.le.(l1+l2))) then
c
c        compute the corner value
c
        r1=1.d0/dsqrt(dfloat(2*max0(l1,l2)+1))
        ldel=iabs(l1-l2)
        num=is-ldel
        if(num.ne.0) then
          do n=1,num
            isc=ldel+n
            r1=r1*dsqrt(dfloat(l1-isc+l2+1)/dfloat(l1+l2+isc+1))
          enddo
        endif
        a(-l1,-l2)=r1
c
c       compute first row
c
        num1=min0(is-l1+l2,l2)
        if(num1.ne.0) then
          do m2=-l2+1,-l2+num1
            a(-l1,m2)=-a(-l1,m2-1)*dsqrt(dfloat((l1+is+m2)*(is-l1-m2+1))
     1         /dfloat((l2-m2+1)*(l2+m2)))
          enddo
        endif
c
c       compute first column
c
        num2=is-l2+l1
        if(num2.ne.0) then
        do m1=-l1+1,-l1+num2
          m1=-l1+n
              a(m1+l1+1,1)=-a(m1+l1,1)*dsqrt(dfloat((l2+is+m1)*(-l2+is-m1+1))
     1         /dfloat((l1+m1)*(l1-m1+1)))
          enddo
        endif
        iss=is*(is+1)-l1*(l1+1)-l2*(l2+1)
c
c       iterate south-east
c
        numd=min0(2*is+1,is+l1)
        if(numd.eq.0) goto 610
        do nd=1,numd
          m1b=max0(-l1,is-l2-nd+1)
          m2b=max0(-l2,-is-l1+nd-1)
          numit=min0(-m2b,l1-m1b)
          if(numit.ne.0) then
            do nit=1,numit
              m1=m1b+nit
              m2=m2b+nit
              if((m1+l1.ge.2).and.(m2+l2.ge.2)) then
                r1=a(m1+l1-1,m2+l2-1)
              else
                r1=0.d0
              endif
              a(m1,m2)=-r1*dsqrt(dfloat((l1+m1-1)*(l1-m1+2)
     1            *(l2-m2+2)*(l2+m2-1)))
              a(m1,m2)=a(m1,m2)+dfloat(iss+2*(m1-1)*(m2-1))
     1            *a(m1-1,m2-1)
              a(m1,m2)=a(m1,m2)/dsqrt(dfloat((l1+m1)*(l1-m1+1)
     1          *(l2-m2+1)*(l2+m2)))
            enddo
          endif
        enddo
      endif
c
c     fill the rest of array
c
      sgn=(-1)**(l1+l2+is)
      do m1=-l1,l1
        do m2=1,l2
          a(m1,m2)=sgn*a(-m1,-m2)
        enddo
      enddo

      ind=mod(l2+is+1,2)
      do m1=-l1+ind,l1-ind,2
        do m2=-l2,l2
          a(i,j)=-a(i,j)
        enddo
      enddo
      return
      end
