      subroutine findray1(ilin,iwave,srcdep,ds,p,grad,rarr,delarr,varr,np,dsfin)

      implicit double precision(a-h,o-z)
      dimension rarr(*),delarr(*),varr(*)
      parameter(MXLAY=500)
      common/linmd/depl(MXLAY),vell(MXLAY),nlay
      rnorm=6371

c     initialise at the first depth

      gr=grad
c     last step is not implemented for up goinf ray!
      if(gr.eq.1) stop 'findray1 is currently only set up for downgoing rays'
    
      eps=1.-1.d-7
      i=1
      dep=srcdep
      r=rnorm-dep
      rarr(1)=r
      del=0
      delarr(1)=0
      sini=0.
      dssq=ds*ds
      dsfin=0.


c     dummy dr
      dr=1.

      do while(sini.lt.eps.and.dr.gt.1d-15.and.r.le.6371)
       call getvlin(dep,v,dv)
c      write(6,*)'DEP, V, DV, P', dep,v,dv,p
       varr(i)=v
       
       oor=1.d0/r
c      write(6,*)'P,V,OOR',p,v,oor
       sini=p*v*oor
       cosi=sqrt(1-(sini*sini))
c      write(6,*) 'SINI, COSI',sini,cosi

c      use 2nd order 
c      find curvature: (Ben Menahem 7.91) di/ds
       rh=-p*dv*oor

       if(ilin.eq.1) then
        ddel=sini*ds*oor
        dr=cosi*ds
       else
        ddel=sini*ds*oor+(-oor*oor*cosi*sini+oor*cosi*rh)*dssq
        dr=cosi*ds-(sini*rh*dssq)
       endif

   
       i=i+1
       r=r+gr*dr
       dep=dep-gr*dr
       rarr(i)=r
       del=del-gr*ddel
       delarr(i)=del
c      write(111,*) del,r,v,sini
      enddo

      if(r.lt.6371) then
       call getvlin(dep,v,dv)
       varr(i)=v
       np=i
       npbot=np
      else
       np=i-1
      endif

      if(gr.lt.0.) then
c      let ray go up now:
       dbot=delarr(np)
       dbot2=2*dbot
       do i=1,np-1
        delarr(np+i)=dbot2-delarr(np-i)
        varr(np+i)=varr(np-i)
        rarr(np+i)=rarr(np-i)
       enddo
       np=2*np-1

c      continue to the surface if source depth > 0
       if(srcdep.ne.0.) then
        gr=1.
        i=np
        del=delarr(np)
        r=rarr(np)
        dep=6371-r
        do while(r.le.6371)
         call getvlin(dep,v,dv)
         varr(i)=v
   
         oor=1.d0/r
         sini=p*v*oor
         cosi=sqrt(1-(sini*sini))
   
c       use 2nd order
c       find curvature: (Ben Menahem 7.91) di/ds
         rh=-p*dv*oor
  
         if(ilin.eq.1) then
          ddel=sini*ds*oor
          dr=cosi*ds
         else
          ddel=sini*ds*oor+(-oor*oor*cosi*sini+oor*cosi*rh)*dssq
          dr=cosi*ds-(sini*rh*dssq)
         endif
  
   
         i=i+1
         r=r+gr*dr
         dep=dep-gr*dr
         rarr(i)=r
         del=del+gr*ddel
         delarr(i)=del
        enddo

c       include last part of the ray to 6371
c       velocity is still given by velocity at rarr(np-1)
c       same for sini and cosi
        np=i
        rarr(np)=rnorm
        dr=rnorm-rarr(np-1)
        dsfin=dr/cosi
        ddel=sini*dsfin*oor
        delarr(np)=delarr(np-1)+ddel
        call getvlin(0.,v,dv)
        varr(np)=v
        
       endif

      endif

      end
      

