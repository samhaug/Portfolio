      include 'seedparam.h'
      parameter (MXCODES=40)
      parameter (MXCODPT=20)
c MXDICTS must be greater than the number of dictionaries,
c the maximum number or repeating entries and the maximum
c number of types
      parameter (MXREPTS=MXDICTS)
      parameter (MXTYPES=MXDICTS)

      character*3 codes(MXCODPT,MXTYPES)
      character*80 cdescrs(MXCODES)
      integer lcdescrs(MXCODES)
      integer indcods(MXCODPT,MXTYPES)
      integer codstat(MXCODES)
c codstat=0 if this kind of blockette is to be interpretted
c codstat=1 if blockette is unsupported
c codstat=2 if blockette is to be ignored
      parameter (INTRPC=0)
      parameter (IUNSPT=1)
      parameter (IGNORE=2)
      parameter (IREFCD=3)
      parameter (MXREFCD=2)
      character*3 codrefcd(MXREFCD)
      integer ncodes(MXTYPES)
      parameter (MXENTRY=30)
      character*8 fstr(MXENTRY,MXCODES)
      integer lfstr(MXENTRY,MXCODES)
      integer lenent(MXENTRY,MXCODES)
      integer entstat(MXENTRY,MXCODES)
      parameter (MXLEVLS=3)
      integer ientstt(MXLEVLS)
c mod(entstat,MXDICTS)=dictionary number (0 if not a dict key)
c or  = number of entries to be repeated
c or  = type or record to which sequence number refers
c entstat/MXDICTS     = 0 if entry is vanilla
c entstat/MXDICTS     = 1 if entry is to be looked up
c entstat/MXDICTS     = 2 if entry is to be inserted
c entstat/MXDICTS     = 3 if entry is a count value
c entstat/MXDIXTS     = 4 if entry is a sequence number
      parameter (NOTSPCL=0)
      parameter (LOOKUP=MXDICTS)
      parameter (INSERT=2*MXDICTS)
      parameter (ISCOUNT=3*MXDICTS)
      parameter (ISSEQNO=4*MXDICTS)
      parameter (ISZERO=5*MXDICTS)
      parameter (ISGOTN=6*MXDICTS)


      character*20 dictnams(MXDICTS)
      integer ldictnams(MXDICTS)
      integer numcodes
      integer numdicts
      character*30 edescr(MXENTRY,MXCODES)
      integer ledescr(MXENTRY,MXCODES)
      integer nument(MXCODES)

      parameter (MXKNOWN=60)
      parameter (MXFKNOW=3000)
      integer iknow(MXKNOWN+1),locfkn(MXKNOWN)
      character*(MXFKNOW) fknown
      character*50 fkndscr(MXKNOWN)
      integer lfkndscr(MXKNOWN)
      integer nknown,lfknown

      parameter (MXKNOWU=100)
      parameter (MXUKNOW=1000)
      integer iknowu(MXKNOWU+1),locukn(MXKNOWU)
      character*(MXUKNOW) uknown
      integer nknowu,nknowux,luknown,luknownx
      common/seeddefs/numcodes,numdicts
     1    ,indcods,codstat,ncodes,entstat,ientstt,nument,lenent
     1    ,lcdescrs,lfstr,ldictnams,ledescr
     1    ,iknow,locfkn,lfkndscr,nknown,lfknown
     1    ,iknowu,locukn,nknowu,nknowux,luknown,luknownx
     1    ,codes,cdescrs,fstr,dictnams,edescr,codrefcd
     1    ,fknown,fkndscr
     1    ,uknown

      parameter (MXDBFMTS=100)
      parameter (MXDBUNTS=50)
      common/mapfus/locfmc(MXDBFMTS),locunc(0:MXDBUNTS)


