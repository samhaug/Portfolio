      subroutine frame2
      common/fram2/xg1,xg2,yg1,yg2,ig1,ig2,jg1,jg2
     1  ,ih1,ih2,jh1,jh2,ii1,ii2,ji1,ji2
      xg1=0.
      xg2=360.
      yg1=-45.
      yg2=45.
      ig1=250
      ig2=3850
      jg2=2726
      jg1=jg2-900
c
      ih1=250
      ih2=3850
      jh2=jg1-75
      jh1=jh2-900
c
      ii1=1450
      ii2=2650
      ji2=jh1-150
      ji1=ji2-165
      call chterm(5,5)
c
      do 123 ifr=1,2
      call movabs(ig1,jg1)
      call drwabs(ig1,jg2)
      call drwabs(ig2,jg2)
      call drwabs(ig2,jg1)
      call drwabs(ig1,jg1)
      call twindo(ig1,ig2,jg1,jg2)
      call dwindo(0.,360.,-90.,90.)
      call movea(0.,0.)
      call drawa(360.,0.)
      call anmode
c
      call movabs(ih1,jh1)
      call drwabs(ih1,jh2)
      call drwabs(ih2,jh2)
      call drwabs(ih2,jh1)
      call drwabs(ih1,jh1)
c
      call movabs(ii1,ji1)
      call drwabs(ii1,ji2)
      call drwabs(ii2,ji2)
      call drwabs(ii2,ji1)
      call drwabs(ii1,ji1)
      call anmode
  123 continue
      call askcap(2,ig1,ig2,jg1,jg2)
      return
      end
