      parameter (MXEVTS=1000)
      common/evtpar/ nevt,itimevs(2,MXEVTS),xlatevs(MXEVTS),xlonevs(MXEVTS)
     1  ,xdepevs(MXEVTS),xmagevs(MXEVTS)

      parameter (MXPHSS=20)
      character*32 phasenm
      common/phsids/nphase,phsdel1,phsdel2,phasenm(MXPHSS),iphaddr(MXPHSS)
