function res = Add(obj, x1, x2, mul1, shift, mul2, ~)
    x3 = x1 * mul1 + x2 * mul2;
    switch obj.Mode
        case 'GPU'
            res = FAST.kernel.RoundCastKernel(x3, 1, shift, 8);
        case {'MultiCore','SingleCore'}
            res = x3 / (2^shift1);
        otherwise
            error('Unknown Computation Mode.');
    end
end