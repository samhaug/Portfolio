      structure/ttdta/
       character*3 netw
       character*7 cmt
       character*8 stnm
       byte id,ich,ph1,br1,ph2,br2,iabs,icrtp,imima,idum2
       byte ifit,iwvshape,isecondmax,itracemax,iuseful
       real*4 elat,elon,edep,slat,slon,selev,t,dtellip,dtcrust,dtmod,dtreloc
       real*4 snr,enr,t_err,wt,a1,a2
      end structure

      structure/ttdtaold/
       character*3 netw
       character*7 cmt
       character*8 stnm
       byte id,ich,ph1,br1,ph2,br2,iabs,icrtp,imima,idum2,ifit,iwvshape,iuseful
       real*4 elat,elon,edep,slat,slon,selev,t,dtellip,dtcrust,dtmod,error,wt,a1,a2
      end structure

      structure/ttdtaolder/
       character*4 stnm,netw
       character*7 cmt
       byte id,ich,ph1,br1,ph2,br2,iabs,icrtp,imima,idum2
       real*4 elat,elon,edep,slat,slon,selev,t,dtellip,dtcrust,dtmod,error,wt,a1,a2
      end structure

      structure/ttdtaoldest/
       character*4 stnm
       byte id,ich,ph1,br1,ph2,br2,iabs,icrtp,idum1,idum2
       real*4 elat,elon,edep,slat,slon,t,dtellip,dtcrust,error,wt
      end structure

