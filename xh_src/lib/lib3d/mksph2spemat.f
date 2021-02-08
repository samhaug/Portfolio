      subroutine mksph2spemat(iopt,c,ne,nh)

c     calculate the matrix c that tranlates a vector w.r.t the sph parameterisation (xih) to
c     a vector w.r.t. (xoe) the spe parameterisation.
c     transformation can be through a call sgemv('N',ne,nh,1.,c,MPES,xih,1,0.,xoe,1)
c     iopt=1 gives the least squares solution, iopt2 a quick, but very accurate mapping
c     based on the fact that the splines are 0 at all but one node
c     see sph2spe_test for test of calculations

      parameter (MPH=24)
      parameter (MPE=34)
      parameter (MPHS=MPH-3)
      parameter (MPES=MPE-3)
      parameter (MXDP=3000)
      dimension depth(MXDP)
      dimension ata(MPES,MPES),atb(MPES,MPHS),c(MPES,MPHS),x(MPES)
      dimension ipiv(MPES),work(MPES)

      parameter (MXKNT=31)
      common/speprm/spknt(MXKNT),qq0(MXKNT,MXKNT),qq(3,MXKNT,MXKNT)

      call splhsetup()
      call spesetup()

      ne=31
      nh=21

      if(iopt.eq.1) then

       rmoho=6346619.
       rcmb=3479958.
       rtop=rmoho
       rbot=rcmb

       ndep=2891

c      construct array with depths
       do i=1,ndep
        depth(i)=float(i)
       enddo

       do i=1,ndep
        rx=6371000.-depth(i)*1000.
        xd=-1.+2.*(rx-rbot)/(rtop-rbot)

c       construct ATB
        do j=1,ne
         x(j)=spe(j-1,xd)
         do k=1,nh
          sh=splh(k-1,xd)
          atb(j,k)=atb(j,k)+sh*x(j)
         enddo
        enddo

c       calculate innerproduct for different depths
        do k=1,ne
         do j=1,ne
          ata(k,j)=ata(k,j)+x(k)*x(j)
         enddo
        enddo
       enddo
 
c      invert ata 
       call sgetrf(ne,ne,ata,MPES,ipiv,info)
       call sgetri(ne,ata,MPES,ipiv,work,MPES,info)

c      multiply ata-1 * atb to give matrix c
c      matrix c can be multiplied by any vector of sph coefficients 
c      to give a vector of spe coefficients
       call sgemm('N','N',ne,nh,ne,1.,ata,MPES,atb,MPES,0.,c,MPES)

      else if(iopt.eq.2) then

c      now calculate using the values of all sph splines at each of the spe knots
       do i=1,ne
        do j=1,nh
         c(i,j)=splh(j-1,spknt(ne-i+1))
        enddo
       enddo

      else
       stop'mksph2spemat: unknown iopt'
      endif

      end

