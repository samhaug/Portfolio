cprog rotmx2
cxref
      subroutine rotmx2(nmax,l,theta,d,id1,id2)
      implicit double precision (a-h,o-z)
      double precision d,theta
      dimension d(id1,id2)
c     data big,small,dlbig,dlsml/1.d35,1.d-35,35.d0,-35.d0/
      data big,small,dlbig,dlsml/1.d25,1.d-25,25.d0,-25.d0/
      data pi/3.14159265358979d0/
      dfloat(n)=n
      th=theta
      if((th.gt.pi).or.(th.lt.0.d0)) stop 'illegal arg in rotmx2'
      if(l.eq.0) then
        d(1+nmax,l+1)=1.d0
        return
      endif
      isup=1
      if(th.gt.pi/2.d0) then
        th=pi-th
        isup=-1
      endif
      nm=2*l+1
      nmp1=nm+1
      lp1=l+1
      lm1=l-1
      lp2=l+2
      nrow=2*nmax+1
      nmaxp1=nmax+1
      lmn=l-nmax
      if(th.eq.0.d0) then
        do im1ct=1,nrow
          im1=im1ct+lmn
          do im2=lp1,nm
            d(im1ct,im2)=0.d0
            if(im1.eq.im2) d(im1ct,im2)=1.d0
          enddo
        enddo
        goto 400
      else
c
c     zero l.h.s. of matrix
c
        do im1=1,nrow
          do im2=1,lp1
            d(im1,im2)=0.d0
          enddo
        enddo
c
c        set up parameters
c
        shth=dsin(0.5d0*th)
        chth=dcos(0.5d0*th)
        sth=2.d0*shth*chth
        cth=2.d0*chth*chth-1.d0
        dlogf=dlog10(chth/shth)
        dlogs=dlog10(shth)
c
c       iterate from last column using 1. as starting value
c
        do im1ct=1,nrow
          im1=im1ct+lmn
          m1=im1-lp1
          rm1=m1
          nm2=min0(im1-1,nm-im1)
          d(im1ct,nm)=1.d0
          do nit=1,nm2
            m2=l-nit
            im2=m2+lp1
            if(m2.eq.lm1) then
               t1=0.d0
            else
              t1=-dsqrt(dfloat((im2+1)*(l-m2-1)))*d(im1ct,im2+2)
            endif
            d(im1ct,im2)=t1-(2.d0/sth)*(cth*dfloat(m2+1)-rm1)
     1          *d(im1ct,im2+1)
            d(im1ct,im2)=d(im1ct,im2)/dsqrt(dfloat(im2*(l-m2)))  
            temp=d(im1ct,im2)
            rmod=dabs(temp)
            if(rmod.ge.big.and.nit.ne.nm2) then
              d(im1ct,nit+1)=dlbig
              d(im1ct,im2)=d(im1ct,im2)/big
              d(im1ct,im2+1)=d(im1ct,im2+1)/big
            endif
          enddo
        enddo
c
c        set up normalization for rightmost column
c
        t1=dfloat(2*l)*dlogs
        do m1=0,lmn-1
          t1=dlogf+0.5d0*dlog10(dfloat(lp1-m1)/dfloat(l+m1))+t1
        enddo
        d(1,1)=t1
        do im1ct=2,nrow
          m1=im1ct-nmaxp1
          d(im1ct,1)=dlogf+0.5d0*dlog10(dfloat(l-m1+1)/dfloat(l+m1))+d(im1ct-1,1)
        enddo
        sgn=-1.d0
        if((lmn/2)*2.ne.lmn) sgn=1.d0
c
c       renormalize rows
c
        do im1ct=1,nrow
          im1=im1ct+lmn
          sgn=-sgn
          csum=d(im1ct,1)
          mult=1
          do while(dabs(csum).ge.dlbig)
            mult=mult*2
            csum=0.5*csum
          enddo
        
          fac=10.d0**csum
          sfac=small/fac
          nm2=min0(im1-1,nm-im1)
          nm2p1=nm2+1
          do im2=1,nm2p1
            if((d(im1ct,im2+1).ne.0.d0).and.(im2.lt.nm2)) then
              csum=csum*dfloat(mult)+d(im1ct,im2+1)
              mult=1
              do while(dabs(csum).ge.dlbig)
                mult=mult*2
                csum=0.5d0*csum
              enddo
              fac=10.d0**csum
              sfac=small/fac
            endif

            in2=nmp1-im2
            do i=1,mult
              temp=d(im1ct,in2)
              rmod=dabs(temp)
              if(rmod.le.sfac) then
                d(im1ct,in2)=0.d0
                goto 130
              else
                d(im1ct,in2)=d(im1ct,in2)*fac
              endif
              d(im1ct,in2)=sgn*d(im1ct,in2)
            enddo
 130        continue
          enddo
        enddo

      endif
c
c       fill rest of matrix
c
400   if(isup.le.0) then
        sgn=-1.d0
        if((lmn/2)*2.ne.lmn) sgn=1.d0
        do im1ct=1,nrow
          sgn=-sgn
          im1=im1ct+lmn
          nm2=min0(im1,nmp1-im1)
          do in2=1,nm2
            im2=nmp1-in2
            d(im1ct,in2)=sgn*d(im1ct,im2)
          enddo
        enddo
        do 430 im1ct=1,nrow
          im1=im1ct+lmn
          in1=nmp1-im1
          in1ct=in1-lmn
          sgn=-1.d0
          nm2=min0(im1,in1)
          do 440 nit=1,nm2
            sgn=-sgn
            im2=1+nm2-nit
            in2=nmp1-im2
            im2ct=im2-lmn
            in2ct=in2-lmn
            d(in1ct,in2)=sgn*d(im1ct,im2)
            if(in2ct.le.nrow) then
              d(im2ct,im1)=d(in1ct,in2)
              d(in2ct,in1)=d(im1ct,im2)
            endif
          enddo
        enddo
      else
        do im1ct=1,nrow
          im1=im1ct+lmn
          in1=nmp1-im1
          in1ct=in1-lmn
          sgn=-1.d0
          nm2=min0(im1,in1)
          do nit=1,nm2
            sgn=-sgn
            im2=nm-nm2+nit
            in2=nmp1-im2
            im2ct=im2-lmn
            in2ct=in2-lmn
            d(in1ct,in2)=sgn*d(im1ct,im2)
            if(im2ct.le.nrow) then
              d(im2ct,im1)=d(in1ct,in2)
              d(in2ct,in1)=d(im1ct,im2)
            endif
          enddo
        endddo
      endif
      return
      end
