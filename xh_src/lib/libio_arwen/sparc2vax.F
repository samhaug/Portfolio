c---------------------------------------
      subroutine sparc2vaxi2(in,n)
#if  ( ! ( defined(MachineA) || defined(Machinel) ) )
#include <f77_floatingpoint.h>
      integer*2 in(n)
      integer excep, convert_external, round
      integer src(4), dest(4)
      src(1)=convert_external_sparc
      src(2)=convert_external_signed
      src(3)=2
      dest(1)=convert_external_vax
      dest(2)=convert_external_signed
      dest(3)=2
      round = convert_external_common
      excep=convert_external(in, src, in, dest, round, n)
      return
      end
c---------------------------------------
      subroutine sparc2vaxi4(in,n)
#include <f77_floatingpoint.h>
      integer*4 in(n)
      integer excep, convert_external, round
      integer src(4), dest(4)
      src(1)=convert_external_sparc
      src(2)=convert_external_signed
      src(3)=4
      dest(1)=convert_external_vax
      dest(2)=convert_external_signed
      dest(3)=4
      round = convert_external_common
      excep=convert_external(in, src, in, dest, round, n)
      return
      end
c---------------------------------------
      subroutine sparc2vaxr4(in,n)
#include <f77_floatingpoint.h>
      real*4 in(n)
      integer excep, convert_external, round
      integer src(4), dest(4)
      src(1)=convert_external_sparc
      src(2)=convert_external_float
      src(3)=4
      dest(1)=convert_external_vax
      dest(2)=convert_external_float
      dest(3)=4
      round = convert_external_common
      excep=convert_external(in, src, in, dest, round, n)
      return
      end
c---------------------------------------
      subroutine sparc2vaxr8(in,n)
#include <f77_floatingpoint.h>
      real*8 in(n)
      integer excep, convert_external, round
      integer src(4), dest(4)
      src(1)=convert_external_sparc
      src(2)=convert_external_float
      src(3)=8
      dest(1)=convert_external_vax
      dest(2)=convert_external_float
      dest(3)=8
      round = convert_external_common
      excep=convert_external(in, src, in, dest, round, n)
#endif
      return
      end

    
