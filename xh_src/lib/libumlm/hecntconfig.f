      subroutine hecntconfig(mxb,mxn,mxj,mxc,mxcl)
      common/hecwkconfig/mxbdyc,mxnbdy,mxjoicwk,mxcntrs,mxclpwk
      if(mxb.gt.0) mxbdyc=mxb
      if(mxn.gt.0) mxnbdy=mxn
      if(mxj.gt.0) mxjoicwk=mxj
      if(mxc.gt.0) mxcntrs=mxc
      if(mxcl.gt.0) mxclpwk=mxcl
      return
      end
