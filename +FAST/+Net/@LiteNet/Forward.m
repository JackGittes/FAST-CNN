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

function [res,stat] = Forward(obj)
    [par,inputs,t,f,nn] = deal(obj.params,obj.inputs,obj.Numeric,obj.Fimath,obj.nn);
    
    op_parse = par.subgraphs.operators;
    tensor_list = par.subgraphs.tensors;
    tensor_buffer = par.buffers;
    shift_list=[1,2,1,0,0,0,1,1,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,1,0,3,0,0];
    
    stat = cell(1,length);
    for i=1:length(op_parse)
        if i==1
            net = fi((double(inputs)-128)/2,1,8,0);
        end
        switch op_parse(i).opcode_index
            case {1,2}
                conv_type = {'Conv2d','DepthwiseConv2d'};
                node = getConvNode(i,op_parse);
                node_list = [node.in,node.weight,node.out];
                
                json_param = getParamFromJSON([node.weight,node.bias],tensor_list,tensor_buffer);
                conv_w_tf = getTFStyleParam(json_param{1},tensor_list(node.weight).shape);
                bias_w_tf = getBias(json_param{2});
                
                s = getScaleZeroPoint(node_list,tensor_list,'Scale');
                z = getScaleZeroPoint(node_list,tensor_list,'ZeroPoint');
                
                conv_op = op_parse(i).builtin_options;
                stride = [conv_op.stride_h,conv_op.stride_w];
                padding = conv_op.padding;
                
                [shift,bias_sft] = deal(shift_list(i+1),shift_list(i));
                
                if bias_sft==0
                    bias_sft=1;
                end
                
                if shift==0 && i~=27
                    shift=1;
                end
                [net,stat{i}] = nn.LiteConv2d(net,conv_w_tf,z(1),z(2),z(3),s(1),s(2),s(3),conv_type{op_parse(i).opcode_index}...
                    ,stride,padding,bias_w_tf,shift,bias_sft);
            case 3
                fprintf(2,'Softmax Layer Detected.\n');
            case 4
                shape_op = op_parse(i).builtin_options;
                new_shape = shape_op.new_shape;
                net = reshape(net,new_shape);
            case 0
                pool_op = op_parse(i).builtin_options;
                padding = pool_op.padding;
                stride = [pool_op.stride_h,pool_op.stride_w];
                window_shape = [pool_op.filter_height,pool_op.filter_width];
                
                net = fi(net,t,f);
                net = nn.Pooling(net,t,f,[7,8],'AVG',stride,padding);
                
                net = bitshift(net,-2);
                stat{i}=net.data(:);
                net = fi(net,1,8,0);
                
                fprintf('Pooling Max is %d, Min is %d\n',max(net(:)),min(net(:)));
            otherwise
                warning('Unknown OP type detected.');
        end
    end
    res = net;
end

% The first argument par is a 1-dim array which is little-endian format according to fbs
% definition. The second arg shape typically is a [N,C,H,W] array. This function aims to 
% transform flatc_buffer pre-defined parameters to TensorFlow-style
% parameters so that we can use these params to perform inference using
% FixedCNN simulation library.
function res = getTFStyleParam(par,shape)
    tmp = permute(reshape(par,fliplr(shape')),[4,3,2,1]);
    res = permute(tmp,[2,3,4,1]);
end

function res = getBias(ubias)
    int8bias = reshape(ubias,4,[])';
    [h,~]=size(int8bias);
    bias_cell = mat2cell(int8bias,ones(1,h),4);
    double_bias = cellfun(@(x) double(typecast(uint8(x),'int32')),bias_cell);
    res = double_bias';
end

function res = getScaleZeroPoint(node_list,tensor_list,type)
    switch type
        case 'ZeroPoint'
            res = arrayfun(@(node) tensor_list(node).quantization.zero_point,node_list);
        case 'Scale'
            res = arrayfun(@(node) tensor_list(node).quantization.scale,node_list);
        otherwise
            error('Unknown Node Data Type.');
    end
end

function res = getConvNode(num,parsed_op)
    Op = parsed_op(num);
    [res.out,res.in,res.weight,res.bias]= deal(Op.outputs+1,Op.inputs(1)+1,Op.inputs(2)+1,Op.inputs(3)+1);
end

function res = getParamFromJSON(node,tensor_list,buffer)
    res = cellfun(@(x) buffer{tensor_list(x).buffer+1,1}.data,num2cell(node),'UniformOutput',false);
end