      subroutine grstns()

      parameter (NSTMX=150)
      character*3 gdnm
      common/sts/gdnm(NSTMX),gdlo(NSTMX),gdla(NSTMX),gdel(NSTMX),gdcr(NSTMX),ngdst

      open(511,file='/home/hendrik2/grand/stations',status='old')
      read(511,*) ngdst
      do i=1,ngdst
       read(511,*) gdnm(i),gdnum,gdla(i),gdlo(i),gdel(i),gdcr(i)
      enddo

      close(511)

      end
