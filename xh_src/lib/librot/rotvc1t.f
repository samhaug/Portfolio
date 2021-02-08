c-----------------------------------------------------------
c Perform rotation on multiple vectors of spherical harmonics
c stored in amdl, regarded as an array of dimension:
c          amdl((lmax+1)**2,npar).
c Arrays 'vec1' and 'double precision d' need
c to be dimensioned at least (2*lmax+1) and (2*lmax+1)**2 
c respectively. The matrix operation which corresponds
c rotvc1t is the transpose of that corresponding to rotvc1.
c 
      subroutine rotvc1t(amdl,lmax,npar,alph,beta,gama,d,vec1,bmdl)

      dimension amdl(*),bmdl(*),vec1(*)
      double precision d(*)
      call rotvcz(bmdl,lmax,npar,-gama,bmdl)
      call rotvcyt(bmdl,lmax,npar,beta,vec1,d,bmdl)
      call rotvcz(amdl,lmax,npar,-alph,bmdl)
      return
      end
