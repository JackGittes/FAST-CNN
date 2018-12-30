% Author: Zhao Mingxin
% Date:   2018/12/24
% Description: same as FastFiAddSub

function res = FastFiMultiply(a,b)
    assert(isfi(a)&&isfi(b),"Fast Multiplication is Only used for fi object.");
    
    if strcmp(a.OverflowAction,'Saturate') && strcmp(a.Signedness,'Signed')

        [int_a,int_b,~,FracLen,up_bound,low_bound]= FAST.kernel.FiToInt(a,b,'int64');
        
        int_res = int_a*int_b;
        
        int_res(int_res > up_bound)=up_bound;
        int_res(int_res < low_bound)=low_bound;
        
        res = fi(double(int_res)/2^(2*FracLen),a.numerictype,a.fimath);
    else
        res = a*b;
    end
end