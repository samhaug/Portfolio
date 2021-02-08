c-----------------------------------------------------------------------
      subroutine dodec()
c
c  generates the x,y,z coordinates of the 20 vertices of a dodecohedron.
c  In the calling program x,y,z should be deimensioned 20. ipoly(i,j)
c  gives the index to the i'th vertex of the j'th pentagonal face,
c  traced in a clockwise sense, looking from the exterior. ipoly(6,j)
c  is equal to ipoly(1,j), completing the pentagon by repeating the first
c  vertex. xc(j),yc(j),zc(j) are the components of the faces' unit normals.
c
      common/dodeco/ x(5,4),y(5,4),z(5,4),ipoly(6,12),xc(12),yc(12),zc(12)
     1     ,azm1(12)
      dimension x1(20),y1(20),z1(20)
      equivalence (x,x1),(y,y1),(z,z1)
      pi=4.*atan(1.)
      a72=72.*pi/180.
      a36=a72*.5
      c72=cos(a72)
      s72=sin(a72)
      c36=cos(a36)
      s36=sin(a36)
      xsid2=(1.-c72)**2+s72**2
      xsid=sqrt(xsid2)
      xv=c72*xsid2/(1.-c72)
      zv=sqrt(xsid2-xv**2)
      do i1=1,5
        a=(i1-1)*a72
        x(i1,1)=cos(a)
        y(i1,1)=sin(a)
        z(i1,1)=0.
      enddo
      do i1=1,5
        x(i1,2)=x(i1,1)*(1.+xv)
        y(i1,2)=y(i1,1)*(1.+xv)
        z(i1,2)=zv
      enddo
      do i1=1,5
        i2=1+mod(i1,5)
        i4=1+mod(i1+2,5)
        vx=.5*(x(i2,1)+x(i1,1))
        vy=.5*(y(i2,1)+y(i1,1))
        tx=.5*(x(i2,2)+x(i1,2))-vx
        ty=.5*(y(i2,2)+y(i1,2))-vy
        tz=.5*(z(i2,2)+z(i1,2))
        ta=sqrt(tx**2+ty**2+tz**2)
        tx=tx/ta
        ty=ty/ta
        tz=tz/ta
        ts=sqrt((x(i4,1)-vx)**2+(y(i4,1)-vy)**2)
        x(i1,3)=vx+ts*tx
        y(i1,3)=vy+ts*ty
        z(i1,3)=ts*tz
      enddo


      do i1=1,5
        i2=1+mod(i1,5)
        i3=1+mod(i1+1,5)
        i4=1+mod(i1+2,5)
        alph=c72*xsid2
     1     /((x(i1,1)+x(i2,1))*(x(i4,1)-x(i3,1))+(y(i1,1)+y(i2,1))*(y(i4,1)-y(i3,1)))
        tx=alph*(x(i1,1)+x(i2,1))
        ty=alph*(y(i1,1)+y(i2,1))
        tz=sqrt(xsid2-tx**2-ty**2)
        x(i1,4)=x(i1,3)+tx
        y(i1,4)=y(i1,3)+ty
        z(i1,4)=z(i1,3)+tz
      enddo
      tx=0.
      ty=0.
      tz=0.
      do i=1,5
      do j=1,4
        tx=tx+x(i,j)
        ty=ty+y(i,j)
        tz=tz+z(i,j)
      enddo
      enddo
      tx=tx/20.
      ty=ty/20.
      tz=tz/20.
      do i=1,5
      do j=1,4
        x(i,j)=x(i,j)-tx
        y(i,j)=y(i,j)-ty
        z(i,j)=z(i,j)-tz
        s=sqrt(x(i,j)**2+y(i,j)**2+z(i,j)**2)
        x(i,j)=x(i,j)/s
        y(i,j)=y(i,j)/s
        z(i,j)=z(i,j)/s
      enddo
      enddo
      ipoly(1,1)=1
      ipoly(2,1)=2
      ipoly(3,1)=3
      ipoly(4,1)=4
      ipoly(5,1)=5
      ipoly(6,1)=1

      ipoly(1,2)=11
      ipoly(2,2)=7
      ipoly(3,2)=2
      ipoly(4,2)=1
      ipoly(5,2)=6
      ipoly(6,2)=11

      ipoly(1,3)=12
      ipoly(2,3)=8
      ipoly(3,3)=3
      ipoly(4,3)=2
      ipoly(5,3)=7
      ipoly(6,3)=12

      ipoly(1,4)=13
      ipoly(2,4)=9
      ipoly(3,4)=4
      ipoly(4,4)=3
      ipoly(5,4)=8
      ipoly(6,4)=13

      ipoly(1,5)=14
      ipoly(2,5)=10
      ipoly(3,5)=5
      ipoly(4,5)=4
      ipoly(5,5)=9
      ipoly(6,5)=14

      ipoly(1,6)=15
      ipoly(2,6)=6
      ipoly(3,6)=1
      ipoly(4,6)=5
      ipoly(5,6)=10
      ipoly(6,6)=15

      ipoly(1,7)=6
      ipoly(2,7)=15
      ipoly(3,7)=20
      ipoly(4,7)=16
      ipoly(5,7)=11
      ipoly(6,7)=6

      ipoly(1,8)=7
      ipoly(2,8)=11
      ipoly(3,8)=16
      ipoly(4,8)=17
      ipoly(5,8)=12
      ipoly(6,8)=7

      ipoly(1,9)=8
      ipoly(2,9)=12
      ipoly(3,9)=17
      ipoly(4,9)=18
      ipoly(5,9)=13
      ipoly(6,9)=8

      ipoly(1,10)=9
      ipoly(2,10)=13
      ipoly(3,10)=18
      ipoly(4,10)=19
      ipoly(5,10)=14
      ipoly(6,10)=9

      ipoly(1,11)=10
      ipoly(2,11)=14
      ipoly(3,11)=19
      ipoly(4,11)=20
      ipoly(5,11)=15
      ipoly(6,11)=10

      ipoly(1,12)=18
      ipoly(2,12)=17
      ipoly(3,12)=16
      ipoly(4,12)=20
      ipoly(5,12)=19
      ipoly(6,12)=18

      do ip=1,6
        azm1(ip)=0.0
      enddo
      do ip=7,12
        azm1(ip)=180.
      enddo
      do ip=1,12
        xc(ip)=0.
        yc(ip)=0.
        zc(ip)=0.
        do iv=1,5
          xc(ip)=xc(ip)+x1(ipoly(iv,ip))
          yc(ip)=yc(ip)+y1(ipoly(iv,ip))
          zc(ip)=zc(ip)+z1(ipoly(iv,ip))
        enddo
        ss=sqrt(xc(ip)**2+yc(ip)**2+zc(ip)**2)
        xc(ip)=xc(ip)/ss
        yc(ip)=yc(ip)/ss
        zc(ip)=zc(ip)/ss
      enddo
           




      return
      end

      
