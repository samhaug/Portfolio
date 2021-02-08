c---------------------------------------------------------------------
      subroutine mapcnt(grid,igrid,ikx,iky,z1,z2,i1,i2,j1,j2
     1       ,ifirc,nshds,iproj,icolor,ithick,mapfun,mapprj)
      dimension grid(igrid,*)
      dimension xy(2,100000),wk(100000),ind(20000),ilev(20000),ax(5),ay(5)
     1 ,cxy(2,3000)
      dimension xy1(2,100000),ind1(20000),ilev1(20000)
      dimension save(300,2)
      dimension arect(4)
      external mapfun
      if(iky.gt.300) stop 'increase dimensions of save'
      call hecntconfig(200,4000,16000,2000,2000)
      is=0
      if(z1.gt.z2) then
        z11=-z1
        z21=-z2
        do i=1,ikx
          do j=1,iky
            grid(i,j)=-grid(i,j)
          enddo
        enddo
      else
        z11=z1
        z21=z2
      endif

      arect(1)=0.
      arect(2)=-90.
      arect(3)=360.
      arect(4)=90.
      call twindo(i1,i2,j1,j2)
      call dwindo(0.,360.,-90.,90.)


      nx=max0(ikx/8,10)
      nx2=0
      nx1=1
      do while (nx2.ne.ikx)
        nx2=min0(nx1+nx,ikx)
        if(nx2+3.ge.ikx) nx2=ikx
        xx1=1.-float(nx1-1)/float(ikx-1)
        xx2=1.-float(nx2-1)/float(ikx-1)

c       save the nx2+1th row
cc        do i=1,iky
cc          save(i,1)=grid(nx2,i)
cc          save(i,2)=grid(nx2+1,i)
cc        enddo
cc        call hecnti(grid(nx1,1),igrid,nx2-nx1+1,iky,nshds,z11,z21,0.,1.,xx1,xx2
cc     1      ,0,cxy(1,1),cxy(2,1),2,npts,0,mapfun
cc     1      ,xy(1,1),xy(2,1),2,100000,is,ind,ilev,20000,wk,100000)
cc
cc        do i=1,iky
cc          grid(nx2,i)=save(i,1)
cc          grid(nx2+1,i)=save(i,2)
cc        enddo


        is=0
ccc       call cntracko(grid(nx1,1),igrid,nx2-nx1+1,iky,z11,(z21-z11)/nshds,nshds+1
ccc    1     ,xy(1,1),xy(2,1),2,100000,is,ind,ilev,20000)
        aa=0.
        bb=360./(iky-1)
        cc=-180./(ikx-1)
        dd=0.
        tx=0.
        ty=(nx1-1)*cc+90.
        call cntrack(grid(nx1,1),igrid,nx2-nx1+1,iky
     1     ,aa,bb,cc,dd,tx,ty
     1     ,nshds,z11,z21
     1     ,xy(1,1),xy(2,1),2,100000,is,ind,ilev,20000)

c  testing
          call lincol(icolor)
          call linwdt(1)
          do i=1,is
            do kp=ind(i),ind(i+1)-1
              call mapprj(xy(1,kp),xy(2,kp),iproj,xx,yy)
              if(kp.eq.ind(i)) then
                call movea(xx,yy)
              else
                call drawa(xx,yy)
              endif
              if(mod(kp,500).eq.0) call tsend()
            enddo
            call tsend()
          enddo


      

ccc       cxy(1,1)=1 
ccc       cxy(2,1)=1 
ccc       cxy(1,2)=iky
ccc       cxy(2,2)=1 
ccc       cxy(1,3)=iky
ccc       cxy(2,3)=nx2-nx1+1
ccc       cxy(1,4)=1
ccc       cxy(2,4)=nx2-nx1+1
ccc       cxy(1,5)=1
ccc       cxy(2,5)=1

        cxy(1,1)=aa*(0)+bb*(0)+tx
        cxy(2,1)=cc*(0)+dd*(0)+ty
        cxy(1,2)=aa*(nx2-nx1)+bb*(0)+tx
        cxy(2,2)=cc*(nx2-nx1)+dd*(0)+ty
        cxy(1,3)=aa*(nx2-nx1)+bb*(iky-1)+tx
        cxy(2,3)=cc*(nx2-nx1)+dd*(iky-1)+ty
        cxy(1,4)=aa*(0)+bb*(iky-1)+tx
        cxy(2,4)=cc*(0)+dd*(iky-1)+ty
        cxy(1,5)=aa*(0)+bb*(0)+tx
        cxy(2,5)=cc*(0)+dd*(0)+ty

        ncxy=5
ccc       jj=(nx2-nx1+1)/2
ccc       ii=iky/2
ccc       xref=ii
ccc       yref=jj
ccc       rcll=1.+float(nshds)*(grid(jj+nx1-1,ii)-z11)/(z21-z11)
        ii=iky/2
        jj=(nx2-nx1+1)/2
        xref=aa*(jj-1)+bb*(ii-1)+tx
        yref=cc*(jj-1)+dd*(ii-1)+ty
        rcll=1.+float(nshds)*(grid(jj+nx1-1,ii)-z11)/(z21-z11)
        if(rcll.ge.0) then
          icll=ifix(rcll)
        else
          icll=-1+ifix(rcll)
        endif
        icll=max0(0,min0(nshds+1,icll))
        is1=0
        call joicnt(cxy(1,1),cxy(2,1),2,ncxy
     1     ,xy(1,1),xy(2,1),2,is,ind,ilev
     1     ,xy1(1,1),xy1(2,1),2,10000,is1,ind1,ilev1,20000
     1     ,icll,xref,yref
     1     ,wk(1),wk(1),100000)
ccc       do i=ind1(1),ind1(is1+1)-1
ccc         xy1(1,i)=(xy1(1,i)-1.)/(iky-1)
ccc         xy1(2,i)=xx1+(xx2-xx1)*(xy1(2,i)-1.)/(nx2-nx1)
ccc       enddo
        call lincol(icolor)
        call linwdt(0)
        do i=1,is1
          icol=min0(nshds,max0(1,ilev1(i)))
          ifillcolor=ifirc+icol-1
          call filcol(ifillcolor)
          do kp=ind1(i),ind1(i+1)-1
ccc           xx=xy1(1,kp)*360.
ccc           yy=xy1(2,kp)*180.-90.
ccc           call mapprj(xx,yy,iproj,xy1(1,kp),xy1(2,kp))
            call mapprj(xy1(1,kp),xy1(2,kp),iproj,xy1(1,kp),xy1(2,kp))
          enddo
          call polyfil(0,xy1(1,ind1(i)),xy1(2,ind1(i)),2,ind1(i+1)-ind1(i))
        enddo
        if( ismono().ne.0 ) then
          call lincol(icolor)
          call linwdt(1)
          do i=1,is
            do kp=ind(i),ind(i+1)-1
ccc             xx=(xy(1,kp)-1.)/(iky-1)
ccc             yy=xx1+(xx2-xx1)*(xy(2,kp)-1.)/(nx2-nx1)
ccc             xx=xx*360.
ccc             yy=yy*180.-90.
ccc             call mapprj(xx,yy,iproj,xx,yy)
              call mapprj(xy(1,kp),xy(2,kp),iproj,xx,yy)
              if(kp.eq.ind(i)) then
                call movea(xx,yy)
              else
                call drawa(xx,yy)
              endif
              if(mod(kp,500).eq.0) call tsend()
            enddo
            call tsend()
          enddo
        endif



cc        call lincol(icolor)
cc       call linwdt(0)
cc        do i=1,is
cc          icol=min0(nshds,max0(1,ilev(i)))
cc          ifillcolor=ifirc+icol-1
cc          call filcol(ifillcolor)
cc          do kp=ind(i),ind(i+1)-1
cc            xx=xy(1,kp)*360.
cc            yy=xy(2,kp)*180.-90.
cc            call mapprj(xx,yy,iproj,xy(1,kp),xy(2,kp))
cc          enddo
cc          call polyfil(1,xy(1,ind(i)),xy(2,ind(i)),2,ind(i+1)-ind(i))
cc        enddo

        nx1=nx2
      enddo



      if(ithick.ge.0) then
        ax(1)=0.
        ax(2)=360.
        ax(3)=ax(2)
        ax(4)=ax(1)
        ax(5)=ax(1)
        ay(1)=-90.
        ay(2)=ay(1)
        ay(3)=90.
        ay(4)=ay(3)
        ay(5)=ay(1)
        ifdraw=0
        ifinit=1
        x=ax(1)
        y=ay(1)
        call mapprj(x,y,iproj,xp,yp)
        call drawc(xp,yp,arect,0,1)
        do i=2,5
          do j=1,100
            x=ax(i-1)+float(j)*(ax(i)-ax(i-1))/100.
            y=ay(i-1)+float(j)*(ay(i)-ay(i-1))/100.
            call mapprj(x,y,iproj,xp,yp)
            call drawc(xp,yp,arect,1,0)
          enddo
        enddo
        call linwdt(ithick)
        call lincol(icolor)
        call drcpolyline()
      endif

      return
      end
        
c---------------------------------------------------------

      subroutine cntracko(g,ig,iky,ikx,zmin,dz,ncont
     1     ,xs,ys,inc,nxy,is,indx,ilev,nindx)
      dimension g(ig,*),xs(inc,*),ys(inc,*),indx(*),ilev(*)
      logical more,segind
      do icont=1,ncont
        is0=is
        z=zmin+(icont-1)*dz
        ind=1
        do while(segind(ind,ikx,iky,i1i,j1i,i2i,j2i))
          if(sign(1.,g(j1i,i1i)-z).eq.sign(1.,g(j2i,i2i)-z)) goto 40
          isv=is
          isv1=is+1
          m1=mod(i1i,2)
          if(g(j1i,i1i).gt.g(j2i,i2i)) then
            ifrh=m1
          else
            ifrh=1-m1
          endif
          do ifb=0,1
            ifdraw=0
            ind1=0
            i1=i1i
            j1=j1i
            i2=i2i
            j2=j2i
            more=.TRUE.
            do while(more)
              i=i1
              j=j1
              ii=i2
              jj=j2
              if(m1.eq.ifb) then
                iu=j2-j1
                ju=i1-i2
              else
                iu=j1-j2
                ju=i2-i1
              endif
              gii=g(jj,ii)-z
              gi=g(j,i)-z
              den=gi-gii
              if(den.ne.0.) then
                x=(ii*gi-i*gii)/den
                y=(jj*gi-j*gii)/den
              else
                x=.5*(i+ii)
                y=.5*(j+jj)
              endif
              call drawci(x,y,ifdraw,0
     1          ,xs,ys,inc,nxy,is,indx,nindx)
              ifdraw=1
              if(is.eq.isv1) then
                isv1=-ifb
              endif
              if(ind1.eq.ind) goto 30
              in=i+iu
              jn=j+ju
              im=ii+iu
              jm=jj+ju
              if(im.ge.1.and.im.le.ikx.and.jm.ge.1.and.jm.le.iky
     1           .and.in.ge.1.and.in.le.ikx.and.jn.ge.1.and.jn.le.iky) then
                ich=mod(min(i,ii,in,im)+min(j,jj,jn,jm),2)
                s11=sign(1.,gi)
                s12=sign(1.,g(jn,in)-z)
                s21=sign(1.,gii)
                s22=sign(1.,g(jm,im)-z)
                if      (s11.ne.s12.and.(s21.eq.s22.or.ich.eq.0) ) then
                  i1=i
                  j1=j
                  i2=in
                  j2=jn
                else if (s21.ne.s22.and.(s11.eq.s12.or.ich.ne.0) ) then
                  i1=im
                  j1=jm
                  i2=ii
                  j2=jj
                else if (s12.ne.s22) then
                  i1=in
                  j1=jn
                  i2=im
                  j2=jm
                endif
                ind1=indseg(ikx,iky,i1,j1,i2,j2)
                if(ind1.ne.0.and.ind1.lt.ind) then
                   is=isv
                   goto 40
                endif
              else
                more=.FALSE.
              endif
            enddo
          enddo
   30     continue
          if(is.eq.isv+2) then
            call revvec(xs(1,indx(isv+1)),inc,indx(isv+2)-indx(isv+1))
            call revvec(ys(1,indx(isv+1)),inc,indx(isv+2)-indx(isv+1))
            call shfvec(xs(1,indx(is)),inc,-1,indx(is+1)-indx(is))
            call shfvec(ys(1,indx(is)),inc,-1,indx(is+1)-indx(is))
            indx(is)=indx(is+1)-1
            is=is-1
            ifrh=1-ifrh
          endif
          if(isv1.ne.0) ifrh=1-ifrh
          if(is.ne.isv.and.ifrh.eq.0) then
            call revvec(xs(1,indx(is)),inc,indx(is+1)-indx(is))
            call revvec(ys(1,indx(is)),inc,indx(is+1)-indx(is))
          endif
   40     ind=ind+1
        enddo
        do i=is0+1,is
          ilev(i)=icont
        enddo
      enddo
      return
      end
      
      subroutine revvec(ka,inc,n)
      dimension ka(inc,*)
      nh=n/2
      k=n
      do i=1,nh
        ksave=ka(1,i)
        ka(1,i)=ka(1,k)
        ka(1,k)=ksave
        k=k-1
      enddo
      return
      end
         
      subroutine shfvec(ka,inc,kshf,n)
      dimension ka(inc,*)
      if(kshf.lt.0) then
        do i=1,n
          ka(1,i+kshf)=ka(1,i)
        enddo
      else if(kshf.gt.0) then
        do i=n,1,-1
          ka(1,i+kshf)=ka(1,i)
        enddo
      endif
      return
      end

      function indseg(ikx,iky,ix1,iy1,ix2,iy2)
      if(ix1.eq.ix2) then
        if(mod(ix1,2).eq.0) then
          indseg=(ix1-1)*iky+iky-min0(iy1,iy2)
        else
          indseg=(ix1-1)*iky+min0(iy1,iy2)
        endif
      else if(iy1.eq.1) then
        ixmin=min0(ix1,ix2)
        if(mod(ixmin,2).eq.0) then
          indseg=ixmin*iky
        else
          indseg=0
        endif
      else if(iy1.eq.iky) then
        ixmin=min0(ix1,ix2)
        if(mod(ixmin,2).eq.1) then
          indseg=ixmin*iky
        else
          indseg=0
        endif
      else
        indseg=0
      endif
      return
      end
     
      logical function segind(ind,ikx,iky,ix1,iy1,ix2,iy2)
      ix=ind/iky
      if(ix*iky.eq.ind) then
        ix1=ix
        ix2=ix+1
        if(mod(ix,2).eq.0) then
          iy1=1
          iy2=1
        else
          iy1=iky
          iy2=iky
        endif
      else if(mod(ix,2).eq.0) then
        ix1=ix+1
        ix2=ix1
        iy1=ind-ix*iky
        iy2=iy1+1
      else 
        ix1=ix+1
        ix2=ix1
        iy2=(ix+1)*iky-ind
        iy1=iy2+1
      endif
      if(ix2.gt.ikx.or.max0(iy1,iy2).gt.iky) then
        segind=.FALSE.
      else
        segind=.TRUE.
      endif
      return
      end
c---------------------------------------------------------
c     subroutine cntrack(g,ig,n1,n2,zmin,dz,ncont
c    1     ,xs,ys,inc,nxy,is,indx,ilev,nindx)

      subroutine cntrack(g,ig,n1,n2
     1     ,aa,bb,cc,dd,tx,ty
     1     ,nshds,zmin,zmax
     1     ,xs,ys,inc,nxy,is,indx,ilev,nindx)

      dimension g(ig,*),xs(inc,*),ys(inc,*),indx(*),ilev(*)
      logical more,segind
      dz=(zmax-zmin)/nshds
      ncont=nshds+1
      do icont=1,ncont
        is0=is
        z=zmin+(icont-1)*dz
        ind=1
        do while(segind(ind,n2,n1,i1i,j1i,i2i,j2i))
          if(sign(1.,g(j1i,i1i)-z).eq.sign(1.,g(j2i,i2i)-z)) goto 40
          isv=is
          isv1=is+1
          m1=mod(i1i,2)
          if(g(j1i,i1i).gt.g(j2i,i2i)) then
            ifrh=m1
          else
            ifrh=1-m1
          endif
          do ifb=0,1
            ifdraw=0
            ind1=0
            i1=i1i
            j1=j1i
            i2=i2i
            j2=j2i
            more=.TRUE.
            do while(more)
              i=i1
              j=j1
              ii=i2
              jj=j2
              if(m1.eq.ifb) then
                iu=j2-j1
                ju=i1-i2
              else
                iu=j1-j2
                ju=i2-i1
              endif
              gii=g(jj,ii)-z
              gi=g(j,i)-z
              den=gi-gii
              if(den.ne.0.) then
                x=(ii*gi-i*gii)/den-1.
                y=(jj*gi-j*gii)/den-1.
              else
                x=.5*(i+ii)-1.
                y=.5*(j+jj)-1.
              endif
              call drawci(aa*y+bb*x+tx,cc*y+dd*x+ty,ifdraw,0
     1          ,xs,ys,inc,nxy,is,indx,nindx)
              ifdraw=1
              if(is.eq.isv1) then
                isv1=-ifb
              endif
              if(ind1.eq.ind) goto 30
              in=i+iu
              jn=j+ju
              im=ii+iu
              jm=jj+ju
              if(im.ge.1.and.im.le.n2.and.jm.ge.1.and.jm.le.n1
     1           .and.in.ge.1.and.in.le.n2.and.jn.ge.1.and.jn.le.n1) then
                ich=mod(min(i,ii,in,im)+min(j,jj,jn,jm),2)
                s11=sign(1.,gi)
                s12=sign(1.,g(jn,in)-z)
                s21=sign(1.,gii)
                s22=sign(1.,g(jm,im)-z)
                if      (s11.ne.s12.and.(s21.eq.s22.or.ich.eq.0) ) then
                  i1=i
                  j1=j
                  i2=in
                  j2=jn
                else if (s21.ne.s22.and.(s11.eq.s12.or.ich.ne.0) ) then
                  i1=im
                  j1=jm
                  i2=ii
                  j2=jj
                else if (s12.ne.s22) then
                  i1=in
                  j1=jn
                  i2=im
                  j2=jm
                endif
                ind1=indseg(n2,n1,i1,j1,i2,j2)
                if(ind1.ne.0.and.ind1.lt.ind) then
                   is=isv
                   goto 40
                endif
              else
                more=.FALSE.
              endif
            enddo
          enddo
   30     continue
          if(is.eq.isv+2) then
            call revvec(xs(1,indx(isv+1)),inc,indx(isv+2)-indx(isv+1))
            call revvec(ys(1,indx(isv+1)),inc,indx(isv+2)-indx(isv+1))
            call shfvec(xs(1,indx(is)),inc,-1,indx(is+1)-indx(is))
            call shfvec(ys(1,indx(is)),inc,-1,indx(is+1)-indx(is))
            indx(is)=indx(is+1)-1
            is=is-1
            ifrh=1-ifrh
          endif
          if(isv1.ne.0) ifrh=1-ifrh
          if(is.ne.isv.and.ifrh.eq.0) then
            call revvec(xs(1,indx(is)),inc,indx(is+1)-indx(is))
            call revvec(ys(1,indx(is)),inc,indx(is+1)-indx(is))
          endif
   40     ind=ind+1
        enddo
        do i=is0+1,is
          ilev(i)=icont
        enddo
      enddo
      return
      end
