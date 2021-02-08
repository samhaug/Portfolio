c----------------------------------
      subroutine bytswap8(ar,nel)
      real*8 ar(*)
      real*8 r8
      integer*4 i4(2),isave
      byte b(8),bb(4)
      equivalence (r8,i4,b),(isave,bb)
      do i=1,nel
        r8=ar(i)
        isave=i4(2)
        b(8)=b(1)
        b(7)=b(2)
        b(6)=b(3)
        b(5)=b(4)
        b(4)=bb(1)
        b(3)=bb(2)
        b(2)=bb(3)
        b(1)=bb(4)
        ar(i)=r8
      enddo
      return
      end
c----------------------------------
      subroutine bytswap4(iar,nel)
      integer*4 iar(*)
      byte c(4),csave
      integer*4 i4
      equivalence (c,i4)
      do i=1,nel
        i4=iar(i)
        csave=c(1)
        c(1)=c(4)
        c(4)=csave
        csave=c(2)
        c(2)=c(3)
        c(3)=csave
        iar(i)=i4
      enddo
      return
      end
c----------------------------------
      subroutine bytswap2(iar,nel)
      integer*2 iar(*)
      byte c(2),csave
      integer*2 i2
      equivalence (c,i2)
      do i=1,nel
        i2=iar(i)
        csave=c(1)
        c(1)=c(2)
        c(2)=csave
        iar(i)=i2
      enddo
      return
      end

c---------------------------------------
      subroutine vax2sparci2(in,n,excep)
#if ( defined(Machine4) )
#include <f77_floatingpoint.h>
      integer*2 in(n)
      integer excep, convert_external, round
      integer src(4), dest(4)
      src(1)=convert_external_vax
      src(2)=convert_external_signed
      src(3)=2
      dest(1)=convert_external_sparc
      dest(2)=convert_external_signed
      dest(3)=2
      round = convert_external_common
      excep=or(excep,convert_external(in, src, in, dest, round, n))
      return
      end
c---------------------------------------
      subroutine vax2sparci4(in,n,excep)
#include <f77_floatingpoint.h>
      integer*4 in(n)
      integer excep, convert_external, round
      integer src(4), dest(4)
      src(1)=convert_external_vax
      src(2)=convert_external_signed
      src(3)=4
      dest(1)=convert_external_sparc
      dest(2)=convert_external_signed
      dest(3)=4
      round = convert_external_common
      excep=or(excep,convert_external(in, src, in, dest, round, n))
      return
      end
c---------------------------------------
      subroutine vax2sparcr4(in,n,excep)
#include <f77_floatingpoint.h>
      integer*4 in(n)
      integer excep, excep1, convert_external, round
      integer src(4), dest(4)
      src(1)=convert_external_vax
      src(2)=convert_external_float
      src(3)=4
      dest(1)=convert_external_sparc
      dest(2)=convert_external_float
      dest(3)=4
      round = convert_external_common
      do i=1,n
        ihold=in(i)
        if(in(i).ne.z'FFFFFFFF') then
          excep1=convert_external(in(i), src, in(i), dest, round, 1)
          if(excep1.gt.1) then
            write(0,'(''vax2sparcr4: '',z10.8,''  Exception'',z10.8,i11,'' of'',i11)') ihold,excep1,i,n
            in(i)=ihold
            pause
          endif
          excep=or(excep,excep1)
        endif
      enddo
      return
      end
c---------------------------------------
      subroutine vax2sparcr8(in,n,excep)
#include <f77_floatingpoint.h>
      real*8 in(n)
      integer excep, convert_external, round
      integer src(4), dest(4)
      src(1)=convert_external_vax
      src(2)=convert_external_float
      src(3)=8
      dest(1)=convert_external_sparc
      dest(2)=convert_external_float
      dest(3)=8
      round = convert_external_common
      excep=or(excep,convert_external(in, src, in, dest, round, n))
      return
      end

c---------------------------------------
      subroutine vax2sparcl4(in,n,excep)
      integer*4 in(n)
      integer excep
      logical*4 l4
      integer*4 i4
      equivalence (l4,i4)
      call vax2sparci4(in,n,excep)
      do i=1,n
        if(btest(in(i),0)) then
          l4=.TRUE.
        else
          l4=.FALSE.
        endif
        if(in(i).ne.i4) excep=or(excep,z'00000001')
        in(i)=i4
      enddo
      return
      end
c---------------------------------------
      subroutine vax2sparcl2(in,n,excep)
      integer*2 in(n)
      integer excep
      logical*2 l2
      integer*2 i2
      equivalence (l2,i2)
      call vax2sparci2(in,n,excep)
      do i=1,n
        if(btest(in(i),0)) then
          l2=.TRUE.
        else
          l2=.FALSE.
        endif
        if(in(i).ne.i2) excep=or(excep,z'00000001')
        in(i)=i2
      enddo
      return
      end
c---------------------------------------
      subroutine vax2sparcl1(in,n,excep)
      integer excep
      byte in(n)
      logical*1 l1
      byte i1
      equivalence (l1,i1)
      excep=0
      do i=1,n
        if(btest(in(i),0)) then
          l1=.TRUE.
        else
          l1=.FALSE.
        endif
        if(in(i).ne.i1) excep=or(excep,z'00000001')
        in(i)=i1
      enddo
#endif
      return
      end

        
