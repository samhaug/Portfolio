      integer
     1  OTRFR,OTROR,OTRLK,OTRLI,OTRTP,VTRAK,VTRIK,VTRFK,VTRDK,VTRHK
     1 ,OTRST,OTRML,OTRPA,OTRKY,OTRLV,OTRUX,OTRKO,OTRNR,OTRFA,OTRLO
     1 ,OTRLN,OTRNM,ODRFR,ODROR,ODRLK,ODRLI,ODRTP,ODRPP,ODRPL
     1 ,ODRSP,ODRSL,OSTPP,OSTBM,OSTFT,OSTUF,OSTBT,OSTAB,OSTBL
     1 ,OSTLU,OSTNB,OSTSZ,OEXFP,OEXNW,OEXCH,OEXAD,OEXLN,OEXAP
     1 ,STNEW,STOLD,STFRS,STUNK
     1 ,EREXST,ERNEXS,ERNTDI
c------------------------- Tree Parameters -----------------------------
c                            ! = file address of root
      parameter (OTRFR=0)
c                            ! = order of tree
      parameter (OTROR=1)
c                            ! = length of keys
      parameter (OTRLK=2)
c                            ! = length of info
      parameter (OTRLI=3)
c                            ! = tree type
      parameter (OTRTP=4)
c                              ! = regular (0) or extendable (1)
        parameter (MTRRG=1)
c                              ! = regular (unset) of directory (set)
        parameter (MTRDR=2)
c                              ! = mask for key types
        parameter (MTRKT=60)
c                                ! = ascii keys
          parameter (VTRAK=0)
c                                ! = integer keys
          parameter (VTRIK=4)
c                                ! = hexadecimal keys
          parameter (VTRHK=8)
c                                ! = floating point keys
          parameter (VTRFK=12)
c                                ! = double precision keys
          parameter (VTRDK=16)
c                            ! = id of io stack associated with this tree
      parameter (OTRST=5)
c                            ! = maximum number of levels in the tree
      parameter (OTRML=6)
c                            ! = address of ipath(mxlevl)
      parameter (OTRPA=7)
c                            ! = address of ikeytr(mxlevl)
      parameter (OTRKY=8)
c                            ! = current level in tree (ilev)
      parameter (OTRLV=9)
c                            ! = lu for extended information
      parameter (OTRUX=10)
c                            ! = offset of successive  keys in record (la)
      parameter (OTRKO=11)
c                            ! = number of reserved info words (lres)
      parameter (OTRNR=12)
c                            ! = tree address of father
      parameter (OTRFA=13)
c                            ! = pointer to tree last opened
      parameter (OTRLO=14)
c                            ! = length of this tree's name
      parameter (OTRLN=15)
c                            ! = file pointer to next extension
      parameter (OEXFP=16)
c                            ! = number of words in next extension
      parameter (OEXNW=17)
c                            ! = file address for chaining extension
      parameter (OEXCH=18)
c                            ! = offset of name of tree ! must be last
      parameter (OTRNM=19)
c                            ! = length of tree packet - excluding name
      parameter (LTRPK=19)
c                            ! = offset from end of info of extension fad
      parameter (OEXAD=0)
c                            ! = offset from end of info of extension len
      parameter (OEXLN=1)
c                            ! = offset from end of info of fad of update
      parameter (OEXAP=2)
c                            ! = length of extension packet
      parameter (LEXPK=3)
c------------------------- Directory parameters -----------------------
c                            ! = file address of root
      parameter (ODRFR=0)
c                            ! = order of tree
      parameter (ODROR=1)
c                            ! = length of keys
      parameter (ODRLK=2)
c                            ! = length of info
      parameter (ODRLI=3)
c                            ! = tree type (see above for types)
      parameter (ODRTP=4)
c                            ! = primary redirection file-name file ptr
      parameter (ODRPP=5)
c                            ! = primary redirection file-name length
      parameter (ODRPL=6)
c                            ! = secondary redirection file-name file ptr
      parameter (ODRSP=7)
c                            ! = secondary redirection file-name length
      parameter (ODRSL=8)
c                            ! = length of directory packet
      parameter (LDRPK=9)
c------------------------- Stack Parameters ---------------------------
c                            ! id of previous stack created
      parameter (OSTPP=0)
c                            ! stack pointer to bottom of stack
      parameter (OSTBM=1)
c         --------- Tables in the Stack Packet --------
c                              !  sequence numbers of buffers - see below
          parameter (ISTFT=0)
c                              !
          parameter (ISTUF=1)
c                              !
          parameter (ISTBT=2)
c                              !
          parameter (ISTAB=3)
c                              !
          parameter (ISTBL=4)
c                              !       number of tables needed:
          parameter (NSTTB=5)
c         --------------- Pointers to tables ----------
c                            ! buffer pointer to file pointer table
      parameter (OSTFT=2)
c                            ! buffer pointer to usage flags
      parameter (OSTUF=3)
c                            ! buffer ptr to buffer pointer table
      parameter (OSTBT=4)
c                            ! buffer ptr to 'above' pointer table
      parameter (OSTAB=5)
c                            ! buffer ptr to 'below' pointer table
      parameter (OSTBL=6)
c         ---------------------------------------------
c                            ! logical unit (lu)
      parameter (OSTLU=7)
c                            ! number of bytes to read and write
      parameter (OSTNB=8)
c                            ! size of memory used by this stack
      parameter (OSTSZ=9)
c                            ! length of stack packet
      parameter (LSTPK=10)
c------------------------ Status Codes --------------------------------
      parameter (STOLD=0)    
      parameter (STNEW=1)
      parameter (STFRS=2)
      parameter (STUNK=3)
c------------------------ Error Codes ---------------------------------
      parameter (EREXST=3)
      parameter (ERNEXS=4)
      parameter (ERNTDI=5)
c--------------------------- Memory -----------------------------------
      parameter (MXBIG=1)
      parameter (MXBIGC=4*(MXBIG+1)-1)
      parameter (MXBIGD=(MXBIG+1)/2-1)
      integer bigsize
      common/bigspa/nexbig,bigsize,ibig(0:MXBIG)
      common/bpntrs/ipstak
      common/trpntr/iptree,iptrcu
      double precision dbig(0:MXBIGD)
      character*1 cbig(0:MXBIGC)
      real*4 rbig(0:MXBIG)
      equivalence (ibig,rbig,dbig,cbig)
