c -----------------------------------------------------------------
      function dxphi(phi,phim,oophhl)

      implicit double precision(a-h,o-z)

      data pi/3.141592654/
      dxphi=pi*(phi-phim)*oophhl
 
      return
      end

