
      subroutine readinaniso
CC    SUBROUTINE TO READ IN COEFFICIENTS
      implicit double precision(a-h,o-z)
      common/coefs/ cofno(20,8,4),xb(20),xt(20),rnorm
c
c     open(12,file='/home/hendrik/src/graham/noocavs.mod',form='formatted',status='old')
      open(512,file='/geo/home/jritsema/Utils/dta/noocean.mod',form='formatted',status='old')
c     approximates effective isotropic solid in anisotropic parts of prem:
c     rho Vpv Vsv 1/Q_mhu 1/Q_kappa Vph Vsh eta

      read(512,30) numlyr,nic,noc,rnorm,moho
      do i=1,12
          read(512,40) nl,junk,xb(i),xt(i)
          do j=1,8
              read(512,60)(cofno(i,j,jj),jj=1,4)
          enddo
      enddo

c
      close(512)
30    format(3I5,D15.9,I5)
40    format(2I5,2D15.9)
60    format(4D16.9)
      return
      end


