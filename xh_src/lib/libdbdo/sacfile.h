      integer sacheader

      character*16 
     1   sackevnm
      character*8
     1   sackstnm     ,sackevnm1    ,sackevnm2
     1 , sackhole     , sacko       , sacka
     1 , sackt0       , sackt1      , sackt2
     1 , sackt3       , sackt4      , sackt5
     1 , sackt6       , sackt7      , sackt8
     1 , sackt9       , sackf       , sackuser0
     1 , sackuser1    , sackuser2   , sackcmpnm
     1 , sacknetwk    , sackdatrd   , sackinst

      real
     1   sacdelta     , sacdepmin   , sacdepmax  , sacscale     , sacodelta
     1 , sacb         , sace        , saco       , saca         , sacinternal1
     1 , sact0        , sact1       , sact2      , sact3        , sact4
     1 , sact5        , sact6       , sact7      , sact8        , sact9
     1 , sacf         , sacresp0    , sacresp1   , sacrep2      , sacresp3
     1 , sacresp4     , sacresp5    , sacresp6   , sacrep7      , sacresp8
     1 , sacresp9     , sacstla     , sacstlo    , sacstel      , sacstdp
     1 , sacevla      , sacevlo     , sacevel    , sacevdp      , sacunused1
     1 , sacuser0     , sacuser1    , sacuser2   , sacuser3     , sacuser4
     1 , sacuser5     , sacuser6    , sacuser7   , sacuser8     , sacuser9
     1 , sacdist      , sacaz       , sacbaz     , sacgcarc     , sacinternal2
     1 , sacinternal3 , sacdepmen   , saccmpaz   , saccmpinc    , sacunused2
     1 , sacunused3   , sacunused4  , sacunused5 , sacunused6   , sacunused7
     1 , sacunused8   , sacunused9  , sacunuseda , sacunusedb   , sacunusedc

      integer
     1   sacnzyear    , sacnzjday   , sacnzhour  , sacnzmin     , sacnzsec
     1 , sacnzmsec    , sacnvhdr    ,sacinternal4, sacinternal5 , sacnpts
     1 , sacinternal6 , sacinternal7,sacunusedd  , sacunusede   , sacunusedf
     1 , saciftype    , sacidep     ,saciztype   , sacunusedg   , saciinst
     1 , sacistreg    ,sacievreg    ,sacievtyp   , saciqual     , sacisynth
     1 , sacunusedh   , sacunusedi  , sacunusedj , sacunusedk   , sacunusedl
     1 , sacunusedm   , sacunusedn  , sacunusedo , sacunusedp   , sacunusedq

      logical*4
     1   sacleven     , saclpspol   , saclovrok  , saclcalda    , sacunusedr

      common/sacfile/
     1   sacdelta     , sacdepmin   , sacdepmax  , sacscale     , sacodelta
     1 , sacb         , sace        , saco       , saca         , sacinternal1
     1 , sact0        , sact1       , sact2      , sact3        , sact4
     1 , sact5        , sact6       , sact7      , sact8        , sact9
     1 , sacf         , sacresp0    , sacresp1   , sacrep2      , sacresp3
     1 , sacresp4     , sacresp5    , sacresp6   , sacrep7      , sacresp8
     1 , sacresp9     , sacstla     , sacstlo    , sacstel      , sacstdp
     1 , sacevla      , sacevlo     , sacevel    , sacevdp      , sacunused1
     1 , sacuser0     , sacuser1    , sacuser2   , sacuser3     , sacuser4
     1 , sacuser5     , sacuser6    , sacuser7   , sacuser8     , sacuser9
     1 , sacdist      , sacaz       , sacbaz     , sacgcarc     , sacinternal2
     1 , sacinternal3 , sacdepmen   , saccmpaz   , saccmpinc    , sacunused2
     1 , sacunused3   , sacunused4  , sacunused5 , sacunused6   , sacunused7
     1 , sacunused8   , sacunused9  , sacunuseda , sacunusedb   , sacunusedc
     1 , sacnzyear    , sacnzjday   , sacnzhour  , sacnzmin     , sacnzsec
     1 , sacnzmsec    , sacnvhdr    ,sacinternal4, sacinternal5 , sacnpts
     1 , sacinternal6 , sacinternal7,sacunusedd  , sacunusede   , sacunusedf
     1 , saciftype    , sacidep     ,saciztype   , sacunusedg   , saciinst
     1 , sacistreg    ,sacievreg    ,sacievtyp   , saciqual     , sacisynth
     1 , sacunusedh   , sacunusedi  , sacunusedj , sacunusedk   , sacunusedl
     1 , sacunusedm   , sacunusedn  , sacunusedo , sacunusedp   , sacunusedq
     1 , sacleven     , saclpspol   , saclovrok  , saclcalda    , sacunusedr
     1 , sackstnm     , sackevnm1   ,sackevnm2
     1 , sackhole     , sacko       , sacka
     1 , sackt0       , sackt1      , sackt2
     1 , sackt3       , sackt4      , sackt5
     1 , sackt6       , sackt7      , sackt8
     1 , sackt9       , sackf       , sackuser0
     1 , sackuser1    , sackuser2   , sackcmpnm
     1 , sacknetwk    , sackdatrd   , sackinst

      equivalence (sackevnm,sackevnm1)
 
      parameter (NSACREAL=70)
      real sacreal(NSACREAL)
      equivalence (sacreal(1),sacdelta,sacheader)

      parameter (NSACINTEGER=35)
      integer sacinteger(NSACINTEGER)
      equivalence (sacinteger(1),sacnzyear)
     
      parameter (NSACLOGICAL=5)
      logical*4 saclogical(NSACLOGICAL)
      equivalence (saclogical(1),sacleven)

      parameter (NSACCHARACTER=48)
      character*4 saccharacter(NSACCHARACTER)
      parameter (NSACCHAR8=NSACCHARACTER/2)
      character*8 sacchar8(NSACCHAR8)
      equivalence (saccharacter(1),sacchar8(1),sackstnm)

      character*12 sacrdesc,sacidesc,sacldesc,saccdesc
      common/sacdesc/sacrdesc(NSACREAL),sacidesc(NSACINTEGER)
     1              ,sacldesc(NSACLOGICAL),saccdesc(NSACCHAR8)

      integer SACHEADWORDS,SACHEADBYTES
      parameter (SACHEADWORDS=NSACREAL+NSACINTEGER+NSACLOGICAL+NSACCHARACTER)
      parameter(SACHEADBYTES=4*SACHEADWORDS)


