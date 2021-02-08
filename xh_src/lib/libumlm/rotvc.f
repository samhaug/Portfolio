      subroutine rotvc(amdl,lmax,npar,alph,beta,gama,d,vec1,vec2,bmdl)
      dimension amdl(1),bmdl(1)
      double precision dbeta,d(1)
      complex vec1(1),vec2(1),fct,ealph,egama
c
      lmax1=1+lmax
      leny=lmax1**2
      dbeta=beta
c
      do 100 il=1,lmax1
      l=il-1
      l21=l+il
c
      call rotmx2(l,l,dbeta,d,l21,l21)
      ealph=cexp(cmplx(0.,alph))
      egama=cexp(cmplx(0.,gama))
c
      do 10 ipar=1,npar
      ind0=(ipar-1)*leny+l**2
c
      ind1=ind0
      do 20 im=1,il
      imp=l+im
      imm=1+il-im
      ind1=1+ind1
      ind2=1+ind1
      if(im.eq.1) vec1(imp)=cmplx(amdl(ind1),0.)
      if(im.ne.1) vec1(imp)=cmplx(.5*amdl(ind1),-.5*amdl(ind2))
      if(im.ne.1) ind1=ind2
      vec1(imm)=conjg(vec1(imp))
      if((im/2)*2.eq.im) vec1(imm)=-vec1(imm)
   20 continue
c
      fct=(1.,0.)
      do 30 im=1,il
      imp=l+im
      imm=1+il-im
      vec1(imp)=vec1(imp)*fct
      vec1(imm)=vec1(imm)*conjg(fct)
   30 fct=fct*ealph
c
      do 40 im=1,l21
      vec2(im)=(0.,0.)
      do 50 jm=1,l21
      ind=im+l21*(jm-1)
   50 vec2(im)=vec2(im)+d(ind)*vec1(jm)
   40 continue
c
      fct=(1.,0.)
      do 60 im=1,il
      imp=l+im
      imm=1+il-im
      vec2(imp)=vec2(imp)*fct
      vec2(imm)=vec2(imm)*conjg(fct)
   60 fct=fct*egama
c
      k=ind0
      do 70 im=1,il
      lim=l+im
      k=k+1
      bmdl(k)=real(vec2(lim))
      if(im.eq.1) goto 70
      bmdl(k)=2.*bmdl(k)
      k=k+1
      bmdl(k)=-2.*aimag(vec2(lim))
   70 continue
c
   10 continue
c
  100 continue
      return
      end
