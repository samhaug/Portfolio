      integer*4 FRSOSN,FRSFOV,FRSSRT,FLENRS,FSGGAI,FSGFGA
     1         ,FSGEDL,FSGCAP,FSGINR,FSGAZE,FSGFAZ,FLENSG,FSGXNM
     1         ,FRSLAT,FRSLON,FRSELV,FRSDEP,FRSAZM,FRSDIP,FRSDRF


      parameter (IRSLID=0)                ! location id string
      parameter (IRSCID=IRSLID+1)         ! channel id string
      parameter (IRSSUB=IRSCID+1)         ! subchannel
      parameter (IRSOCM=IRSSUB+1)         ! optional comment
      parameter (IRSNCS=IRSOCM+8)                 ! number of stages
      parameter (IRSPOW=IRSNCS+1)                 ! power (0=displacement etc.)
      parameter (FRSOSN=(IRSPOW+LENFLT)/LENFLT)
      parameter (FRSFOV=FRSOSN+1)
      parameter (FRSSRT=FRSFOV+1)
      parameter (FRSLAT=FRSSRT+1)          ! channel latitiude
      parameter (FRSLON=FRSLAT+1)          ! channel longitude
      parameter (FRSELV=FRSLON+1)          ! channel elevation
      parameter (FRSDEP=FRSELV+1)          ! channel local depth
      parameter (FRSAZM=FRSDEP+1)          ! channel azimuth
      parameter (FRSDIP=FRSAZM+1)          ! channel dip
      parameter (FRSDRF=FRSDIP+1)          ! drift
      parameter (FLENRS=FRSDRF+1)
      parameter (ILENRS=FLENRS*LENFLT)
        parameter (ISGADN=0)
        parameter (ISGADL=ISGADN+1)
        parameter (ISGDCF=ISGADL+1)
        parameter (ISGDCO=ISGDCF+1)
        parameter (ISGPZC=ISGDCO+1)
        parameter (ISGABD=ISGPZC+1)
        parameter (ISGINU=ISGABD+1)
        parameter (ISGOUU=ISGINU+1)
        parameter (ISGNTP=ISGOUU+1)
        parameter (ISGNBT=ISGNTP+1)
        parameter (ISGLNT=ISGNBT+1)
        parameter (FSGGAI=(ISGLNT+LENFLT)/LENFLT)
        parameter (FSGFGA=FSGGAI+1)
        parameter (FSGEDL=FSGFGA+1)
        parameter (FSGCAP=FSGEDL+1)
        parameter (FSGINR=FSGCAP+1)
        parameter (FSGAZE=FSGINR+1)
        parameter (FSGFAZ=FSGAZE+1)
        parameter (FSGXNM=FSGFAZ+1)
        parameter (FLENSG=FSGXNM+1)
        parameter (ILENSG=FLENSG*LENFLT)
        
