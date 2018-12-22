% Author: Zhao Mingxin
% Date:   2018/11/25
% Description: Pooling function for 2d pooling of input tensor

function res = Pooling(~,im,t,f,window_shape,pool_type,stride,pad_method)
    poolreg ={'MAX','AVG'};
    poolregfunc = {'max','mean'};
    func_reg = containers.Map(poolreg,poolregfunc);
    
    if ~isfi(im)
        im = fi(im,t,f);
    end
    
    if sum(stride>window_shape)>0
        error("stride>window_shape is not supported as Tensorflow do.");
    end
    
    switch nargin
        case 4
            res = PoolingByType(im,t,f,window_shape,[2,2],'SAME',@max);
        case 7
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
    
    if sum(window_shape>channel_size)
        error("Can't get window_shape>channel as TF do");
    end
    
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