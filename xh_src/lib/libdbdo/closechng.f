
c----------------------------------------------------------------
      subroutine closechng(iadgtr)
      include 'gramdb.h'
      include '../libdb/dblib.h'
      do i=ibig(iadgtr+OGHNOP),1,-1
        call trclos(ibig(iadgtr+OGHTCG+i-1))
cxy   write(6,*) 'closechngk:',ibig(iadgtr+OGHTGS),ibig(iadgtr+OGHTCG+i-1),ibig(iadgtr+OGHNOP)

      enddo
      ibig(iadgtr+OGHNOP)=0
      return
      end
