      subroutine relph(lumes,polsh,ifnorm)
      common/hetmdl/ifani,lmaxm,lmaxm1,leny,npmm,pertm(588),bmdl(588)
      dimension polsh(121)
      dimension aker(10),amp(12)
      rt2=sqrt(2.)
      write(lumes,1)
    1 format('plot frequency shifts for model?')
      read(15,2) ifcont
    2 format(i1)
      if(ifcont.eq.0) return
c
      write(lumes,9)
    9 format('include odd harmonics?')
      read(15,11) ifodd
   11 format(i1)
      npmm=12+(ifani-1)*5
c
   20 write(lumes,3)
    3 format('type mode id'/'** x ***')
      read(15,4) nord,iatyp,lord
    4 format(i2,1x,a1,1x,i3)
c
      call getker(nord,iatyp,lord,amp,aker,ifgot)
c
      if(ifgot.ne.1) goto 20
      factor=amp(1)*6371./((float(lord)+.5)*amp(5))
      nnker=5
      if(npmm.eq.12) nnker=10
      write(lumes,7) lmaxm
    7 format('maximum l of model =',i4)
      istep=2
      if(ifodd.ne.0) istep=1
      k=0
      do 50 l1=1,lmaxm1,istep
      l=l1-1
      numm=2*l+1
      ind=l**2
      do 60 im=1,numm
      fac=factor
      if(im.eq.1.and.ifnorm.eq.1) fac=rt2*factor
      k=k+1
      iadd=ind+im
      polsh(k)=0.
      do 70 iker=1,nnker
   70 polsh(k)=polsh(k)+fac*pertm(iadd+leny*(iker+1))*aker(iker)
      polsh(k)=polsh(k)+fac*pertm(iadd)*amp(7)+pertm(iadd+leny)*amp(8)
   60 polsh(k)=polsh(k)*100./amp(1)
   50 continue
      return
      end
