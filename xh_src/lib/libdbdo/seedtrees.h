      common/seedtrees/
     1      itrtstn
     1         ,itabr(MXDICTS),itabrh(MXDICTS),lsabr(MXDICTS)
     1         ,itstns
     1             ,itstn
     1                 ,itstccl,msstccl,mtstccl
     1                 ,itsticl,mssticl,mtsticl
     1                 ,itchns
     1                     ,itchn
     1                         ,itchccl,mschccl,mtchccl
     1                         ,itchicl,mschicl,mtchicl
     1                         ,itchrcl,mschrcl,mtchrcl
     1     ,itrtblk
     1         ,itsblock,itsblockh,lssblock
     1         ,itresp,itresph,lsresp
     1     ,itrttsr
     1         ,itsttsr
     1             ,itchpcl,mschpcl,mtchpcl
     1     ,itrtvlm
     1         ,itvlabr,itvlabrh,lsvlabr
     1         ,itblabr,itblabrh,lsblabr
     1         ,itvlbl
      character*5 stnopen
      character*16 chnopen
      integer*2 jchnopen(8)
      integer*4 ichnopen(4)
      equivalence (jchnopen,ichnopen,chnopen)
      character*4 csbopen
      character*8 chzopen
      character*3 cftopen
      character*100 netopen
      common/opnstch/inetopen,ichnopen,lnetopen,stnopen,netopen,csbopen,chzopen,cftopen
      

