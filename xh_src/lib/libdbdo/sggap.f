      integer function sggap(isub,iagram)
      include 'gramblock.h'
      include '../libdb/dblib.h'
      iach=iagram+ibig(iagram+OGSTCHO+isub-1)
      sggap=ibig(iach+OGCHSGG)
      return
      end
