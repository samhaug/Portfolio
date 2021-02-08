cbend
      subroutine stupr(lumes,urot)
      common/hetmdl/ifani,lmax,lmaxm1,leny,npar,pertm(588),bmdl(588)
      common/lmmdl/lmaxl,lmaxl1,lenl,npml,pertl(588),bmdll(588)
      double precision d
      common/legwk/wk1(9),wk2(9),wk3(9),sar(11),d(17,17)
     1   ,vec1(34),vec2(34),ylmh(81),ylmt(81),ylmh1(81),ylmt1(81)
      dimension urot(3,3)
      data radian/57.29578/
      data ifirst/1/
      if(ifirst.ne.1) goto 10
      ifirst=0
      write(lumes,11)
   11 format(' do you wish to type:'/
     1      ,' ends of segment of new equator (1)'/
     2      ,' location and azimuth for left of plot (2)'/
     3      ,' location and azimuth for center of plot (3)'/'*')
      read(lumes,12) itype
   12 format(i1)
   10 if(itype.eq.1) goto 236
      write(lumes,31)
   31 format(' type latitiude, longitude, azimuth'/
     1      '***.** ****.** ****.**')
      read(lumes,32) epla,eplo,azim
   32 format(f6.2,1x,f7.2,1x,f7.2)
      call pdaz(epla,eplo,azim,90.,stla,stlo)
      goto 20
  236 write(lumes,239)
  239 format(' type latitude and longitudes of segment of'
     1 ,' new equator'/'***.** ****.** ***.** ****.**')
      read(lumes,238) eplar,eplor,stlar,stlor
  238 format(f6.2,f8.2,f7.2,f8.2)
      if(eplar.eq.0..and.eplor.eq.0..and.
     1 stlar.eq.0..and.stlor.eq.0.) goto 237
      stla=stlar
      stlo=stlor
      epla=eplar
      eplo=eplor
  237 if(stla.eq.epla.and.stlo.eq.eplo) goto 236
c
   20 call pole(epla,eplo,stla,stlo,xlatp,xlonp,azmp,delta)
c
      alph=xlonp/radian
      beta=(90.-xlatp)/radian
      gama=(180.-azmp-.5*delta)/radian
      if(itype.eq.3) gama=gama-180./radian
c
      write(lumes,5) epla,eplo,stla,stlo
     1  ,xlatp,xlonp,delta,azmp,alph*radian,beta*radian
     1   ,gama*radian
    5 format(' epicenter:',f8.2,f9.2,
     1  2x,1x,f8.2,f9.2/
     1  ,' xlatp',f7.2,' xlonp',f8.2,' delta',f7.2,' azmp',f8.2/
     1       ' alph', f8.2,' beta' ,f8.2,' gama', f8.2)
c
c
      call rotvc(pertm,lmax,npar,alph,beta,gama,d,vec1,vec2,bmdl)
      call rotvc(pertl,lmaxl,npml,alph,beta,gama,d,vec1,vec2,bmdll)
c
c
      call setrot(alph,beta,gama,urot)
      return
      end
