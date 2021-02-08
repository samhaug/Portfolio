
      subroutine readmod(mfl)

      implicit double precision(a-h,o-z)
      common/coefs/cofno(20,8,4),xb(20),xt(20),rnorm

      character*(*) mfl

c     coefficients are for:
c     rho Vp_iso Vs_iso 1/Q_mhu 1/Q_kappa Vp_iso Vs_iso eta

      open(512,file=mfl,form='formatted',status='old')
      read(512,30) numlyr,nic,noc,rnorm,moho
      do i=1,12
          read(512,40) nl,junk,xb(i),xt(i)
          do j=1,8
              read(512,60)(cofno(i,j,jj),jj=1,4)
          enddo
      enddo
 
      close(512)
30    format(3I5,D15.9,I5)
40    format(2I5,2D15.9)
60    format(4D16.9)
      return
      end


