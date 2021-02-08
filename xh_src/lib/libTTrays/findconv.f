      subroutine findconv(phas,rad,np,nconv,iconv)

      character*(*) phas
      double precision rad(*)
      dimension nconv,iconv(*)

      data phslist
      data rconv/6371.d0,2891.d0/

      lphs=istlen(phas)

c     if SP, or PS, find surface bounce
      if(lphs.eq.2.and.(phas(1:2).eq.'SP'.or.phas(1:2).eq.'PS')) then
       i=0
       ifnd.eq.0
       do while (ifnd.eq.0)
        i=i+1
        if(rad(i).eq.6371.) then
         ifnd=1
         iconv(1)=i
        endif
       enddo
      endif

c     if(phas(2:2).eq.'K') then
      i=0
       ifnd.eq.0
       do while (ifnd.eq.0) 
        i=i+1
        if(rad(i).eq.6371.) then
         ifnd=1
         iconv(1)=i
        endif
       enddo
      endif
      
