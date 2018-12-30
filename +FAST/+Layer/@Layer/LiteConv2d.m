% Author: Zhao Mingxin
% Date: 2018/12/22
% Description: run tflite Conv2d.

function [res,stat] = LiteConv2d(obj,im,ker,z_im,z_ker,z_res,s1,s2,s3,ConvType,stride,padding,bias,shift_n,bias_s,i)
    wordlen = 32;
    fraclen = 0;
    
    fcal = fimath('CastBeforeSum',0, 'OverflowMode', 'Saturate', 'RoundMode', 'nearest', ... 
    'ProductMode', 'SpecifyPrecision', 'SumMode', 'SpecifyPrecision', 'ProductWordLength',wordlen, ...
    'ProductFractionLength',fraclen, 'SumWordLength', wordlen, 'SumFractionLength', fraclen);
    tcal = numerictype('WordLength', wordlen, 'FractionLength',fraclen);
    
    im_int = fi(im,tcal,fcal);
    
    % This step can be done offline.
    ker_int = fi(ker,tcal,fcal);
    z_ker = fi(z_ker,tcal,fcal);
    ker_int = FAST.kernel.FastFiAddSub(ker_int,z_ker,@minus);
    
    ker_int(ker_int>127)=127;
    ker_int(ker_int<-128)=-128;
    
    % Calculate by type
    switch ConvType
        case 'Conv2d'
            conv_res = obj.Conv2d(im_int,ker_int,tcal,fcal,stride,padding);
        case 'DepthwiseConv2d'
            conv_res = obj.DepthwiseConv2d(im_int,ker_int,tcal,fcal,stride,padding);
        otherwise
            error('Unknown ConvType Detected.');
    end
    if i~=29
        conv_res = obj.AddBias(conv_res,bitshift(fi(bias,tcal,fcal),-bias_s),tcal,fcal);
        conv_res = fi(conv_res,1,16,0);

        wordlen = 32;
        fraclen = 0;

        fcal = fimath('CastBeforeSum',0, 'OverflowMode', 'Saturate', 'RoundMode', 'floor', ... 
        'ProductMode', 'SpecifyPrecision', 'SumMode', 'SpecifyPrecision', 'ProductWordLength',wordlen, ...
        'ProductFractionLength',fraclen, 'SumWordLength', wordlen, 'SumFractionLength', fraclen);
        tcal = numerictype('WordLength', wordlen, 'FractionLength',fraclen); 
        conv_res = fi(conv_res,tcal,fcal);

        % OutputStage
        [mul,n] = getShiftBits(s1,s2,s3,13);
        res_tmp = FAST.kernel.FastFiMultiply(conv_res,fi(mul,tcal,fcal));
        res = bitshift(res_tmp,-(n-bias_s+shift_n));
        res(res<0)=0;
        res = fi(res,1,8,0);
    else
        conv_res = obj.AddBias(conv_res,bitshift(fi(bias,tcal,fcal),-bias_s),tcal,fcal);
    %     fprintf('max is %5d,min is %5d, mean is %5d \n',max(conv_res.data(:)),min(conv_res.data(:)),mean(conv_res.data(:)));
        conv_res = bitshift(conv_res,-9);
%         disp(max(conv_res.data(:)));
        res = fi(conv_res,1,16,0);
        
    end
    stat = res.data(:);
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