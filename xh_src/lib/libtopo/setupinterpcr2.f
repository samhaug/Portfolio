c ----------------------------------------------------------------

      subroutine setupinterpcr2(iice)

      character*120 ifl
      character*6 icestr

      parameter(MXL=80)
      parameter(MXLENY=(MXL+1)**2)
      parameter(MXP=11)

      common/intcrust/lmax,parr(MXP,2),ctt(MXLENY,MXP,2),topo(MXLENY)

      character*5 inpps(MXP),inppp(MXP)
      data inpps/'1210','1070','920','876','799','703','601','499','481','50','1'/
      data inppp/'655','590','520','490','438','388','339','286','254','50','1'/

      if(iice.eq.0) then
       icestr='no_ice'
       lis=6
      else if(iice.eq.1) then
       icestr='ice'
        lis=3
      else
       stop'setupinterpcr2: unknown iice'
      endif

c     read in S tt anomaly maps
      do i=1,MXP
       istore=MXP-i+1
       li=istlen(inpps(i))
       ifl='/home/seiraid4/hendrikv/dta/crust/crusttt_c2.S.'//inpps(i)(1:li)//'.'//icestr(1:lis)//'.raw'
       open(31,file=ifl,status='old')
       read(31,*) lmax,parr(istore,1)
       if(lmax.ne.80) stop 'interpcrust: lmax.ne.80'
       if(lmax.gt.MXL) stop 'interpcrust: lmax.gt.MXL'
       leny=(lmax+1)**2
       read(31,'(5e16.8)') (ctt(k,istore,1),k=1,leny)
       close(31)
      enddo

c     read in P tt anomaly maps
      do i=1,MXP
       istore=MXP-i+1
       li=istlen(inppp(i))
       ifl='/home/seiraid4/hendrikv/dta/crust/crusttt_c2.P.'//inppp(i)(1:li)//'.'//icestr(1:lis)//'.raw'
       open(31,file=ifl,status='old')
       read(31,*) lmax,parr(istore,2)
       if(lmax.ne.80) stop 'interpcrust: lmax.ne.80'
       if(lmax.gt.MXL) stop 'interpcrust: lmax.gt.MXL'
       leny=(lmax+1)**2
       read(31,'(5e16.8)') (ctt(k,istore,2),k=1,leny)
       close(31)
      enddo

c     read in topography
      ifl='/home/seiraid4/hendrikv/dta/crust/crust2_topo.raw'
      open(31,file=ifl,status='old')
      read(31,*) lmax
      if(lmax.ne.80) stop 'interpcrust: lmax.ne.80'
      if(lmax.gt.MXL) stop 'interpcrust: lmax.gt.MXL'
      leny=(lmax+1)**2
      read(31,'(5e16.8)') (topo(k),k=1,leny)
      close(31)



      end

      
