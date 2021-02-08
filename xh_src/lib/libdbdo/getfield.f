c--------------------------------------------------------------
      subroutine getfield(cod,ityp,cbuf,k,indcd,ient,ileve,mess,lmess,icdstat)
      character*(*) cod,cbuf,mess
      include 'seeddefs.h'
      character*1 fmlett
      character*80 getwd
      dimension knt(0:MXLEVLS),ient0(0:MXLEVLS),ient1(0:MXLEVLS)
      save
      if(cod.eq.'070') write(6,*) 'code 070 inum=',inum,' k=',k

      if(k.eq.0) then
        inum=len(cbuf)
        icd=0
        ntry=0
        do while(icd.eq.0.and.ntry.lt.ncodes(ityp))
          ntry=ntry+1
          if(cod.eq.codes(ntry,ityp)) icd=ntry
        enddo
        if(icd.eq.0) then
           write(6,'(3a)') 'getfield: code: [',cod,']'
           pause 'getfield: code not found'
        endif
        indcd=indcods(icd,ityp)
        icdstat=codstat(indcd)
        ilev=0
        ient0(ilev)=0
        ient1(ilev)=MXENTRY+1
        knt(ilev)=1
        ient=0
        k=1
        ileve=ilev
        write(mess,"(a3,i4.4)") cod,inum+7
        lmess=7
        return
      else
  101   if(ient.ge.ient1(ilev)) then
          knt(ilev)=knt(ilev)-1
          ient=ient0(ilev)
        endif

        ient=1+ient
        if(knt(ilev).eq.0) then
c         ient=ient1(ilev)+1
          ient=ient1(ilev)
          ilev=ilev-1
c         if(ient.ge.ient1(ilev)) then
c           ient=ient0(ilev)+1
c           knt(ilev)=knt(ilev)-1
c         endif
          goto 101
        endif

        if(ient.gt.nument(indcd))  goto 20
        lent=lenent(ient,indcd)
        fmlett=fstr(ient,indcd)(1:1)
        if(fmlett.eq.'t'.or.fmlett.eq.'s') then
          mess=getwd(cbuf,k,'~',lmess)
          k=k+1
        else
          mess=cbuf(k:k+lent-1)
          lmess=lent
          k=k+lent
        endif
        ileve=ilev
        if(MXREPTS*(entstat(ient,indcd)/MXREPTS).eq.ISCOUNT) then
          ilev=ilev+1
          ient0(ilev)=ient
          ient1(ilev)=ient+mod(entstat(ient,indcd),MXREPTS)
          read(mess(1:lmess),*) knt(ilev)
        endif
        
        return
   20   continue
        if(k.ne.inum+1) then
cc        write(0,*) 'getfield: ient=',ient,' nument(indcd)=',nument(indcd)
cc        write(0,*) 'getfield: ilev=',ilev,' knt(ilev)=',knt(ilev)
cc        write(0,*) 'getfield: Warning: code=',cod,'  k=',k,'  inum+1=',inum+1
c         pause 'getfield: blockette length error'
        endif
        ient=-1
        ileve=ilev
        return
      endif
      end
