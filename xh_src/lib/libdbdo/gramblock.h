      integer OGSTIRF,OGSTNAM,OGSTLAT,OGSTLON,OGSTELV,OGSTSIT,OGSTNET,OGSTNCM,OGSTCMS
     1       ,OGSTCME,OGSTCMT,LGSTCMT,OGSTCML,OGSTCMO,OGSTNCH,OGSTCHO,OGCHLID
     1       ,OGCHCID,OGCHSUB,OGCHINS,OGCHOCM,OGCHUNS,OGCHUNC,OGCHLAT,OGCHLON,OGCHELV
     1       ,OGCHDEP,OGCHAZM,OGCHDIP,OGCHFMT,OGCHKHZ,OGCHDRF,OGCHNCM,OGCHCMO,OGSPACE
     1       ,OGCHSGS,OGCHSGE,OGCHSGL,OGCHSGA,OGRSREF,OGSTCMU,OGRSBLO,OTSPACE,OTGETIT
     1       ,OTNGRAM,OTSBNPC,OTSBPAD,OTPCNSM,OTPCLUR,OTPCBYT,OGCHSGG,OGCHNPC
      parameter(LMXCHNL=3)                  ! max number of subchannels

      ! structure of gram table

      parameter(OTSPACE=0)                  ! space to be deallocated on closure
      parameter(OTNGRAM=OTSPACE+1)                  ! start address of table entries
      parameter(OTGETIT=OTNGRAM+1)                  ! start address of table entries
      parameter(LTGTHDR=OTGETIT+1)                  ! length of start of gram table
      parameter(OTSBNPC=2)                          ! number of pieces
      parameter(OTSBPAD=OTSBNPC+1)                  ! address of first piece entry
      parameter(LTSUBEN=OTSBPAD+1)                  ! length of a subchannel table entry
      parameter(OTPCNSM=8)                          ! number of samples
      parameter(OTPCLUR=OTPCNSM+1)                          ! logical unit
      parameter(OTPCBYT=OTPCLUR+1)                          ! byte address
      parameter(LTSBPCE=OTPCBYT+1)                  ! lenth of a piece entry
      parameter(OTNSUBS=5)                  ! offset of nsubs in table entry
      parameter(LTHEADR=OTNSUBS+1)           ! length of start of channel table entry
      parameter(LTENTRY=LTHEADR+LMXCHNL*LTSUBEN)    ! length of a table entry



      ! structure of station block  
   
      parameter(OGSPACE=0)                  ! space to be deallocated on closure
      parameter(OGSTIRF=OGSPACE+1)          ! station info key
      parameter(OGSTNAM=OGSTIRF+1)          ! station name
      parameter(LGSTNAM=2)               
      parameter(OGSTLAT=OGSTNAM+LGSTNAM)    ! latitiude
      parameter(OGSTLON=OGSTLAT+1)          ! longitude
      parameter(OGSTELV=OGSTLON+1)          ! elevation
      parameter(OGSTSIT=OGSTELV+1)          ! site name
      parameter(LGSTSIT=15)
      parameter(OGSTNET=OGSTSIT+LGSTSIT)    ! network name
      parameter(LGSTNET=13)               
      parameter(OGSTNCM=OGSTNET+LGSTNET)    ! number of station comments

          ! structure of station and channel comment blocks
          parameter(OGSTCMS=0)                   ! comment start time
          parameter(OGSTCME=OGSTCMS+2)           ! comment end time
          parameter(OGSTCMT=OGSTCME+2)           ! comment text
          parameter(LGSTCMT=18)
          parameter(OGSTCML=OGSTCMT+LGSTCMT)     ! comment level
          parameter(OGSTCMU=OGSTCML+1)           ! local units of comment
          parameter(LGSTCMB=OGSTCMU+1)           ! length of station comment block

      parameter(OGSTCMO=OGSTNCM+1)          ! address of start of station comments   
      parameter(OGSTNCH=OGSTCMO+1)          ! number of subchannels
      parameter(OGSTCHO=OGSTNCH+1)          ! addresses of channel blocks
      parameter(LGSTBLK=OGSTCHO+LMXCHNL)    ! length of station block

          !structure of channel blocks
          parameter(OGCHLID=0)                  ! location id string
          parameter(OGCHCID=OGCHLID+1)          ! channel id string
          parameter(OGCHSUB=OGCHCID+1)          ! subchannel
          parameter(OGCHINS=OGCHSUB+1)          ! instrument string
          parameter(LGCHINS=13)                 
          parameter(OGCHOCM=OGCHINS+LGCHINS)    ! optional comment
          parameter(LGCHOCM=8)
          parameter(OGCHUNS=OGCHOCM+LGCHOCM)    ! local units of signal response
          parameter(OGCHUNC=OGCHUNS+1)          ! local units of calibn. input 
          parameter(OGCHLAT=OGCHUNC+1)          ! channel latitiude
          parameter(OGCHLON=OGCHLAT+1)          ! channel longitude
          parameter(OGCHELV=OGCHLON+1)          ! channel elevation
          parameter(OGCHDEP=OGCHELV+1)          ! channel local depth
          parameter(OGCHAZM=OGCHDEP+1)          ! channel azimuth
          parameter(OGCHDIP=OGCHAZM+1)          ! channel dip
          parameter(OGCHFMT=OGCHDIP+1)          ! local format code
          parameter(OGCHKHZ=OGCHFMT+1)          ! local integer sample rate
          parameter(OGCHDRF=OGCHKHZ+1)          ! drift
          parameter(OGCHNCM=OGCHDRF+1)          ! number of channel comments

                                           ! see above for structure

          parameter(OGCHCMO=OGCHNCM+1)          ! address of start of channel comments
          parameter(OGCHSGS=OGCHCMO+1)          ! start time of seismogram
          parameter(OGCHSGE=OGCHSGS+2)          ! end time of seismogram
          parameter(OGCHSGL=OGCHSGE+2)          ! number of samples
          parameter(OGCHNPC=OGCHSGL+1)
          parameter(OGCHSGG=OGCHNPC+1)          ! number of missing samples
          parameter(OGCHSGA=OGCHSGG+1)          ! address of seismogram

          parameter(OGRSREF=OGCHSGA+1)          ! channel response key
          parameter(OGRSBLO=OGRSREF+1)          ! address of channel response block
          parameter(LGCHBLK=OGRSBLO+1)          ! length of channel block


              




      

      
