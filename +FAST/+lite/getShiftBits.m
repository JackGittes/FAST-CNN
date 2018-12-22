% Author: Zhao Mingxin
% Date:   2018/12/10
% Description: as below

function [mul,n] = getShiftBits(s1,s2,s3,base)
    M = s1*s2/s3;
    n0 = 0;
    while M<0.5
        M = M*2;
        n0 = n0+1;
    end
    mul = floor(M*2^(base-1));
    n = n0-1+base;
end