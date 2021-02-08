      Program rantest

      real maxsol,alpha,beta,f1,sol(50),f2,rfact(50),maxstep,en
      character*6 filenm
      integer idum,nrpar,h,norder
      data idum /-.5/
      dum=ran1(idum)
      

      Write(6,*) 'Geef maxstep,nrpar,norder'
      Read(5,*) maxstep,nrpar,norder

      write(6,*) maxsol

      Do h=1,20
c      sol(1)=maxsol*2*(ran1(idum)-0.5)
c      sol(2)=beta*sol(1)+(1-beta)*2*maxsol*(ran1(idum)-0.5)

c      f1=1-alpha-beta
c      Do j=3,nrpar+1
c       sol(j)=alpha*sol(j-2)+beta*sol(j-1)+f1*2*maxsol*(ran1(idum)-0.5)
c      Enddo

c      Do j=1,nrpar
c       sol(j)=sol(j+1)
c      Enddo
 
        tpi=8.*atan(1.)

        n=nrpar
        Do i=1,norder*2
         rfact(i)=maxstep*(ran1(idum)-.5)
        Enddo
        Do i=1,n
         sol(i)=0
        Enddo

        Do i=1,n
         Do j=1,norder*2,2
          en=float(n)
          f1=(float(i*(j-1)))/en
          f2=f1*tpi/2.
          sol(i)=sol(i)+rfact(j)*cos(f2)
          sol(i)=sol(i)+rfact(j+1)*sin(f2)
         Enddo
        Enddo

       write(filenm,21) h
21     Format('data',i2)
       call wxvgr(filenm,sol,nrpar,0.,1.,0,0)
      Enddo
      
      End

c -------------------------------------------------------------

      FUNCTION ran1(idum)
      INTEGER idum,IA,IM,IQ,IR,NTAB,NDIV
      REAL ran1,AM,EPS,RNMX
      PARAMETER (IA=16807,IM=2147483647,AM=1./IM,IQ=127773,IR=2836,
     1 NTAB=32,NDIV=1+(IM-1)/NTAB,EPS=1.2e-7,RNMX=1.-EPS)
      INTEGER j,k,iv(NTAB),iy
      SAVE iv,iy
      DATA iv /NTAB*0/, iy /0/
      if (idum.le.0.or.iy.eq.0) then
        idum=max(-idum,1)
        do 11 j=NTAB+8,1,-1
          k=idum/IQ
          idum=IA*(idum-k*IQ)-IR*k
          if (idum.lt.0) idum=idum+IM
          if (j.le.NTAB) iv(j)=idum
11      continue
        iy=iv(1)
      endif
      k=idum/IQ
      idum=IA*(idum-k*IQ)-IR*k
      if (idum.lt.0) idum=idum+IM
      j=1+iy/NDIV
      iy=iv(j)
      iv(j)=idum
      ran1=min(AM*iy,RNMX)
      return
      END

c ---------------------------------------------------------------


      Subroutine wxvgr(nm,x,np,t0,dtee,ifwrap,ifmid)

      character*15 nm
      dimension x(*),res(2048)
      integer np,ifwrap,ifmid
      real t0

      If (ifwrap.eq.1) Then
          Write(6,*) 'tijdelijk niet beschikbaar'
      Else
          Do j=1,np
           res(j)=x(j)
          Enddo
      Endif
      Open(11,file=nm,status='unknown')
       tmid=0
       If(ifmid.eq.1) tmid=(np/2)*dtee
       Do j=1,np
          tee=t0+dtee*(j-1)-tmid
          write(11,35) tee,res(j)
35        Format(g15.7,x,g15.7)
       Enddo
       Close(11)

       End
