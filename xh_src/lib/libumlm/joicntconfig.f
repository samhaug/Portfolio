      subroutine joicntconfig(mxe,mxc,mxn)
      common/joiconfig/mxends,mxcuts,mxn3
      if(mxe.gt.0) mxends=mxe
      if(mxc.gt.0) mxcuts=mxc
      if(mxn.gt.0) mxn3=mxn
      return
      end
