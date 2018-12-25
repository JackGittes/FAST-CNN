% Author: Zhao Mingxin
% Date:   2018/12/10
% Description: 

function res = FastFiMultiply(a,b)
    assert(isfi(a)&&isfi(b),"Fast Multiplication is Only used for fi object");
    
    if strcmp(a.OverflowAction,'Saturate') && strcmp(a.Signedness,'Signed')
        WordLen = a.WordLength;
        FracLen = a.FractionLength;
        
        up_bound = 2^(WordLen-1)-1;
        low_bound = -2^(WordLen-1);
        int_a = int64(a.data*2^FracLen);
        int_b = int64(b.data*2^FracLen);
        
        int_res = int_a*int_b;
        int_res(int_res > up_bound)=up_bound;
        int_res(int_res < low_bound)=low_bound;
        
        res = fi(double(int_res)/2^(2*FracLen),a.numerictype,a.fimath);
    else
        res = a*b;
    end
end