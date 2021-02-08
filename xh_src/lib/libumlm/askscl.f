      subroutine askscl(isiz,z1,z2,i1,i2,j1,j2)
      character*1 cap1(10),cap2(10)
      character*10 cap10,cap20
      equivalence (cap1(1),cap10) , (cap2(1),cap20)
      write(6,1) z1,z2
    1 format(' zmin=',f10.4,'   zmax=',f10.4/
     1  ' type captions'/'********** **********')
      read(5,2) cap1,cap2
    2 format(10a1,1x,10a1)
      len1=0
   10 len1=1+len1
      if(cap1(len1).eq.' ') goto 11
      goto 10
   11 len1=len1-1
      len2=0
   20 len2=1+len2
      if(cap2(len2).eq.' ') goto 22
      goto 20
   22 len2=len2-1
      call wrtsiz(isiz,icw,ich)
      call movabs(i1,j1)
      call movrel(-(len1*icw)/2,-(4*ich)/3)
      call anmode
c
c     write(11,31) (cap1(i),i=1,len1)
c  31 format(20a1)
      call wrch(cap10)
c
      call movabs(i2,j1)
      call movrel(-(len2*icw)/2,-(4*ich)/3)
      call anmode
c
c     write(11,31) (cap2(i),i=1,len2)
      call wrch(cap20)
c
      return
      end
