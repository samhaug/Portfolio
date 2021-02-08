      subroutine sccmake(cc,psfer,i)
      dimension cc(6,10),psfer(8),xmul(10)
      common/intap/ jstat,itype,icomp,ifact,jter,neig,npoint
     1   ,jifdep,jnstr,jtrans,j1s,j1f,j2s,j2f,jnpar,jiftwo
      common/iap2/ b1c,a2c,b2c,b2s,a3c,a3s
       common/tab3/h1(2),h2(2),z1(4),z2(4),z3(4),z4(4)
     1 ,p1(6),p2(6),p3(6),p4(6),p5(6),p6(6),p7(6),p8(6),p9(6),p10(6)
     1 ,q1(3),q2(3),q3(3),q4(3),q5(3),q6(3),q7(3)
      common/ap1/ t0,dt,ommax
     1     ,theta,caz,saz,epc(2,4)
     1     ,f(6),f2pf3,f2mf3,dum2(4)


c           call fvclr(xmul(1),1,10)
            do ii=1,10
              xmul(ii)=0.
            enddo
c
            if(i.le.4) then
              if(jter.lt.0) then
                xmul(1)=psfer(1)*(z1(i)*f(1)+z2(i)*f2pf3)
     1             -b1c*z3(i)+a2c*z4(i)
                goto 300
              else
                xmul(1)=psfer(1)*z1(i)
                xmul(2)=psfer(1)*z2(i)
                xmul(3)=xmul(2)-psfer(5)*z4(i)
                xmul(2)=xmul(2)+psfer(5)*z4(i)
                xmul(4)=-psfer(3)*z3(i)
                xmul(5)=-psfer(4)*z3(i)
                xmul(6)=2.*psfer(6)*z4(i)
                if(jter.eq.0) goto 300
              endif
            endif
            xmul(7)=psfer(1)*(p8(i)*f(1)-p5(i)*f2pf3)
     1            -b1c*(p9(i)+p1(i))+a2c*p4(i)
            xmul(8)=psfer(1)*f(4)*(p3(i)-p5(i))
     1            +psfer(3)*(-f(1)*p1(i)
     1            +f(2)*(p6(i)+p7(i))+f(3)*p7(i))
     1            +psfer(4)*f(6)*p6(i)+b2c*(p2(i)+p4(i))
     1           -a3c*p10(i)
            xmul(9)=psfer(1)*f(5)*(p3(i)-p5(i))
     1           +psfer(4)*(-f(1)*p1(i)+f(2)*p7(i)+f(3)*(p6(i)
     1           +p7(i)))
     1          +psfer(3)*f(6)*p6(i)+b2s*(p2(i)+p4(i))-a3s*p10(i)
 300        continue
            do j=1,ifact
              cc(i,j)=xmul(j)
            enddo
      end
