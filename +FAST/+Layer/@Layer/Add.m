function res = Add(~, x1, x2, mul1, shift1, mul2, shift2)
%     x1 = bitshift(x1 * mul1, -shift1);
%     x2 = bitshift(x2 * mul2, -shift2);
%     res = x1 + x2;
%     x1 = bitshift(x1 * mul1, -shift1);
%     x2 = bitshift(x2 * mul2, -shift2);
    
    x3 = x1 * mul1 + x2 * mul2;
    x3 = x3 / (2^shift1);
%     res = x1 + x2;
    res = x3;
end