% Author: Zhao Mingxin
% Date:   2018/12/11
% Description: as below

function res = DepthwiseConvGPU(im,ker,t,f,im_d,multiplier,channel_size,out_size,window_shape,stride)
%   Get element position of input feature map.
    im_pos = FAST.op.GetElemPos(im_d,channel_size,out_size,window_shape,stride);
    
    blk_size = 16;
    
    [ker,im,~,FracLen,up_bound,low_bound] = FAST.kernel.FiToInt(ker,im,'int32');

%   Reshape kernel and input feature map into im2col cell
    ker_mat = reshape(permute(ker,[1,2,4,3]),[prod(window_shape),im_d*multiplier]);
    im_mat = reshape(im(im_pos),prod(window_shape),[]);
    
    im_in = reshape(im_mat,prod(window_shape),prod(out_size),im_d);
    ker_in = permute(reshape(ker_mat,prod(window_shape),multiplier,im_d),[2,1,3]);
    
    ker_hn = ceil(multiplier/blk_size);
    ker_wn = ceil(prod(window_shape)/blk_size);
    im_hn = ceil(ker_wn/blk_size);
    im_wn = ceil(prod(out_size)/blk_size);
    
    ker_pad = int32(zeros(ker_hn*blk_size,ker_wn*blk_size,im_d));
    im_pad = int32(zeros(im_hn*blk_size,im_wn*blk_size,im_d));
    
    ker_pad(1:multiplier,1:prod(window_shape),:)=ker_in;
    im_pad(1:prod(window_shape),1:prod(out_size),:)=im_in;
    
    gpu_kernel=parallel.gpu.CUDAKernel('+FAST/+cuda/DepthwiseGEMM/64_bit/DepthwiseGEMM_64.ptx','+FAST/+cuda/DepthwiseGEMM/64_bit/DepthwiseGEMM_64.cu');
    gpu_kernel.GridSize=[ker_hn,im_wn,im_d];
    gpu_kernel.ThreadBlockSize=[blk_size,blk_size,1];
    
    tmp = int32(zeros(ker_hn*blk_size,im_wn*blk_size,im_d));
    res_gpu = feval(gpu_kernel,ker_pad,im_pad,ker_hn*blk_size,ker_wn*blk_size,im_wn*blk_size,up_bound ...
        ,low_bound,tmp);
    
    % Gather result from GPU device
    res_cpu = gather(res_gpu);
    res_tmp = res_cpu(1:multiplier,1:prod(out_size),:);
    
    % Reshape to Output shape.
    res_tmp = reshape(permute(res_tmp,[2,1,3]),[out_size,multiplier,im_d]);
    res_tmp = permute(res_tmp,[1,2,4,3]);
    res_tmp = permute(reshape(res_tmp,[fliplr(out_size),im_d*multiplier]),[2,1,3]);
    
    % De-quantize output.
    res = fi(res_tmp/2^(2*FracLen),t,f);
end