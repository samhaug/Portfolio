
c-----------------------------------------------------------
      subroutine piylms()
      include 'maxl.h'
c     parameter (MXL=40)
      common/piyls/ipidid,piyvals( (MXL+1)**2 )
      dimension wk1(MXL+1),wk2(MXL+1),wk3(MXL+1)
      data ipidid/0/
      if(ipidid.ne.0) return
      ipidid=1
      call ylm(0.,0.,MXL,piyvals,wk1,wk2,wk3)
      return
      end
