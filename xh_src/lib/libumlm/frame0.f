      subroutine frame0(iflab)
      character*10 string
      common/fram1/ie1,ie2,je1,je2,xe1,xe2,ye1,ye2
     1            ,if1,if2,jf1,jf2
      dimension latt(7),lont(7),lons(7)
      data latt/3h90n,3h60n,3h30n,3h  0,3h30s,3h60s,3h90s/
      data lont/4h180 ,4h120w,4h60w ,4h0   ,4h60e ,4h120e,4h180 /
c     data lons/-28,-84,-112,-84,-112,-84,-196/
c     data lons/0,-28,28,84,28,-28,56/
      data lons/-28,-112,-84,-28,-84,-112,-140/
      ierr=0
      ie1=200
      ie2=3920
      je1=600
      je2=je1+2200
      xe1=0.
      xe2=360.
      ye1=-90.
      ye2=90.
      if1=1360
      if2=2760
      jf2=je1-170
      jf1=jf2-165
      iie1=ie1-200
      iie2=ie2+50
      ije1=je1-200
      ije2=je2+200
      call chterm(15,5)
      call wrtsiz(1,iwt,iht)
      iy=(je2-je1+3)/6
      iyy=je2-32
      ixx=ie1-180
      do 360 i=1,7
      call movabs(ixx,iyy)
      call anmode
      write(string,1000) latt(i)
 1000 format(a3)
      call wrch(string)
  360 iyy=iyy-iy
      ix=(ie2-ie1+3)/6
      ixx=ie1
      do 370 i=1,7
      jx=ixx+lons(i)+10
      call movabs(jx,je1-100)
      call anmode
      write(string,1001) lont(i)
 1001 format(a4)
      call wrch(string)
  370 ixx=ixx+ix
      call twindo(ie1,ie2,je1,je2)
      call dwindo(xe1,xe2,ye1,ye2)
      do 150 n=1,2
      call movea(xe1,ye1)
      call drawa(xe2,ye1)
      call drawa(xe2,ye2)
      call drawa(xe1,ye2)
      call drawa(xe1,ye1)
      if(iflab.eq.0) goto 150
      do 160 i=1,11
      x=30*i
      call movea(x,ye1)
  160 call drwrel(0,40)
      do 170 i=1,5
      y=-90+30*i
      call movea(xe2,y)
  170 call drwrel(-40,0)
      do 180 i=1,11
      x=360-30*i
      call movea(x,ye2)
  180 call drwrel(0,-40)
      do 190 i=1,5
      y=90-30*i
      call movea(xe1,y)
  190 call drwrel(40,0)
      call movabs(if1,jf1)
      call drwabs(if2,jf1)
      call drwabs(if2,jf2)
      call drwabs(if1,jf2)
      call drwabs(if1,jf1)
  150 continue
c
      call askcap(1,ie1,ie2,je1,je2)
      return
      end
