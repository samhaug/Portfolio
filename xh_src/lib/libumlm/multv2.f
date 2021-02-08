      subroutine multv2(v1,irn1,ism1
     1                 ,v2,irn2,ism2
     1                 ,v3,irn3,ism3,iv3max,istrun)
      complex v1(2**irn1,(ism1+1)**2)
      complex v2(2**irn2,(ism2+1)**2)
      complex v3(2**(irn1+irn2),(ism1+ism2+1)**2)
      double precision d(-20:20,-20:20)
      irn3=irn1+irn2
      ism3=min0(istrun,ism1+ism2)
      nmx1=2**irn1
      nmx2=2**irn2
      nmx3=2**irn3

      ntest=nmx3*(ism3+1)**2
      if(ntest.gt.iv3max) then
        write(6,'(''rank1:'',i3/
     1           ,''rank2:'',i3/
     1           ,''smax1:'',i3/
     1           ,''smax2:'',i3/
     1           ,''ivmax:'',i9/
     1           ,''nmx3: '',i9/
     1           ,''smax3:'',i9/
     1           ,''ntest:'',i9)') irn1,irn2,ism1,ism2,iv3max,is3,ntest
        pause 'insufficient space in multv'
      endif

      do j=1,(ism3+1)**2
        do i=1,nmx3
          v3(i,j)=(0.,0.)
        enddo
      enddo
      do is3=0,ism3
        ib3=is3*(is3+1)+1
        fs3=2*is3+1
        do is1=0,ism1
          ib1=is1*(is1+1)+1
          do is2=0,ism2
            ib2=is2*(is2+1)+1
            if(iabs(is1-is2).le.is3.and.iabs(is1+is2).ge.is3) then
              call wig2(is3,is1,is2,d(-is3,-is2),41)
              do iel3=1,nmx3
                n1=0
                n2=0
                itm=iel3-1
                do i=1,irn3
                  ind=-1+2*mod(itm,2)
                  if(i.le.irn1) then
                    n1=n1+ind
                  else
                    n2=n2+ind
                  endif
                  itm=itm/2
                enddo
                n3=n1+n2
                iel1=1+mod(iel3-1,nmx1)
                iel2=1+(iel3-1)/nmx1
                do m1=-is1,is1
                  do m2=-is2,is2
                    m3=m1+m2
                    if(iabs(n3).le.is3.and.iabs(n2).le.is2
     1                .and.iabs(m3).le.is3) then
                      if(iel3.lt.1.or.iel3.gt.nmx3.or.ib3+m3.lt.1.or.
     1                    ib3+m3.gt.(ism3+1)**2) then
                        write(6,'(''indices out of range'')')
                        pause
                      endif

                      v3(iel3,ib3+m3)=v3(iel3,ib3+m3)+
     1        fs3*v1(iel1,ib1+m1)*v2(iel2,ib2+m2)*d(n3,n2)*d(m3,m2)
                    endif
                  enddo
                enddo
              enddo
            endif
          enddo
        enddo
      enddo
      end
