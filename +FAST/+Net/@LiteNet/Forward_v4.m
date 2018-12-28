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

function [res,stat] = Forward_v4(obj)
    [model,inputs,strategy,t,f,nn] = deal(obj.model,obj.inputs,obj.strategy_list,obj.Numeric,obj.Fimath,obj.nn);
    strategy  = zeros(1,length(model));
    shift_list=[1,2,1,0,0,0,1,1,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,1,0,3,0,0];
    
    stat = cell(1,length(model));
    for i=1:length(model)
        layer = model(i);
        if i==1
            net = inputs;
            net = fi((double(inputs)-128)/2,1,8,0);
        end
        switch layer.type
            case {'Conv2d','DepthwiseConv2d'}
                [weight,bias,stride,padding,s,z] = deal(layer.weight,layer.bias,...
                    layer.builtin.stride,layer.builtin.padding,layer.scale,layer.zero_point);
                    
                [shift,bias_sft] = deal(shift_list(i+1),shift_list(i));
                
                if bias_sft==0
                    bias_sft=1;
                end
                
                if shift==0 && i~=27
                    shift=1;
                end
                [net,stat{i}] = nn.LiteConv2d(net,conv_w_tf,z(1),z(2),z(3),s(1),s(2),s(3),conv_type{op_parse(i).opcode_index}...
                    ,stride,padding,bias_w_tf,shift,bias_sft);
            case 'Softmax'
%                 fprintf(2,'Softmax Layer Detected.\n');
            case 'Pooling'
                [stride,padding] = deal(layer.builtin.stride,layer.builtin.padding);
                net = fi(net,t,f);
                net = nn.Pooling(net,t,f,[7,7],'AVG',stride,padding);
                stat{i} = net.data(:);
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