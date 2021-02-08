// SUBROUTINE TO FIND SMALLEST POWER OF TWO >= AN INTEGER 

int power2(innum)
int innum;
{
        double frexp(), pow();
        float remainder;
        int retpow, inpow, minpow;
        remainder = frexp((double)innum,&retpow);
        if(remainder <= 0.5){
                remainder *= 2;
                retpow -= 1;
        }
        minpow = (int)pow((double)2.0,(double)retpow);
        return(minpow);
}
                                                                                     

