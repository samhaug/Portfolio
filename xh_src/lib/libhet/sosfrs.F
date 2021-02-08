      subroutine sosfrs
      save 
      common/intap/ jstat,itype,icomp,ifact,jter,neig,npoint
     1   ,jifdep,jnstr,jtrans,j1s,j1f,j2s,j2f,jnpar,jiftwo
      common/iap5/ synt(514,10),addf(7710)
      common/ap1/ t0,dt,ommax
     1     ,theta,caz,saz,epc(2,4)
     1     ,f(6),f2pf3,f2mf3,dum2(4)

      common/ap2/ xl(380),omega(380),qbar(380),grv(380),elp(380),
     1  u(6,380),sp(12,380)
      common/inter/ knt,xj,zz1,zz2

       common/tab3/h1(2),h2(2),z1(4),z2(4),z3(4),z4(4)
     1 ,p1(6),p2(6),p3(6),p4(6),p5(6),p6(6),p7(6),p8(6),p9(6),p10(6)
     1 ,q1(3),q2(3),q3(3),q4(3),q5(3),q6(3),q7(3)

      common/iap2/ b1c,a2c,b2c,b2s,a3c,a3s

      common/iap1/ psfer(8,2),ptors(8,2)

cc#include "tab3.h"
      complex a0,step
      dimension xaux(514,4),yaux(514,4),c(6,10,4)
     1     ,cc(6,10,2)
     1   ,fact(10,4)
      nc=6*ifact
      nn2=0
  600 nn=nn2+1
      if(nn.gt.380) return
      if(xl(nn).lt.0.) goto 99
      if(omega(nn).gt.ommax) then
        nn2=nn
        goto 600
      endif
      nn2=nn
      do while (nn2.le.380.and.omega(nn2).le.ommax
     1     .and.xl(nn2).eq.xl(nn).and.nn2-nn.lt.4)
        nn2=1+nn2
      enddo
      nn2=nn2-1
      nnn=nn2-nn+1
      if(xl(nn).lt.0.) go to 99
      if(xl(nn).ne.xj) then
        knt=0
        xj=xl(nn)
        l=xj+.001
        call sphars(l,theta,caz,saz,epc,icomp,psfer,ptors)
        call fvclr(c,1,3*20)
        call fvclr(cc,1,3*20*2)
        xj2=xj*(xj+1.)
        p3(1)=-.5*xj2-1.
        p3(3)=xj2
        p5(3)=-.5*xj2
        p5(4)=.5*xj2
        p6(3)=.5*xj2
        p7(3)=.25*(xj2+2.)
        z2(3)=-.5*xj2
        f62=2.*f(6)
cC$DOIT PPROC SCCMAKE
        do k=1,2
          b1c=f(4)*psfer(3,k)+f(5)*psfer(4,k)
          a2c=f2mf3*psfer(5,k)+f62*psfer(6,k)
          b2c=f(4)*psfer(5,k)+f(5)*psfer(6,k)
          b2s=f(4)*psfer(6,k)-f(5)*psfer(5,k)
          a3c=f2mf3*psfer(7,k)+f62*psfer(8,k)
          a3s=f2mf3*psfer(8,k)-f62*psfer(7,k)
          do  i=1,neig
            call sccmake(cc(1,1,k),psfer(1,k),i)
          enddo

        enddo
        endif
cC$DOIT PPROC SDOMODE
        do mm=1,nnn
          call sdomode(nn,mm,cc,nc,xaux(1,mm),yaux(1,mm)
     1      ,npoint,fact(1,mm),ifact,neig,t0,dt,c(1,1,mm))
        enddo
  
      do mm=1,nnn
        if(knt.ne.0.or.mm.ne.1.or.dt.ge.20.) then
          do i=1,ifact
cC            call fvsma2(xaux(1,mm),1,fact(i,mm),synt(1,i),1,npoint)
            call saxpy(npoint,fact(i,mm),xaux(1,mm),1,synt(1,i),1)
          enddo

        endif
      enddo

      knt=knt+nnn
      goto 600
   99 jstat=-1
      return
      end

