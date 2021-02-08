      parameter (MXSTNO=600)
      parameter (MXCHNO=10000)
      parameter (MXRATE=10)
      character*5 stnopnd,stnseld
      character*16 chnopnd,chnseld
      character*24 timelo,timehi,timelor,timehir
      character*10000 stpatt
      character*200 chpatt
      common/dbdocm/kntstno,iofchno(MXSTNO),kntchno(MXSTNO)
     1     ,inetopnd(MXSTNO),nrates,rates(MXRATE)
     1     ,stnopnd(MXSTNO),chnopnd(MXCHNO),latest(MXCHNO)
     1     ,timelo,timehi,timelor,timehir
     1     ,stpatt,lstpatt,chpatt,lchpatt
     1     ,inetseld,stnseld,chnseld
