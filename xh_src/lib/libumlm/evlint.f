cprog evlint
      subroutine evlint(epla,eplo,stla,stlo,amdl,npar
     1  ,dotv,lmax,ylmh,ylmt,ylmh1,ylmt1,wk1,wk2,wk3,sar,d
     2  ,facr,amint1,amint2,alpin1,alpin2)
      double precision d(1)
      dimension amdl(1),dotv(1),ylmh(1),ylmt(1),ylmh1(1),ylmt1(1)
     1  ,wk1(1),wk2(1),wk3(1),sar(1)
c
      leny=(lmax+1)**2
      call ylmint(epla,eplo,stla,stlo,lmax,ylmh,ylmt
     1   ,ylmh1,ylmt1,wk1,wk2,wk3,sar,d)
      dmint1=0.
      dmint2=0.
      dlpin1=0.
      dlpin2=0.
      do 20 ipar=1,npar
      ind=leny*(ipar-1)
      do 30 il=1,leny
      ind=1+ind
      fct=dotv(ipar)*amdl(ind)
      dmint1=dmint1+fct*ylmt(il)
      dmint2=dmint2+fct*ylmh(il)
      dlpin1=dlpin1+fct*ylmt1(il)
      dlpin2=dlpin2+fct*ylmh1(il)
   30 continue
   20 continue
      amint1=dmint1*facr
      amint2=dmint2*facr
      alpin1=dlpin1*facr
      alpin2=dlpin2*facr
      return
      end
