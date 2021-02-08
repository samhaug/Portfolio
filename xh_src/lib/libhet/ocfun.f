c Evaluate the oceanic function at given latitiude and longitude

      function ocfun(xlat,xlon)
      common/ocfn/ioc(9,36)
      ilat=1+(90.-xlat)/5.
      ilat=min0(36,max0(1,ilat))
      ilon=1+amod(xlon+360.,360.)/5.
      ilon=min0(72,max0(1,ilon))
      ibyte=(ilon-1)/2
      call ilbyte(k,ioc(1,ilat),ibyte)
      ifodd=mod(ilon,2)
      if(ifodd.eq.0) iocfun=mod(k,16)
      if(ifodd.ne.0) iocfun=k/16
      ocfun=float(iocfun)*.1
      return
      end
c-----------------------------------------------------------------
      block data blkocn
      common/ocfn/ioc(9,36)
      dimension ioc1(9,9),ioc2(9,9),ioc3(9,9),ioc4(9,9)
      equivalence (ioc(1, 1),ioc1(1,1)),(ioc(1,10),ioc2(1,1))
     1           ,(ioc(1,19),ioc3(1,1)),(ioc(1,28),ioc4(1,1))
      data ioc1/
     1   z'aaaaaaaa',z'aaaaaaaa',z'aaaaaaaa',z'aaaaa000',z'01889999'
     2              ,z'9999aa99',z'99999999',z'10018aaa',z'aaaaaaaa'
     1  ,z'55554444',z'33332222',z'22334468',z'aaaaa504',z'8aaaaaaa'
     2              ,z'aaaaaaaa',z'aa720000',z'00112110',z'00005aaa'
     1  ,z'aa000000',z'00000000',z'00000000',z'12221000',z'00110253'
     2              ,z'4aaaaa52',z'00000000',z'00000000',z'00006aaa'
     1  ,z'aa600000',z'00000000',z'00000000',z'00000000',z'00000000'
     2              ,z'55778600',z'00000000',z'00000000',z'00004aaa'
     1  ,z'94200000',z'00000000',z'00000000',z'00000000',z'00000000'
     2              ,z'00000000',z'00000000',z'00002000',z'00024aaa'
     1  ,z'30000000',z'00000000',z'00000000',z'00000000',z'00000000'
     2              ,z'00000000',z'00000000',z'00016502',z'8aaaaa53'
     1  ,z'00000000',z'00000000',z'00000000',z'00016885',z'3aaaaaa8'
     2              ,z'22774000',z'00000000',z'00006a99',z'aaaaaa40'
     1  ,z'00000000',z'00000000',z'00000000',z'00001a90',z'67788888'
     2              ,z'9aaaa610',z'00000000',z'000000aa',z'aaaaaa10'
     1  ,z'00100022',z'01200000',z'00000000',z'00001537',z'aaaaaaaa'
     2              ,z'aaaaaa80',z'00000000',z'0000005a',z'aaaaa730'/
      data ioc2/
     1   z'33430355',z'13500000',z'00000000',z'004664aa',z'aaaaaaaa'
     2              ,z'aaaaaaa0',z'00000000',z'00267878',z'aaaaaa10'
     1  ,z'46474420',z'01500000',z'00000002',z'748908aa',z'aaaaaaaa'
     2              ,z'aaaaaaa3',z'00000000',z'069aaaaa',z'aaaaaa21'
     1  ,z'00286661',z'00000000',z'00000000',z'68585aaa',z'aaaaaaaa'
     2              ,z'aaaaaaaa',z'10000000',z'3aaaaaaa',z'aaaaaa10'
     1  ,z'00000031',z'00000000',z'00000000',z'a7aa8aaa',z'aaaaaaaa'
     2              ,z'aaaaaaaa',z'80000661',z'2aaaaaaa',z'aaaa7000'
     1  ,z'00000005',z'0001a300',z'00000000',z'4aaa6aaa',z'aaaaaaaa'
     2              ,z'aaaaaaaa',z'a7703a44',z'3989aaaa',z'aaaa6000'
     1  ,z'00000003',z'5027aa20',z'1551001a',z'5aaaa9aa',z'aaaaaaaa'
     2              ,z'aaaaaaaa',z'aa851036',z'7697aaaa',z'aaaa5000'
     1  ,z'00000000',z'358aaa80',z'6a75005a',z'aaaaaaaa',z'aaaaaaaa'
     2              ,z'aaaaaaaa',z'aaaaa733',z'85568aaa',z'aaaa6000'
     1  ,z'00000000',z'008aaaa1',z'5a6501a7',z'6558aaaa',z'aaaaaaaa'
     2              ,z'aaaaaaaa',z'aaaaaaa4',z'20003aaa',z'aaaaa500'
     1  ,z'97000000',z'08aaaaaa',z'aa9400a7',z'927aaaaa',z'aaaaaaaa'
     2              ,z'aaaaaaaa',z'aaaaaaa5',z'0000008a',z'aaaaaaaa'/
      data ioc3/
     1   z'a8000000',z'7aaaaaaa',z'aa981002',z'672769aa',z'aaaaaaaa'
     2              ,z'aaaaaaaa',z'aaaaaaa7',z'00000003',z'6aaaaaaa'
     1  ,z'aa400000',z'aaaaaaaa',z'aaaa9767',z'04000078',z'8aaaaaaa'
     2              ,z'aaaaaaaa',z'aaaaaaa7',z'00000000',z'06aaaaaa'
     1  ,z'aa000000',z'74aaaaaa',z'aaaaaaaa',z'000009aa',z'a9aaaaaa'
     2              ,z'aaaaaaaa',z'aaaaaa89',z'40000000',z'2aaaaaaa'
     1  ,z'aa300002',z'a0aaaaaa',z'aaaaaa82',z'0000005a',z'a8aa68aa'
     2              ,z'aaaaaaaa',z'aaaaaaaa',z'a4000000',z'2aaaaaaa'
     1  ,z'aa600007',z'633aaaaa',z'aaaaa820',z'0000002a',z'a9aa7aaa'
     2              ,z'aaaaaaaa',z'aaaaaaaa',z'a8000000',z'3aaaaaaa'
     1  ,z'aa50004a',z'aaaaaaaa',z'aaaaaa60',z'0000003a',z'aaaa7aaa'
     2              ,z'aaaaaaaa',z'aaaaaaaa',z'a6000002',z'8aaaaaaa'
     1  ,z'aa9401aa',z'aaaaaaaa',z'aaaaaa70',z'0000003a',z'aa9a6aaa'
     2              ,z'aaaaaaaa',z'aaaaaaaa',z'a300005a',z'aaaaaaaa'
     1  ,z'aaaaaaaa',z'aaaaaaaa',z'aaaaaaaa',z'aa84008a',z'aa72aaaa'
     2              ,z'aaaaaaaa',z'aaaaaaaa',z'a0000aaa',z'aaaaaaaa'
     1  ,z'aaaaaaaa',z'aaaaaaaa',z'aaaaaaaa',z'aaaaaa7a',z'aa3aaaaa'
     2              ,z'aaaaaaaa',z'aaaaaaaa',z'80005aaa',z'aaaaaaaa'/
      data ioc4/
     1   z'aaaaaaaa',z'aaaaaaaa',z'aaaaaaaa',z'aaaaaaaa',z'a49aaaaa'
     2              ,z'aaaaaaaa',z'aaaaaaaa',z'20005aaa',z'aaaaaaaa'
     1  ,z'aaaaaaaa',z'aaaaaaaa',z'aaaaaaaa',z'aaaaaaaa',z'aaaaaaaa'
     2              ,z'aaaaaaaa',z'aaaaaaaa',z'60004aaa',z'aaaaaaaa'
     1  ,z'aaaaaaaa',z'aaaaaaaa',z'aaaaaaaa',z'aaaaaaaa',z'aaaaaaaa'
     2              ,z'aaaaaaaa',z'aaaaaaaa',z'a86aaaaa',z'aa8aaaaa'
     1  ,z'aaaaaaaa',z'aaaaaaaa',z'aa235677',z'88889aaa',z'aaaaaaaa'
     2              ,z'aaaaaaaa',z'aaaaaaaa',z'a9550000',z'aaaaaaaa'
     1  ,z'55555505',z'00000000',z'00000000',z'00000023',z'31001432'
     2              ,z'10000000',z'01357875',z'21000008',z'a8aaaa66'
     1  ,z'00000000',z'00000000',z'00000000',z'00000000',z'005566aa'
     2              ,z'aa985533',z'22100000',z'00000022',z'20440000'
     1  ,z'00000000',z'00000000',z'00000000',z'00000000',z'00000000'
     2              ,z'00000000',z'00000000',z'00000000',z'00000000'
     1  ,z'00000000',z'00000000',z'00000000',z'00000000',z'00000000'
     2              ,z'00000000',z'00000000',z'00000000',z'00000000'
     1  ,z'00000000',z'00000000',z'00000000',z'00000000',z'00000000'
     2              ,z'00000000',z'00000000',z'00000000',z'00000000'/
      end
c-------------------------------------
