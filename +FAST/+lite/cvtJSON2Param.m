% Author: Zhao Mingxin
% Date: 2018/12/27

function res = cvtJSON2Param(json_par)
    op_parse = json_par.subgraphs.operators;
    tensor_list = json_par.subgraphs.tensors;
    tensor_buffer = json_par.buffers;
    
%     res = struct(length(op_parse),1);
    for i=1:length(op_parse)
        switch op_parse(i).opcode_index
            case {1,2}
                conv_op = op_parse(i).builtin_options;
                conv_type = {'Conv2d','DepthwiseConv2d'};

                node = getConvNode(i,op_parse);
                node_list = [node.in,node.weight,node.out];
                
                json_param = getParamFromJSON([node.weight,node.bias],tensor_list,tensor_buffer);
                
                res(i).type = conv_type{op_parse(i).opcode_index};
                res(i).weight = getTFStyleParam(json_param{1},tensor_list(node.weight).shape);
                res(i).bias = getBias(json_param{2});
                res(i).scale = getScaleZeroPoint(node_list,tensor_list,'Scale');
                res(i).zero_point = getScaleZeroPoint(node_list,tensor_list,'ZeroPoint');
                res(i).builtin.stride = [conv_op.stride_h,conv_op.stride_w];
                res(i).builtin.padding = conv_op.padding;
            case 3
                fprintf(2,'Softmax Layer Detected.\n');
                res(i).type = 'Softmax';
            case 4
                shape_op = op_parse(i).builtin_options;
                res(i).type = 'Reshape';
                res(i).builtin.new_shape = shape_op.new_shape;
            case 0
                pool_op = op_parse(i).builtin_options;
                padding = pool_op.padding;
                stride = [pool_op.stride_h,pool_op.stride_w];
                window_shape = [pool_op.filter_height,pool_op.filter_width];
                
                res(i).type = 'Pooling';
                res(i).builtin.pool_type = 'AVG';
                res(i).builtin.stride = stride;
                res(i).builtin.padding = padding;
                res(i).builtin.window = window_shape;
            otherwise
                warning('Unknown OP type detected.');
        end
    end
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