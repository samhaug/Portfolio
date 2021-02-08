      subroutine sotors
      save
      common/intap/ jstat,itype,icomp,ifact,jter,neig,npoint
     1   ,jifdep,jnstr,jtrans,j1s,j1f,j2s,j2f,jnpar,jiftwo
      common/iap5/ synt(514,10),addf(7710)
      common/ap1/ t0,dt,ommax
     1     ,theta,caz,saz,epc(2,4)
     1     ,f(6),f2pf3,f2mf3,dum2(4)

      common/ap2/ xl(437),omega(437),qbar(437),grv(437),elp(437),
     1  u(3,437),sp(12,437)
      common/iap1/ psfer(8,2),ptors(8,2)
      common/inter/ knt,xj,zz1,zz2

      common/tab3/h1(2),h2(2),z1(4),z2(4),z3(4),z4(4)
     1 ,p1(6),p2(6),p3(6),p4(6),p5(6),p6(6),p7(6),p8(6),p9(6),p10(6)
     1 ,q1(3),q2(3),q3(3),q4(3),q5(3),q6(3),q7(3)

cc#include "tab3.h"

c      common/iap4/ b1st,a2st,b2ct,b2st,a3ct,a3st


      complex a0,step
      dimension xaux(514,4),yaux(514,4),c(3,20,4)
     1     ,xmul(10),cc(3,20,2)
     1   ,fact(10,4)
      nc=3*ifact
      nn2=0
  600 nn=nn2+1
      if(nn.gt.437) return
      if(xl(nn).lt.0.) goto 99
      if(omega(nn).gt.ommax) then
        nn2=nn
        goto 600
      endif
      nn2=nn
      do while (nn2.le.437.and.omega(nn2).le.ommax
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
        call fvclr(xmul,1,10)
        call fvclr(cc,1,3*20*2)
        do k=1,2
            xj2=xj*(xj+1.)
            q5(1)=-5.*xj2
            q5(2)=.5*xj2
            q6(1)=.5*xj2
            q7(1)=-.25*(xj2-2.)
            f62=2.*f(6)
            b1st=f(4)*ptors(4,k)-f(5)*ptors(3,k)
            a2st=f2mf3*ptors(6,k)-f62*ptors(5,k)
            b2ct=f(4)*ptors(5,k)+f(5)*ptors(6,k)
            b2st=f(4)*ptors(6,k)-f(5)*ptors(5,k)
            a3ct=f2mf3*ptors(7,k)+f62*ptors(8,k)
            a3st=f2mf3*ptors(8,k)-f62*ptors(7,k)




            do i=1,neig
              call fvclr(xmul,1,10)
              if(i.le.2) then

                if(jter.lt.0) then
                  xmul(1)=a2st*h1(i)-b1st*h2(i)
                  goto 300
                else
                  xmul(2)=ptors(6,k)*h1(i)
                  xmul(3)=-xmul(2)
                  xmul(4)=-ptors(4,k)*h2(i)
                  xmul(5)=ptors(3,k)*h2(i)
                  xmul(6)=-2.*ptors(5,k)*h1(i)



                  if(jter.eq.0) goto 300
                endif
              endif
              q41=q4(i)+q1(i)
              f167=-f(1)*q1(i)+f(2)*q6(i)+f2pf3*q7(i)
              f55=f(5)*q5(i)
              q21=q2(i)-q1(i)
              f66=f(6)*q6(i)
              f45=f(4)*q5(i)
              f176=f(1)*q1(i)-f2pf3*q7(i)-f(3)*q6(i)
              xmul(7)=-b1st*q41-a2st*q1(i)
              xmul(8)=ptors(1,k)*f55+ptors(4,k)*f167
     1            +b2st*q21-a3st*q3(i)-ptors(3,k)*f66
              xmul(9)=-ptors(1,k)*f45+ptors(3,k)*f176
     1            -b2ct*q21+a3ct*q3(i)+ptors(4,k)*f66

 300          continue
              do j=1,ifact
                cc(i,j,k)=xmul(j)
              enddo
            enddo
          enddo
        endif

C$DIR PARALLEL
        do mm=1,nnn
          call tdomode(nn,mm,cc,nc,xaux(1,mm),yaux(1,mm)
     1      ,npoint,fact(1,mm),ifact,neig,t0,dt,c(1,1,mm))
        enddo

      do mm=1,nnn
        if(knt.ne.0.or.mm.ne.1.or.dt.ge.20.) then

C$DIR PARALLEL
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
