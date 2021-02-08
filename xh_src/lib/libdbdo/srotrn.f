      function srotrn(input)
      integer*2 input,mantys,m1,m2,k,m3
      logical l
      data m1/-12/,m2/4/,m3/15/
      k=ishft(input,m1)
      iexp=6-k
      mantys=ishft(input,m2)
      l=btest(mantys,m3)
      mant=mantys
      if(l) mant=-mant
      srotrn=ishft(mant,iexp)
      if(l) srotrn=-srotrn
      return
      end
