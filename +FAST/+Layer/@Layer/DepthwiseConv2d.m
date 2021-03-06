% Author: Zhao Mingxin
% Date:   2018/11/25
% Description: as below
%{
    NOTE: DepthwiseConv2d does't support stride x ~= stride y for now as
    Tensorflow do.
    If the MultiCore mode is on, this function can get about 2 times
    speedup on 6 Cores Intel Core i5-8400 CPU.
%}

function res = DepthwiseConv2d(obj,im,ker,t,f,stride,padding_method)
    [im_h,im_w,im_d]=size(im);
    [k_h,k_w,k_in,multiplier] = size(ker);
    
    window_shape = [k_h,k_w];
    channel_size = [im_h,im_w];
    
    % Do some check and throw error info if input args don't meet these conditions.
    assert(im_d==k_in,"Input Feature Map dimension and Filter dimension don't match.");
    assert(stride(1)==stride(2),"Current implementation only supports equal length strides in the row and column dimensions as TF does.");
    
    % Padding input feature map according to its padding type.
    [im,out_size,channel_size] = FAST.op.PaddingByType(im,t,f,im_d,window_shape,channel_size,stride,padding_method);
    
    % Calculating DepthwiseConv2d according to its mode.
    switch obj.Mode
        case 'GPU'
            res = FAST.kernel.DepthwiseConvGPU(im,ker,t,f,im_d,multiplier,channel_size,out_size,window_shape,stride);
        case {'MultiCore','SingleCore'}
            res = FAST.kernel.DepthwiseConvCPU(obj,im,ker,t,f,im_d,multiplier,channel_size,out_size,window_shape,stride);
        otherwise
            error('Unknown Computation Mode.');
    end
end