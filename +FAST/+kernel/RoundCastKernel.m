%{
    Author:  Zhao Mingxin
    Date:  2020/11/10
    Description: Matlab interface for calling RoundCast.cu.
%}
function res=RoundCastKernel(im, mul, shift, bit_width)
    [h,w,d] = size(im);
    blk_size = 16; % Recommended block size = 16
    
    gpu_kernel=parallel.gpu.CUDAKernel('+FAST/+cuda/Arithmetic/RoundCast.ptx',...
        '+FAST/+cuda/Arithmetic/RoundCast.cu');
    gpu_kernel.GridSize=[ceil(h/blk_size),ceil(w/blk_size),d];
    gpu_kernel.ThreadBlockSize=[blk_size,blk_size,1];
    
    tmp_res = int64(zeros(h,w,d));
    res_gpu = feval(gpu_kernel,int64(im.data),tmp_res,int32(mul), ...
        int32(shift),int32(bit_width),h,w,d);
    res_cpu = gather(res_gpu);
    res=fi(res_cpu,im.numerictype,im.fimath);
end