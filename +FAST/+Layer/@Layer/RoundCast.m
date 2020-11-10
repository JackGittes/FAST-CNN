function res = RoundCast(obj, im, mul, shift, bit_width)
    switch obj.Mode
        case 'GPU'
            res = FAST.kernel.RoundCastKernel(im, mul, shift, bit_width);
        case {'MultiCore','SingleCore'}
            tmp = im * mul;
            tmp = bitshift(tmp, -shift);
            tmp(tmp > 2^(bit_width-1)-1)=2^(bit_width-1)-1;
            tmp(tmp < -2^(bit_width-1))=-2^(bit_width-1);
            res = tmp;
        otherwise
            error('Unknown Computation Mode.');
    end
end