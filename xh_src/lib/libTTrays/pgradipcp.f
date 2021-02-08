      subroutine pgradipcp(j,jmax,i1,depth,depthmax,p,grad,ipcp)
      implicit double precision(a-h,o-z)

c     checked May 92

c     use i1:
c             1 - S
c             2 - P
c             3 - SS
c             4 - PP
c             5 - pP
c             6 - PcP
c             7 - ScS

      propj=j*1.0d0/(jmax*1.0d0)
      propd=depth/depthmax
      if(i1.eq.1.or.i1.eq.3) then
          p=479.0316480d0 + propj*470.0d0 - propj*propd*50.0d0
          grad=-1.0d0
          ipcp=0
      elseif(i1.eq.2.or.i1.eq.4) then
c         p=253.707414920d0 + propj*276.0d0 - propj*propd*30.0d0
          p=253.72d0 + propj*276.0d0 - propj*propd*30.0d0
          grad=-1.0d0
          ipcp=0
      elseif(i1.eq.5) then
          p=254.43d0+((j*3.068333d0)-(j*(depth/800.d0)*31.d0/90.d0))
          grad=1.0d0
          ipcp=0
      elseif(i1.eq.6) then
          delp=253.70741492060d0
          p=(1.d0-(propj**3))*delp
          grad=-1.0d0
          ipcp=1
      elseif(i1.eq.7) then
          delp=479.03164808304d0
          p=(1.d0-(propj**3))*delp
          grad=-1.0d0
          ipcp=1
      endif
c      write(6,'(i5,4f12.4)') i1,propj,propd,p
      return
      end
