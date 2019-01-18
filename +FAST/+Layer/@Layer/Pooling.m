% Author: Zhao Mingxin
% Date:   2018/11/25
% Description: Pooling function for 2d pooling of input tensor

function res = Pooling(~,im,t,f,window_shape,pool_type,stride,pad_method)
    poolreg ={'MAX','AVG','LiteAVG'};
    poolregfunc = {'max','mean','LiteAVG'};
    func_reg = containers.Map(poolreg,poolregfunc);
    
    % Do necessary check for input args.
    assert(isfi(im),"Input Feature Map is NOT a fi object.");
    assert(min(stride<=window_shape),"stride>window_shape is not supported as TensorFlow does.");
    
    switch nargin
        case 5
            res = PoolingByType(im,t,f,window_shape,[2,2],'SAME',@max);
        case 8
            try
                pool_func = func_reg(pool_type);
            catch
                error("Unsupported Pooling function");
            end
            res = PoolingByType(im,t,f,window_shape,stride,pad_method,str2func(pool_func));
        otherwise
            error("Input Parameters Not Match");
    end
end

function res = PoolingByType(im,t,f,window_shape,stride,pad_method,pool_func)
    [im_h,im_w,im_d] = size(im);
    channel_size = [im_h,im_w];
    
    assert(min(window_shape<=channel_size),"Can't get window_shape>channel as TF does");
    
    [im,out_size,channel_size] = FAST.op.PaddingByType(im,t,f,im_d,window_shape,channel_size,stride,pad_method);
    
    res = PoolingTensor(im,im_d,channel_size,out_size,window_shape,stride,pool_func);
    res = fi(res,t,f);
end

function res = PoolingTensor(im,im_d,channel_size,out_size,window_shape,stride,pool_func)
%   Get element position of input feature map.
    tmp1 = FAST.op.GetElemPos(im_d,channel_size,out_size,window_shape,stride);
    
%   Implement pooling function on im2col and reshape result into output shape
    res = permute(reshape(pool_func(im(tmp1)),[fliplr(out_size),im_d]),[2,1,3]);
end

function res = LiteAVG(x)
%     [num,~] = size(x);
%     mul = floor(2^8/num);
%     shift = 8;
    res = bitshift(sum(x),-4);
end