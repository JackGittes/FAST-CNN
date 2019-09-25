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

function [res,stat] = Forward_v3(obj)
    [model,inputs,t,f,nn] = deal(obj.model,obj.inputs,obj.Numeric,obj.Fimath,obj.nn);
    
    stat = cell(1,length(model));
    for i=1:length(model)
        layer = model(i);
        if i==1
            net = inputs;
        end
        switch layer.type
            case {'Conv2d','DepthwiseConv2d'}
                [weight,bias,stride,padding,s,z] = deal(layer.weight,layer.bias,...
                    layer.builtin.stride,layer.builtin.padding,layer.scale,layer.zero_point);
                if i~=29
                    [net,stat{i}] = nn.LiteConv2d_beta(net,weight,z(1),z(2),z(3),s(1),s(2),s(3),layer.type...
                        ,stride,padding,bias,0);
                else
                    [net,stat{i}] = nn.LiteConv2d_beta(net,weight,z(1),z(2),z(3),s(1),s(2),s(3),layer.type...
                        ,stride,padding,bias,2);
                end
            case 'Softmax'
%                 fprintf(2,'Softmax Layer Detected.\n');
            case 'Pooling'
                [stride,padding] = deal(layer.builtin.stride,layer.builtin.padding);
                net = fi(net,t,f);
                net = nn.Pooling(net,t,f,[7,7],'AVG',stride,padding);
                stat{i} = net.data(:);
                net = fi(net,0,8,0);
            case 'Reshape'
                new_shape = layer.builtin.new_shape;
                net = reshape(net,new_shape);
            otherwise
                warning('Unknown OP type detected.');
        end
    end
    res = net;
end