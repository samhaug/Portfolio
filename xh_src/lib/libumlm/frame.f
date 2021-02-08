      subroutine frame
      common/fram/xa1,xa2,ya1,ya2,xb1,xb2,yb1,yb2,xc1,xc2,yc1,yc2
     1            ,ia1,ia2,ja1,ja2,ib1,ib2,jb1,jb2,ic1,ic2,jc1,jc2
     2            ,id1,id2,jd1,jd2
      xa1=0.
      xa2=360.
      ya1=-45.
      ya2=45.
      ia1=250
      ia2=3850
      ja2=2726
      ja1=ja2-900
c
      xb1=0.
      xb2=360.
      yb1=-1.
      yb2=1.
      ib1=250
      ib2=3850
      jb2=ja1-75
      jb1=jb2-488
c     jb1=jb2-60
c
      xc1=0.
      xc2=360.
      yc1=-1.
      yc2=1.
      ic1=250
      ic2=3850
      jc2=jb1-75
      jc1=jc2-788
c     jc1=jc2-200
c
      id1=1450
      id2=2650
      jd2=jc1-150
      jd1=jd2-165
      call chterm(5,5)
c
      call twindo(ia1,ia2,ja1,ja2)
      call dwindo(xa1,xa2,ya1,ya2)
      do 123 ifr=1,2
      call movabs(ia1,ja1)
      call drwabs(ia1,ja2)
      call drwabs(ia2,ja2)
      call drwabs(ia2,ja1)
      call drwabs(ia1,ja1)
      call movea(0.,0.)
      call drawa(360.,0.)
      call anmode
c
      call movabs(ib1,jb1)
      call drwabs(ib1,jb2)
      call drwabs(ib2,jb2)
      call drwabs(ib2,jb1)
      call drwabs(ib1,jb1)
c
      call movabs(ic1,jc1)
      call drwabs(ic1,jc2)
      call drwabs(ic2,jc2)
      call drwabs(ic2,jc1)
      call drwabs(ic1,jc1)
c
      call movabs(id1,jd1)
      call drwabs(id1,jd2)
      call drwabs(id2,jd2)
      call drwabs(id2,jd1)
      call drwabs(id1,jd1)
      call anmode
  123 continue
      isiz=2
      call wrtsiz(isiz,icw,ich)
      call movabs(id1,jd1)
      call movrel(-(12*icw)/2,-ich/3)
      call anmode
c     write(11,'(5h-.75%)')
      call wrch('-.75%')
      call movabs(id1,jd2)
      call movrel(-(12*icw)/2,-ich/3)
      call anmode
c     write(11,'(5h-3.o%)')
      call wrch('-3.0%')
      call movabs(id2,jd2)
      call movrel((2*icw)/2,-ich/3)
      call anmode
c     write(11,'(5h+3.o%)')
      call wrch('+3.0%')
      call movabs(id2,jd1)
      call movrel((2*icw)/2,-ich/3)
      call anmode
c     write(11,'(5h+.75%)')
      call wrch('+.75%')
      call askcap(2,ia1,ia2,ja1,ja2)
      return
      end
