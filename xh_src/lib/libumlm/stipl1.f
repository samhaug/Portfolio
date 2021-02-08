      subroutine stipl1(grid,igrid,ikla,iklo,ishade,nshade
     1   ,z1,z2,it1,it2,jt1,jt2)
      dimension grid(igrid,1),ishade(1)
c     call czaxis(1)
      call linwdt(4)
      iklo1=iklo-1
      ikla1=ikla-1
      iklop1=iklo+1
      iklap1=ikla+1
      faci=float(it2-it1)/float(iklo-1)
      facj=float(jt2-jt1)/float(ikla-1)
      it21=it2-1
      jt21=jt2-1
      itdis=it2-it1-2
      jtdis=jt2-jt1-2
      it11=it1+1
      jt11=jt1+1
      fnsh=float(nshade)
      zdif=z2-z1
      fcz=fnsh/zdif
      fit1=float(it1)
      fjt1=float(jt1)
c
      itk1=it1
      do 10 icol=1,iklo1
      i0=icol
      i1=icol+1
      itk0=1+itk1
      itk1=fit1+faci*(float(icol))+.5
      itk1=min0(it21,itk1)
      fidis=0.
      if(itk1.ne.itk0) fidis=1./float(itk1-itk0)
c
      jtk1=jt1
      do 20 jrow=1,ikla1
      j0=jrow
      j1=jrow+1
      jtk0=1+jtk1
      jtk1=fjt1+facj*(float(jrow))+.5
      jtk1=min0(jt21,jtk1)
      fjdis=0.
      if(jtk1.ne.jtk0) fjdis=1./float(jtk1-jtk0)
c
      z00=grid(iklap1-j0,i0)
      z01=grid(iklap1-j1,i0)
      z10=grid(iklap1-j0,i1)
      z11=grid(iklap1-j1,i1)
      in00=(z00-z1)*fcz+1.
      in01=(z01-z1)*fcz+1.
      in10=(z10-z1)*fcz+1.
      in11=(z11-z1)*fcz+1.
c
      inmin=min0(in00,in01,in10,in11)
      inmax=max0(in00,in01,in10,in11)
      inmin=min0(nshade,max0(1,inmin))
      inmax=min0(nshade,max0(1,inmax))
      do 120 indsh=inmin,inmax
      imod=ishade(indsh)
      if(imod.eq.0) goto 120
      ibia=mod(itdis,imod)/2
      ibia=mod(it11+ibia,imod)
      ip1=ibia+((itk0-ibia+imod-1)/imod)*imod
      jbia=mod(jtdis,imod)/2
      jbia=mod(jt11+jbia,imod)
      jp1=jbia+((jtk0-jbia+imod-1)/imod)*imod
      do 150 ip=ip1,itk1,imod
      fip=float(ip-itk0)*fidis
      fipb=1.-fip
      do 160 jp=jp1,jtk1,imod
      if(inmin.eq.inmax) goto 170
      fjp=float(jp-jtk0)*fjdis
      fjpb=1.-fjp
      z=(z00*fipb+z10*fip)*fjpb+(z01*fipb+z11*fip)*fjp
      indt=(z-z1)*fcz+1.
      indt=min0(nshade,max0(1,indt))
      if(indt.ne.indsh) goto 160
  170 call pntabs(ip,jp)
      call tsend
  160 continue
  150 continue
  120 continue
   20 continue
   10 continue
c     call czaxis(0)
      call linwdt(2)
      return
      end
