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
                ConvFunc = ['nn.',layer.type];
                
                if ~isempty(Strategy(i).net)
                   net = obj.StrategyExecutor(Strategy(i).net,net); 
                end
                
                if ~isempty(Strategy(i).weight)
                   ker_int = obj.StrategyExecutor(Strategy(i).weight,net); 
                end
                
                if ~isempty(Strategy(i).bias)
                   bias = obj.StrategyExecutor(Strategy(i).bias,bias);
                end

                if strcmp(ConvFunc,'nn.Conv2d') 
                    conv_res = nn.Conv2d(im_int,ker_int,t,f,stride,padding);
                else
                    conv_res = nn.DepthwiseConv2d(im_int,ker_int,t,f,stride,padding);
                end
                
                if ~isempty(Strategy(i).Conv)
                    conv_res = obj.StrategyExecutor(Strategy(i).Conv,conv_res);
                end
                
                conv_res = nn.AddBias(conv_res,bias,t,f);
                
                if ~isempty(Strategy(i).Output)
                    net = obj.StrategyExecutor(Strategy(i).Output,conv_res);
                end
                stat{i} = net.data(:);
            case 'Softmax'

            case 'Pooling'
                [stride,padding] = deal(layer.builtin.stride,layer.builtin.padding);
                
                if ~isempty(Strategy(i).prePooling)
                    net = obj.StrategyExecutor(Strategy(i).prePooling,net);
                end
                net = nn.Pooling(net,t,f,[7,8],'LiteAVG',stride,padding);
                stat{i} = net.data(:);
                if ~isempty(Strategy(i).postPooling)
                    net = obj.StrategyExecutor(Strategy(i).postPooling,net);
                end
            case 'Reshape'
                new_shape = layer.builtin.new_shape;
                net = reshape(net,new_shape);
            otherwise
                warning('Unknown OP type detected.');
        end
    end
    res = net;
end