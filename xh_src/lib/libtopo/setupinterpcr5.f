c ----------------------------------------------------------------

      subroutine setupinterpcr5()

      character*120 ifl

      parameter(MXL=80)
      parameter(MXLENY=(MXL+1)**2)
      parameter(MXP=11)

      common/intcrust/lmax,parr(MXP,2),ctt(MXLENY,MXP,2),topo(MXLENY)

      character*5 inpps(MXP),inppp(MXP)
      data inpps/'p1210','p1070','22','35','50','65','80','95','102','50c','01c'/
      data inppp/'p655','p590','24','36','49','61','73','85','98','50c','01c'/

c     read in S tt anomaly maps
      do i=1,MXP
       istore=MXP-i+1
       li=istlen(inpps(i))
       ifl='/home/seiraid4/hendrikv/dta/crust/crusttt.S.'//inpps(i)(1:li)//'.raw'
       open(31,file=ifl,status='old')
       read(31,*) lmax,parr(istore,1)
       if(lmax.ne.36) stop 'interpcrust: lmax.ne.36'
       if(lmax.gt.MXL) stop 'interpcrust: lmax.gt.MXL'
       leny=(lmax+1)**2
       read(31,'(5e16.8)') (ctt(k,istore,1),k=1,leny)
       close(31)
      enddo

c     read in P tt anomaly maps
      do i=1,MXP
       istore=MXP-i+1
       li=istlen(inppp(i))
       ifl='/home/seiraid4/hendrikv/dta/crust/crusttt.P.'//inppp(i)(1:li)//'.raw'
       open(31,file=ifl,status='old')
       read(31,*) lmax,parr(istore,2)
       if(lmax.ne.36) stop 'interpcrust: lmax.ne.36'
       if(lmax.gt.MXL) stop 'interpcrust: lmax.gt.MXL'
       leny=(lmax+1)**2
       read(31,'(5e16.8)') (ctt(k,istore,2),k=1,leny)
       close(31)
      enddo

c     read in topography
      ifl='/home/seiraid4/hendrikv/dta/crust/topo.raw'
      open(31,file=ifl,status='old')
      read(31,*) lmax
      if(lmax.ne.36) stop 'interpcrust: lmax.ne.36'
      if(lmax.gt.MXL) stop 'interpcrust: lmax.gt.MXL'
      leny=(lmax+1)**2
      read(31,'(5e16.8)') (topo(k),k=1,leny)
      close(31)



      end

      
