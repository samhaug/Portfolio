      parameter(MXNRCR=5)
      parameter(MXNRBR=10)
      parameter(MXNRCOD=10)
      parameter(MXNRCHAN=26)
      parameter(MXNRPHS=150)
      character*2 branch
      character*3 chan
      character*10 phs
      character*80 crustcor
      character*80 dtacode
      common/phslist/phs(MXNRPHS),lphs(MXNRPHS),chan(MXNRCHAN),
     1               branch(MXNRBR),dtacode(MXNRCOD),crustcor(MXNRCR)
