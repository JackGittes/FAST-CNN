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

function res = runLiteWithJsonParams(par,inputs,t,f)
    op_parse = par.subgraphs.operators;
    tensor_list = par.subgraphs.tensors;
    tensor_buffer = par.buffers;
    
%     input_node = par.subgraphs.inputs;
%     output_node = par.subgraphs.outputs;
    
    for i=1:length(op_parse)
        if i==1
            net = inputs;
        end
        switch op_parse(i).opcode_index
            case 1
                out_node = op_parse(i).outputs+1;
                in_node = op_parse(i).inputs(1)+1;
                weight_n = op_parse(i).inputs(2)+1;
                bias_n = op_parse(i).inputs(3)+1;
                
                conv_w = tensor_buffer{tensor_list(weight_n).buffer+1,1}.data;
                bias_w = tensor_buffer{tensor_list(bias_n).buffer+1,1}.data;
                conv_w_tf = getTFStyleParams(conv_w,tensor_list(weight_n).shape,'Conv2d');
                bias_w_tf = getBias(bias_w);
                
                s1 = tensor_list(in_node).quantization.scale;
                s2 = tensor_list(weight_n).quantization.scale;
                s3 = tensor_list(out_node).quantization.scale;
                
                z_im = tensor_list(in_node).quantization.zero_point;
                z_ker = tensor_list(weight_n).quantization.zero_point;
                z_res = tensor_list(out_node).quantization.zero_point;
                
                conv_op = op_parse(i).builtin_options;
                stride = [conv_op.stride_h,conv_op.stride_w];
                padding = conv_op.padding;
                
                net = nn.LiteConv2d(net,conv_w_tf,z_im,z_ker,z_res,s1,s2,s3,'Conv2d',stride,padding,bias_w_tf);

            case 2
                out_node = op_parse(i).outputs+1;
                in_node = op_parse(i).inputs(1)+1;
                weight_n = op_parse(i).inputs(2)+1;
                bias_n = op_parse(i).inputs(3)+1;
                
                conv_w = tensor_buffer{tensor_list(weight_n).buffer+1,1}.data;
                bias_w = tensor_buffer{tensor_list(bias_n).buffer+1,1}.data;
                conv_w_tf = getTFStyleParams(conv_w,tensor_list(weight_n).shape,'DepthwiseConv2d');
                bias_w_tf = getBias(bias_w);
                
                s1 = tensor_list(in_node).quantization.scale;
                s2 = tensor_list(weight_n).quantization.scale;
                s3 = tensor_list(out_node).quantization.scale;
                
                z_im = tensor_list(in_node).quantization.zero_point;
                z_ker = tensor_list(weight_n).quantization.zero_point;
                z_res = tensor_list(out_node).quantization.zero_point;
                
                conv_op = op_parse(i).builtin_options;
                stride = [conv_op.stride_h,conv_op.stride_w];
                padding = conv_op.padding;
                
                net = nn.LiteConv2d(net,conv_w_tf,z_im,z_ker,z_res,s1,s2,s3,'DepthwiseConv2d',stride,padding,bias_w_tf);
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
                net = nn.Pooling(net,t,f,window_shape,'AVG',stride,padding);
                net = fi(net,0,8,0);
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
function res = getTFStyleParams(par,shape,layer_type)
    switch layer_type
        case 'Conv2d'
            tmp = permute(reshape(par,fliplr(shape')),[4,3,2,1]);
            res = permute(tmp,[2,3,4,1]);
        case 'DepthwiseConv2d'
            tmp = permute(reshape(par,fliplr(shape')),[4,3,2,1]);
            res = permute(tmp,[2,3,4,1]);
        otherwise
            error('Unknown Layer Type.');
    end
end

function res = getBias(ubias)
    int8bias = reshape(ubias,4,[])';
    [h,~]=size(int8bias);
    bias_cell = mat2cell(int8bias,ones(1,h),4);
    double_bias = cellfun(@(x) double(typecast(uint8(x),'int32')),bias_cell);
    res = double_bias';
end