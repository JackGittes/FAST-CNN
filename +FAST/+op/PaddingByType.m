% Author: Zhao Mingxin
% Date:   2018/11/25
% Description: Padding function for Conv2d and Pooling, only supports SAME
%               and VALID mode with zeros padding.
%{ 
    Problems needed to solve 
    TODO: 
        problem 1: stride>channel_size
        problem 2: window_shape>channel_size
        problem 3: pooling padding is mirror mode in Tensorflow by default
    NOTE:
        stride>window_shape is NOT supported as Tensorflow do. If you set
        stride>window_shape, Tensorflow will throw a ValueError:
        ValueError: strides > window_shape not supported due to inconsistency between CPU and GPU implementations
%}

function [res,out_size,new_channel_size] = PaddingByType(im,t,f,im_d,window_shape,channel_size,stride,padding_type)
    switch padding_type
        case 'SAME'
            out_size = ceil(channel_size./stride);
        %   Padding pixel computed using Tensorflow method in tensorflow/core/kernels/ops_util.cc
            pad_needed = max((out_size-1).*stride + window_shape - channel_size,[0,0]);
            pad_top_left = floor(pad_needed/2);
        %   pad_bottom_right = pad_needed - pad_top_left;
            res = fi(zeros([channel_size+pad_needed,im_d]),t,f);        
            pad_end = pad_top_left + channel_size;
            res(1+pad_top_left(1):pad_end(1),1+pad_top_left(2):pad_end(2),:)=im;
        case 'VALID'
            out_size =ceil((channel_size - window_shape +1)./stride);
            pad_needed = [0,0];
            res = im;
        otherwise
            error('Unknown Padding Type');
    end
    new_channel_size = pad_needed + channel_size;
end