      subroutine initlin()

c     declarations for linear crustal perturbations
      parameter(MXLCR=(36+1)**2)
      common/lincrust/ilininit,etopowat(MXLCR),etoposol(MXLCR),cr51(MXLCR)

      open(114,file='/geo/home/jritsema/dta/crust/crust5.1.thick.raw',status='old')
      read(114,*) lmaxcr1
      numatd=(lmaxcr1+1)**2
      read(114,'(5e16.8)') (cr51(i),i=1,numatd)
      close(114)

      open(114,file='/geo/home/jritsema/dta/crust/etopo5.water.raw',status='old')
      read(114,*) lmaxcr2
      numatd=(lmaxcr2+1)**2
      read(114,'(5e16.8)') (etopowat(i),i=1,numatd)
      close(114)

      open(114,file='/geo/home/jritsema/dta/crust/etopo5.solid.raw',status='old')
      read(114,*) lmaxcr3
      numatd=(lmaxcr3+1)**2
      read(114,'(5e16.8)') (etoposol(i),i=1,numatd)
      close(114)

      if(lmaxcr1.ne.lmaxcr2.or.lmaxcr1.ne.lmaxcr3.or.lmaxcr2.ne.lmaxcr3) then
       stop 'initlin: unequal dimensions'
      endif

      ilininit=1

      end


