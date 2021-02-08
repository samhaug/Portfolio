      subroutine getkernfls(mtyp,mxpmain,kernfls)

      character*3 mtyp
c     declarations for getmulkern
      parameter(MXPARTYP=7)
      character*80 kerndir,kernfls(MXPARTYP)

      if(mxpmain.ne.MXPARTYP) stop'getkernfls: mxpmain.ne.MXPARTYP'

      kerndir='/geo/home/jritsema/dta/'
      lkd=istlen(kerndir)
      if(mtyp.eq.'sph') then
       kernfls(1)=kerndir(1:lkd)//'KC3SPLH5.BIN'
       kernfls(2)=kerndir(1:lkd)//'GKERNSES.BIN'
       kernfls(3)=kerndir(1:lkd)//'GKERNSEP.BIN'
       kernfls(4)=kerndir(1:lkd)//'GKERNSDE.BIN'
       kernfls(5)=kerndir(1:lkd)//'GKERNSER.BIN'
       kernfls(6)=kerndir(1:lkd)//'GKERNSZS.BIN'
       kernfls(7)=kerndir(1:lkd)//'GKERNSZP.BIN'
c     else if(mtyp.eq.'spe') then
c      kernfls(1)=kerndir(1:lkd)//'gkernsSP.5spe.bin'
c      kernfls(2)=kerndir(1:lkd)//'gkernsESspe.bin'
c      kernfls(3)=kerndir(1:lkd)//'gkernsEPspe.bin'
c      kernfls(4)=kerndir(1:lkd)//'gkernsDEspe.bin'
c      kernfls(5)=kerndir(1:lkd)//'gkernsERspe.bin'
c      kernfls(6)=kerndir(1:lkd)//'gkernsZSspe.bin'
c      kernfls(7)=kerndir(1:lkd)//'gkernsZPspe.bin'
      else
       stop'mk3d1mulpar: unknown parameterisation requested'
      endif

      end

