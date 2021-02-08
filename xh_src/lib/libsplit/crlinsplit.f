      function crlinsplit(ind,crustsens)

c     declarations for linear crustal perturbations
      parameter(MXLCR=(36+1)**2)
      common/lincrust/ilininit,etopowat(MXLCR),etoposol(MXLCR),cr51(MXLCR)

      dimension crustsens(3)

c     calculate linear crustal correction
c     cr51 has 21.4 already subtracted, 100 is use because
c     maps were multiplied by .01 in invexpandxy

      if(ilininit.eq.0) call initlin()

      crlin=0.
      crlin=crlin+crustsens(1)*etopowat(ind)
      crlin=crlin+crustsens(2)*etoposol(ind)
      crlin=crlin+crustsens(3)*cr51(ind)
      crlin=crlin*100.
      crlinsplit=crlin

c     write(6,*) 'CRUSTSENS ',crustsens
c     write(6,*) 'ETOPOCR ',etopowat(ind),etoposol(ind),cr51(ind)

      end


