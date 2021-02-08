       subroutine findcmtsim(evnam,ierr)

       include '../include/ndk.h'
       character*80 cmtfil,name,findcmtlocndk
       character*(*) evnam

       cmtfil='/geo/home/jritsema/Utils/CMT_catalog/cmt.ndk'
       ifcen=1
       evstr=findcmtlocndk(evnam,levstr,cmtfil,ifcen,ierr)

       end

