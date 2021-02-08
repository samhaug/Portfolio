c---------------------------------------------------------
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
c---------------------------------------------------------
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
c---------------------------------------------------------
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
c---------------------------------------------------------
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

