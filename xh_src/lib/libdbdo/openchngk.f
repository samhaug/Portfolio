c----------------------------------------------------------------

      subroutine openchngk(iadgtr,ckey,iflap,ierr)
      character*28 ckey
      include '../libdb/dblib.h'
      include 'gramdb.h'
      character*80 exname

      ibig(iadgtr+OGHNOP)=ibig(iadgtr+OGHNOP)+1
      if(ibig(iadgtr+OGHNOP).gt.MXCHOPEN) pause 'openchngk: too many open channels'
      nstak=3
      maxlev=20
      mord=7
      lkey=8
      ityp=1
      linfo=0
      exname='*'
      call tropnn(ibig(iadgtr+OGHTGS),ckey,STUNK,iflap,ierr
     1    ,nstak,maxlev,ibig(iadgtr+OGHTCG+ibig(iadgtr+OGHNOP)-1)
     1    ,mord,lkey,linfo,ityp,exname)
cxy   write(6,*) 'openchngk:',ibig(iadgtr+OGHTGS),ibig(iadgtr+OGHTCG+ibig(iadgtr+OGHNOP)-1),ibig(iadgtr+OGHNOP)
      return
      end
