% Author: Zhao Mingxin
% Date:   2019/1/18
% Description: Run tflite fixed point CNN using JSON parameters.
%{
    Args: 
        A Net object initialized with MobileNet 224x256 version parameters.
        More details 
    Return:
        Network result of the last layer.
    Error:
        No error is directly defined in this function.
    NOTE：
        A more compact style Forward function maybe realized by recursively
        invoking itself but doing this may also lead to observe intermediate 
        result between layers toughly.
%}

function res = Forward_on_VP(obj)
    [model,inputs,tcal,fcal,nn] = deal(obj.model,obj.inputs,obj.Numeric,obj.Fimath,obj.nn);
    
    for i=1:length(model)
        layer = model(i);
        if i==1
            net = fi((double(inputs)-128)/2,1,8,0);
        end
        switch layer.type
            case {'Conv2d','DepthwiseConv2d'}
                ConvFunc = ['nn.',layer.type];
                
                [weight,bias,stride,padding,mul,shift] = deal(layer.weight,layer.bias,...
                    layer.builtin.stride,layer.builtin.padding,layer.mul,layer.shift);
                net = fi(net,tcal,fcal);
                
                inputVar = FAST.op.getVarName(net,weight,tcal,fcal,stride,padding);
                ConvFunc_ = [ConvFunc,'(',inputVar,')',';'];
                conv_res = eval(ConvFunc_);
                              
                conv_res = nn.AddBias(conv_res,fi(bias,tcal,fcal),tcal,fcal);
                
                conv_res = fi(conv_res,1,16,0);
                
                conv_res = fi(conv_res,tcal,fcal);
                if i ~=29
                % OutputStage
                    res_tmp = FAST.kernel.FastFiMultiply(conv_res,fi(mul,tcal,fcal));
                    res = bitshift(res_tmp,-shift);
                    res(res<0)=0;
                    net = fi(res,1,8,0);
                else
                    net = conv_res;
                end
            case 'Softmax'
            case 'Pooling'
                [stride,padding] = deal(layer.builtin.stride,layer.builtin.padding);
                net = fi(net,tcal,fcal);
                net = nn.Pooling(net,tcal,fcal,[7,8],'LiteAVG',stride,padding);
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