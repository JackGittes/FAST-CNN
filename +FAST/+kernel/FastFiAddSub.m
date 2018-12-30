% Author: Zhao Mingxin
% Date: 2018/12/24
% When fi object has Saturate overflow action, we can replace fi Add and
% Sub by ordinary int Add and Sub with overflow detection to achieve higher 
% computation efficiency. 

function res = FastFiAddSub(a,b,Op)
    assert(isfi(a)&&isfi(b),"Fast Add is Only used for fi object.");
    
    if strcmp(a.OverflowAction,'Saturate') && strcmp(a.Signedness,'Signed')
       [int_a,int_b,~,FracLen,up_bound,low_bound] = FAST.kernel.FiToInt(a,b,'int64');
       
       int_res = Op(int_a,int_b);
       
       int_res(int_res > up_bound)=up_bound;
       int_res(int_res < low_bound)=low_bound;
    
       res = fi(double(int_res)/2^(FracLen),a.numerictype,a.fimath);
    else
       res = Op(a,b);
    end
end