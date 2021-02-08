      subroutine extnd(knum,s1,s2,x1,x2,z)
      dimension x1(*),x2(*),z(*)
      call scopy(knum,x1,1,z,1)
      call sscal(knum,s1,z,1)
      call saxpy(knum,s2,x2,1,z,1)
      return
      end
