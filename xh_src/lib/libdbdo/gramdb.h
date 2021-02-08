c     parameter(MXCHOPEN=3)
c     common/gramdb/itgram
c    1                ,itgrams
c    1                   ,itchng(MXCHOPEN)
c    1 ,nchngopen



      integer OGHITG,OGHTGS,OGHTCG,OGHNOP
      parameter (MXCHOPEN=3)
      parameter (OGHITG=0)              
          parameter (OGHTGS=OGHITG+1)
              parameter (OGHTCG=OGHTGS+1)
      parameter (OGHNOP=OGHTCG+MXCHOPEN)
      parameter (LNGRMHD=OGHNOP+1)


