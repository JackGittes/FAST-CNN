% Author: Zhao Mingxin
% Date: 2018/12/27
% Description: This function is used to convert JSON format lite-CNN to
% MATLAB struct. Params definition can be found in Schema.fbs file provided
% by Google TensorFlow. The official version schema has 3 variants, this
% function use the 3rd variant to parse params from JSON to MATLAB struct.

function res = cvtJSON2Param(json_par)
    op_parse = json_par.subgraphs.operators;
    tensor_list = json_par.subgraphs.tensors;
    tensor_buffer = json_par.buffers;
    
    tmp_ = struct;
    res = repmat(tmp_,[length(op_parse),1]);
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
                warning("Softmax Layer Detected. This layer won't be converted.");
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