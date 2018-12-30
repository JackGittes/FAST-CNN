% Author: Zhao Mingxin
% Date:   2018/12/10
% Description: Run tflite fixed point CNN using JSON parameters.
%{
    JSON file should be converted from .tflite file using flatc interpreter. 
    After you extract network parameters, you can call this function to run
    a fixed point CNN. More details please refer to TensorFlow API and
    Google 8-bit quantization paper:
    
    If you have any issues about this code, please feedback.
%}

function [res,stat] = Forward_v5(obj)
    [model,inputs,strategy,t,f,nn] = deal(obj.model,obj.inputs,obj.strategy_list,obj.Numeric,obj.Fimath,obj.nn);
    strategy  = zeros(1,length(model));
    shift_list=[1,2,1,0,0,0,0,1,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,2,0,2,0,0];
    
    stat = cell(1,length(model));
    for i=1:length(model)
        layer = model(i);
        if i==1
            net = inputs;
            net = fi((double(inputs)-128)/2,1,8,0);
        end
        switch layer.type
            case {'Conv2d','DepthwiseConv2d'}
                ConvFunc = ['nn.',layer.type];
                [shift,bias_sft] = deal(shift_list(i+1),shift_list(i));
                if bias_sft==0
                    bias_sft=1;
                end
                if shift==0 && i~=27
                    shift=1;
                end
                
                [weight,bias,stride,padding,s,z] = deal(layer.weight,layer.bias,...
                    layer.builtin.stride,layer.builtin.padding,layer.scale,layer.zero_point);
                
                wordlen =32;
                fraclen =0;
                fcal = fimath('CastBeforeSum',0, 'OverflowMode', 'Saturate', 'RoundMode', 'floor', ... 
                    'ProductMode', 'SpecifyPrecision', 'SumMode', 'SpecifyPrecision', 'ProductWordLength',wordlen, ...
                    'ProductFractionLength',fraclen, 'SumWordLength', wordlen, 'SumFractionLength', fraclen);
                tcal = numerictype('WordLength', wordlen, 'FractionLength',fraclen);
                
                im_int = fi(net,tcal,fcal);
    
                % This step can be done offline.
                ker_int = fi(weight,tcal,fcal);
                z_ker = fi(z(2),tcal,fcal);
                
                ker_int = FAST.kernel.FastFiAddSub(ker_int,z_ker,@minus);
                
                if ~ismember(i,[6])
                    ker_int(ker_int>127)=127;
                    ker_int(ker_int<-128)=-128;
                else
                    max6 = max(ker_int.data(:));
                    min6 = min(ker_int.data(:));
                    alpha = -128/double(min6);
                    
                    ker_int = fi(round(double(ker_int.data)*alpha),tcal,fcal);
                    ker_int(ker_int>127)=127;
                    ker_int(ker_int<-128)=-128;
                    
                    bias = round(bias*alpha);
                    
                    s(1) = 1.0/alpha*s(1);
                end
                
                if strcmp(ConvFunc,'nn.Conv2d') 
                    conv_res = nn.Conv2d(im_int,ker_int,tcal,fcal,stride,padding);
                else
                    conv_res = nn.DepthwiseConv2d(im_int,ker_int,tcal,fcal,stride,padding);
                end
                              
                conv_res = nn.AddBias(conv_res,bitshift(fi(bias,tcal,fcal),-bias_sft),tcal,fcal);
                conv_res = fi(conv_res,1,16,0);
                conv_res = fi(conv_res,tcal,fcal);
                
                if i ~=29
                % OutputStage
                    [mul,n] = getShiftBits(s(1),s(2),s(3),13);
                    res_tmp = FAST.kernel.FastFiMultiply(conv_res,fi(mul,tcal,fcal));
                    res = bitshift(res_tmp,-(n-bias_sft+shift));
                    res(res<0)=0;
                    net = fi(res,1,8,0);
                else
                    net = conv_res;
                end
                stat{i} = net.data(:);
            case 'Softmax'
%                 fprintf(2,'Softmax Layer Detected.\n');
            case 'Pooling'
                [stride,padding] = deal(layer.builtin.stride,layer.builtin.padding);
                net = fi(net,t,f);
                net = nn.Pooling(net,t,f,[7,8],'LiteAVG',stride,padding);
                stat{i} = net.data(:);
                net = bitshift(net,-2);
                net = fi(net,1,8,0);
            case 'Reshape'
                new_shape = layer.builtin.new_shape;
                net = reshape(net,new_shape);
            otherwise
                warning('Unknown OP type detected.');
        end
    end
    res = net;
end

function [net,weight,bias] = StrategyExecutor(strgy,net,weight,bias)
    
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