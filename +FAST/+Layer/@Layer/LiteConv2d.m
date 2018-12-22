% Author: Zhao Mingxin
% Date: 2018/12/22
% Description: run tflite Conv2d.

function res = LiteConv2d(im,ker,z_im,z_ker,z_res,s1,s2,s3,ConvType,stride,padding,bias)
    wordlen = 32;
    fraclen = 0;
    
    fcal = fimath('CastBeforeSum',0, 'OverflowMode', 'Saturate', 'RoundMode', 'nearest', ... 
    'ProductMode', 'SpecifyPrecision', 'SumMode', 'SpecifyPrecision', 'ProductWordLength',wordlen, ...
    'ProductFractionLength',fraclen, 'SumWordLength', wordlen, 'SumFractionLength', fraclen);
    tcal = numerictype('WordLength', wordlen, 'FractionLength',fraclen);
    
    im_int = fi(im,tcal,fcal)-fi(z_im,tcal,fcal);
    ker_int = fi(ker,tcal,fcal)-fi(z_ker,tcal,fcal);
    
    % Calculate by type
    switch ConvType
        case 'Conv2d'
            conv_res = nn.Conv2d(im_int,ker_int,tcal,fcal,stride,padding);
        case 'DepthwiseConv2d'
            conv_res = nn.DepthwiseConv2d(im_int,ker_int,tcal,fcal,stride,padding);
        otherwise
            error('Unknown ConvType Detected.');
    end
    conv_res = nn.AddBias(conv_res,fi(bias,tcal,fcal),tcal,fcal);
    
    % OutputStage
    [mul,n] = getShiftBits(s1,s2,s3,14);
    
    fprintf('mul and shift are: %d, %d\n',mul,n);
    tmp = int32(conv_res.data)*int32(mul);
    res = bitshift(fi(tmp,tcal,fcal),-n)+ fi(z_res,tcal,fcal);
    
    res = fi(res,0,8,0);
end

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