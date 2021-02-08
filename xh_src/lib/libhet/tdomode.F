 
       subroutine tdomode(nni,mm,cc,nc,xaux,yaux,npoint
     1     ,fact,ifact,neig,t0,dt,c)
      common/ap2/ xl(437),omega(437),qbar(437),grv(437),elp(437),
     1  u(3,437),sp(12,437)
      dimension xaux(514),yaux(514),cc(3,20,2),c(3,20),fact(10)
      complex a0,step
        nn=nni+mm-1
        om=omega(nn)
        x=xl(nn)
        call adjuss(x,om,grv(nn),elp(nn),sp(1,nn),dtheta)
        qb=-.5*qbar(nn)
#if ( defined(MachineS) )
cc        arg2=om*t0
cc        xmul2=om*dt
cc        arg2=arg2-xmul2
cc        arg1=arg2*qb
cc        xmul1=xmul2*qb
cc        do i=1,npoint
cc          xaux(i)=-0.95179*exp(arg1+xmul1*i)*cos(arg2+xmul2*i)
cc        enddo

      call mtrace(-0.95179,cmplx(om,-qb*om)
     1     ,t0,dt,npoint,32,xaux,yaux)
#else
        arg=om*t0
        a0=cmplx(-.95179,0.)*cexp(cmplx(qb*arg,arg))
        arg=om*dt
        step=cexp(cmplx(qb*arg,arg))
        do i=1,npoint
          xaux(i)=real(a0)
          a0=a0*step
        enddo
#endif
cC        call fvsma(cc(1,1,2),1,dtheta,cc(1,1,1),1,c(1,1),1,nc)
        call scopy(nc,cc(1,1,1),1,c(1,1),1)
        call saxpy(nc,dtheta,cc(1,1,2),1,c(1,1),1)
        do i=1,ifact
          call fdotpr(c(1,i),1,u(1,nn),1,fact(i),neig)
        enddo
      return
      end

