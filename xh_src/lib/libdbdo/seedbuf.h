      integer*4 ibuf(8192)
      integer*2 jbuf(16384)
      equivalence (ibuf(1),jbuf(1))
      common/buffer/lut,lrec,lrech,nlrblk,i2bias,i4bias,irec,ibyte
     1 ,itype,icont,ibuf
      common/gotrcs/igot1,igot2,igotf
