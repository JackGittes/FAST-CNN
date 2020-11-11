%{
    Author:  Zhao Mingxin
    Date:  2020/11/10
    Description: This method is designed for shortcut element-wise
    addition operation. The definition of this operation:
        x3 = (x1/s1 + x2/s2) * s3 = (s3/s1)*x1 + (s3/s2) * x2
    As integer arithmetic cannot fulfill the division operation,
    it is imperative to implement the division in a fixed-point manner.
    
    Here, we express s3/s1 and s3/s2 as mul1/2^shift and mul2/2^shift,
    respectively. Howvever, using a naive right-shift incurs serious
    accuracy degradation. We utilize a round-shift instead, which is 
    implemented in +cuda/Arithmetic/RoundCast.cu.
%}
function res = Add(obj, x1, x2, mul1, shift, mul2, ~)
    x3 = x1 * mul1 + x2 * mul2;
    switch obj.Mode
        case 'GPU'
            res = FAST.kernel.RoundCastKernel(x3, 1, shift, 8);
        case {'MultiCore','SingleCore'}
            res = x3 / (2^shift);
        otherwise
            error('Unknown Computation Mode.');
    end
end