      subroutine dinitdelmx()

      implicit double precision(a-h,o-z)

      common/delmxS/delmxsdep(50),delmxsdel(50),delmxsspl(50),
     1              delmnsels,delmxsels,ndelmxs
      common/delmxP/delmxpdep(50),delmxpdel(50),delmxpspl(50),
     1              delmnselp,delmxselp,ndelmxp

      open(21,file='/geo/home/jritsema/Utils/premtimes/delmax.S',status='old')
      i=1
10    read(21,*,end=11) delmxsdep(i),delmxsdel(i)
      i=i+1
      goto 10

11    continue
      ndelmxs=i-1
      close(21)

      open(21,file='/geo/home/jritsema/Utils/premtimes/delmax.P',status='old')
      i=1
12    read(21,*,end=13) delmxpdep(i),delmxpdel(i)
      i=i+1
      goto 12

13    continue
      ndelmxp=i-1
      close(21)

c     find minimum and maximum delta for which it will be nescessarry
c     to investigate more closely wether a phase is Sdiff or S, or Pdiff
c     or P

      delmnsels=delmxsdel(ndelmxs)
      delmxsels=delmxsdel(1)
      delmnselp=delmxpdel(ndelmxp)
      delmxselp=delmxpdel(1)

c     find second derivatives for spline interpolation:
      call dspline(delmxsdep,delmxsdel,ndelmxs,1.d32,1.d32,delmxsspl)
      call dspline(delmxpdep,delmxpdel,ndelmxp,1.d32,1.d32,delmxpspl)

      end


