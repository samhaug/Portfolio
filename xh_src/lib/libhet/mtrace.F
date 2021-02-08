      subroutine mtrace(rfac,com,t0,dt,n,n0,x,y)
      complex com, cstep, csave
      dimension x(*),y(*)


#if ( defined(MachineX) )

      cstep=cexp( ((0.,1.)*com)*dt )
      x(1)=1.
      y(1)=0.
      n1=min0(4,n)
      csave=cexp( ((0.,1.)*com)*t0 )*rfac
      cstep=cexp( ((0.,1.)*com)*dt )
      do i=1,n1
        x(i)=real(csave)
        y(i)=aimag(csave)
        csave=csave*cstep
      enddo
      k=n1
      cstep=cexp( ((0.,1.)*com)*dt*n1)
   10 s1=real(cstep)
      s2=aimag(cstep)
      k1=min0(2*k,n)
      knum=k1-k
C$DOIT IVDEP
      do i=1,knum
        x(k+i)=s1*x(i)-s2*y(i)
        y(k+i)=s2*x(i)+s1*y(i)
      enddo
      k=k1
      if(k.ge.n) goto 99
      cstep=cstep*cstep
      goto 10
   99 continue

#elif ( defined(MachineY) )
      cstep=cexp( ((0.,1.)*com)*dt )
      x(1)=1.
      y(1)=0.
      n1=min0(32,n)
c      do i=2,n1
c        csave=cexp( ((0.,1.)*com)*dt*(i-1) )
c        x(i)=real(csave)
c        y(i)=aimag(csave)
c      enddo

      csave=(1.,0.)
      cstep=cexp( ((0.,1.)*com)*dt )
      do i=1,n1
        x(i)=real(csave)
        y(i)=aimag(csave)
        csave=csave*cstep
      enddo



      k=n1
      do while (k.lt.n)
        csave=cmplx(x(k),y(k))*cstep
        s1=real(csave)
        s2=aimag(csave)
        k1=min0(2*k,n)
        knum=k1-k
        kstart=k+1
c        call scopy(knum,x(1),1,x(kstart),1)
C$DOIT IVDEP
        do i=1,knum
          x(kstart+i-1)=x(i)
        enddo
c        call sscal(knum,s1,x(kstart),1)
C$DOIT IVDEP
        do i=1,knum
          x(kstart+i-1)=s1*x(kstart+i-1)
        enddo
c        call saxpy(knum,-s2,y(1),1,x(kstart),1)
C$DOIT IVDEP
        do i=1,knum
          x(kstart+i-1)=x(kstart+i-1)-s2*y(i)
        enddo
c        call scopy(knum,x(1),1,y(kstart),1)
C$DOIT IVDEP
        do i=1,knum
          y(kstart+i-1)=x(i)
        enddo
c        call sscal(knum,s2,y(kstart),1)
C$DOIT IVDEP
        do i=1,knum
          y(kstart+i-1)=s2*y(kstart+i-1)
        enddo
c        call saxpy(knum,s1,y(1),1,y(kstart),1)
C$DOIT IVDEP
        do i=1,knum
          y(kstart+i-1)=y(kstart+i-1)+s1*y(i)
        enddo
        k=k1
      enddo
      csave=cexp( ((0.,1.)*com)*t0 )*rfac
      s1=real(csave)
      s2=-aimag(csave)
c      call sscal(n,s1,x(1),1)
C$DOIT IVDEP
      do i=1,n
        x(i)=s1*x(i)
      enddo
c      call saxpy(n,s2,y(1),1,x(1),1)
C$DOIT IVDEP
      do i=1,n
        x(i)=x(i)+s2*y(i)
      enddo
#elif ( defined(MachineZ) )
        tt1=-aimag(com)
        tt2=real(com)
        do i=1,n
          arg=t0+(i-1)*dt
          x(i)=exp(tt1*arg)*cos(tt2*arg)*rfac
        enddo
#else
        csave=cexp( ((0.,1.)*com)*t0 )*rfac
        cstep=cexp( ((0.,1.)*com)*dt )
        do i=1,n
          x(i)=real(csave)
          csave=csave*cstep
        enddo
#endif
      return
      end
