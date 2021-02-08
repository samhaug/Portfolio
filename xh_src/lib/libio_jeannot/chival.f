      character*(*) function chival(i,lchival)
      character*12 str
      write(str,*) i
      ip=0
      do j=1,12
        if(str(j:j).ne.' ') then
          ip=ip+1
          str(ip:ip)=str(j:j)
        endif
      enddo
      chival=str(1:ip)
      lchival=ip
      return
      end

 
