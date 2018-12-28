% Author: Zhao Mingxin
% Date: 2018/12/22
% Description: run tflite Conv2d.

function [res,stat]= LiteConv2d_beta(obj,im,ker,z_im,z_ker,z_res,s1,s2,s3,ConvType,stride,padding,bias,bias_sft,sft)
    wordlen = 32;
    fraclen = 0;
    
    fcal = fimath('CastBeforeSum',0, 'OverflowMode', 'Saturate', 'RoundMode', 'nearest', ... 
    'ProductMode', 'SpecifyPrecision', 'SumMode', 'SpecifyPrecision', 'ProductWordLength',wordlen, ...
    'ProductFractionLength',fraclen, 'SumWordLength', wordlen, 'SumFractionLength', fraclen);
    tcal = numerictype('WordLength', wordlen, 'FractionLength',fraclen);
    
    im_int = fi(im,tcal,fcal);
%     z_im = fi(z_im,tcal,fcal);
%     im_int = FAST.kernel.FastFiAddSub(im_int,z_im,@minus);
    
    % This step can be done offline.
    ker_int = fi(ker,tcal,fcal);
    z_ker = fi(z_ker,tcal,fcal);
    ker_int = FAST.kernel.FastFiAddSub(ker_int,z_ker,@minus);
    ker_int(ker<-128)=-128;
    ker_int(ker>127)=127;
    % Calculate by type
    switch ConvType
        case 'Conv2d'
            conv_res = obj.Conv2d(im_int,ker_int,tcal,fcal,stride,padding);
        case 'DepthwiseConv2d'
            conv_res = obj.DepthwiseConv2d(im_int,ker_int,tcal,fcal,stride,padding);
        otherwise
            error('Unknown ConvType Detected.');
    end
    
    conv_res = obj.AddBias(conv_res,bitshift(fi(bias,tcal,fcal),-bias_sft),tcal,fcal);
    
    if sft ~= 2
%         sft = 1;
        conv_res = fi(bitshift(conv_res,-sft),1,16,0);
    
        wordlen = 32;
        fraclen = 0;

        fcal = fimath('CastBeforeSum',0, 'OverflowMode', 'Saturate', 'RoundMode', 'floor', ... 
        'ProductMode', 'SpecifyPrecision', 'SumMode', 'SpecifyPrecision', 'ProductWordLength',wordlen, ...
        'ProductFractionLength',fraclen, 'SumWordLength', wordlen, 'SumFractionLength', fraclen);
        tcal = numerictype('WordLength', wordlen, 'FractionLength',fraclen); 

        conv_res = fi(conv_res,tcal,fcal);

        % OutputStage
        [mul,n] = getShiftBits(s1,s2,s3,13);
        fprintf('mul %5d,shift is %5d\n',mul,n);
        res_tmp = FAST.kernel.FastFiMultiply(conv_res,fi(mul,tcal,fcal));
        res = bitshift(res_tmp,-(n));
        res(res<0)=0;
        res = fi(res,1,8,0);
    else
        res = fi(bitshift(conv_res,-3),1,16,0);
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