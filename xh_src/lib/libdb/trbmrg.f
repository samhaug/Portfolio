
      subroutine trbmrg(istak,ipa1,ike2,ipa2,ipa3,idir,la,mord)
      include "dblib.h"
      lam1=la-1
      lam2=la-2
      call balloc(2+(mord-1)*la,jb)
      call stakgt(istak,ipa3,ibrec)
      nk3=ibig(ibrec)
      if(idir.lt.0) then
        j=jb+1
        do i=1,1+la*nk3
          ibig(j)=ibig(ibrec+i)
          j=j+1
        enddo
        call stakgt(istak,ipa2,ibrec)
        k=ibrec+2+ike2*la
        do i=0,lam2
          ibig(j)=ibig(k+i)
          j=j+1
        enddo
        ibig(ibrec)=ibig(ibrec)-1
        do i=ibrec+1+ike2*la,ibrec+1+ibig(ibrec)*la
          ibig(i)=ibig(i+la)
        enddo
        call staktc(istak)
        call stakgt(istak,ipa1,ibrec)
        nk1=ibig(ibrec)
        do i=ibrec+1,ibrec+1+nk1*la
          ibig(j)=ibig(i)
          j=j+1
        enddo
        if(j.ne.jb+2+(mord-1)*la) pause 'checksum error in trbmrg'
        ibig(jb)=mord-1
        do i=0,1+ibig(jb)*la
          ibig(ibrec+i)=ibig(jb+i)
        enddo
      else
        j=jb+1+(mord-1)*la
        do i=1+la*nk3,1,-1
          ibig(j)=ibig(ibrec+i)
          j=j-1
        enddo
        call stakgt(istak,ipa2,ibrec)
        k=ibrec+2+ike2*la
        do i=lam2,0,-1
          ibig(j)=ibig(k+i)
          j=j-1
        enddo
        ibig(ibrec)=ibig(ibrec)-1
        do i=ibrec+2+ike2*la,ibrec+1+ibig(ibrec)*la
          ibig(i)=ibig(i+la)
        enddo
        call staktc(istak)
        call stakgt(istak,ipa1,ibrec)
        nk1=ibig(ibrec)
        do i=ibrec+1+nk1*la,ibrec+1,-1
          ibig(j)=ibig(i)
          j=j-1
        enddo
        if(j.ne.jb) pause 'checksum error in trbmrg'
        ibig(jb)=mord-1
        do i=0,1+ibig(jb)*la
          ibig(ibrec+i)=ibig(jb+i)
        enddo
      endif
      call staktc(istak)
      call dalloc(2+(mord-1)*la,jb)
      return
      end
