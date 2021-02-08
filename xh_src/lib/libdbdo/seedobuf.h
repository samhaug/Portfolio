      parameter (MXLRECO=4096)
      integer*4 ibufo(MXLRECO/4)
      integer*2 jbufo(MXLRECO/2)
      equivalence (ibufo(1),jbufo(1))
      common/buffero/luto,lreco,ireco,ibyteo,ibufo
      character*1 cbufo(MXLRECO)
      equivalence (ibufo,cbufo)
