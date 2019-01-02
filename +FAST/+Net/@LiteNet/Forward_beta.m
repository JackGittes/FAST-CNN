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

function [res,stat] = Forward_beta(obj)
    [model,inputs,Strategy,t,f,nn] = deal(obj.model,obj.inputs,obj.strategy_list,obj.Numeric,obj.Fimath,obj.nn);
    stat = cell(1,length(model));
    for i=1:length(model)
        layer = model(i);
        if i==1
            if ~isempty(Strategy(i).net)
                net = StrategyExecutor(strategy(i).net,inputs); 
            else
                net = fi(inputs,t,f);
            end
        end
        switch layer.type
            case {'Conv2d','DepthwiseConv2d'}
                [weight,bias,stride,padding,s,z] = deal(layer.weight,layer.bias,...
                    layer.builtin.stride,layer.builtin.padding,layer.scale,layer.zero_point);
                
                net = StrategyNodeChecker(obj,Strategy(i).net,net);
                weight = StrategyNodeChecker(obj,Strategy(i).weight,weight);
                bias = StrategyNodeChecker(obj,Strategy(i).bias,bias);

                ConvFunc = ['nn.',layer.type,'(','net,','weight,','tcal,','fcal,','stride,','padding',')',';'];
                conv_res = eval(ConvFunc);
                conv_res = StrategyNodeChecker(obj,Strategy(i).Conv,conv_res);
                
                conv_res = nn.AddBias(conv_res,bias,t,f);
                
                net = StrategyNodeChecker(obj,Strategy(i).Output,conv_res);
                stat{i} = net.data(:);
            case 'Softmax'
            case 'Pooling'
                [stride,padding] = deal(layer.builtin.stride,layer.builtin.padding);
                
                net = StrategyNodeChecker(obj,Strategy(i).prePooling,net);
                net = nn.Pooling(net,t,f,[7,8],'LiteAVG',stride,padding);
                
                stat{i} = net.data(:);
                net = StrategyNodeChecker(obj,Strategy(i).postPooling,net);
            case 'Reshape'
                new_shape = layer.builtin.new_shape;
                net = reshape(net,new_shape);
            otherwise
                warning('Unknown layer type detected.');
        end
    end
    res = net;
end

function res = StrategyNodeChecker(obj,Strategy,input)
    if ~isempty(Strategy)
        res = obj.StrategyExecutor(Strategy,input);
    else
        res = input;
    end
end