      subroutine closegram(iadgtr)
      include 'gramdb.h'
      include '../libdb/dblib.h'
      if(iadgtr.lt.0) return
      if(ibig(iadgtr+OGHITG).lt.0) return
      call closechng(iadgtr)
      call trclos(ibig(iadgtr+OGHTGS))
      call trclos(ibig(iadgtr+OGHITG))
      ibig(iadgtr+OGHITG)=-1
      call dalloc(LNGRMHD,iadgtr)
      return
      end
