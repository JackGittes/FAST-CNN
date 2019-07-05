% Author: Zhao Mingxin
% Date:   2018/12/11
% Description: as below
%{
   Fixed point matrix multiplication on GPU.
   Only support bit-width<32 bits as GPU is more efficient.
   This code is tested on Nvidia GTX 1050Ti GPU and Nvidia GTX 1080 GPU.

   Update(2019/1/2): Add 64-bit support.
%}
% TODO: It's a very simple implementation on GPU and does't use any
% advanced optimization techniques such as shared memory and loop tiling.
% So there's still a large margin to improve its performance.

function res = FXPGEMMonGPU(mat_a,mat_b)
    assert(isfi(mat_a)&&isfi(mat_b),"GPU Fixed point GEMM only support fi object for now.");
    
    [ah,aw]=size(mat_a);
    [bh,bw]=size(mat_b);

    assert(aw==bh,"Inner Dimension Must Match.");
    
    % Set OverFlow bounds and apply pre-set overflow action on GPU
    [a_int,b_int,WordLen,FracLen,~,~] = FAST.kernel.FiToInt(mat_a,mat_b,'int64');
%     [up_bound,low_bound]=deal(2^(2*WordLen-1)-1,-2^(2*WordLen-1));
    [up_bound,low_bound]=deal(2^31-1,-2^31);
    
    if up_bound > 2^31-1 || low_bound < -2^31
        intfunc = str2func('int64');
        cuda_path = '+FAST/+cuda/matmul/64_bit/matmul_64';
    else
        intfunc = str2func('int32');
        cuda_path = '+FAST/+cuda/matmul/32_bit/matmul';
    end
  
    % More details please refer to CUDA Programming GUIDE.
    % Recommended CUDA block size is 16*16 or no more than 512.
    blk_size = 16;
    block_ = num2cell(ceil([ah,aw,bh,bw]/blk_size));
    [ah_n,aw_n,bh_n,bw_n] = block_{:};
    
    % Dequantization stage as described in DOC.
    a_pad = intfunc(zeros(ah_n*blk_size,aw_n*blk_size));
    b_pad = intfunc(zeros(bh_n*blk_size,bw_n*blk_size));
    
    a_pad(1:ah,1:aw)=intfunc(a_int);
    b_pad(1:bh,1:bw)=intfunc(b_int);
    
    % Send matrix to GPU and apply GPU GEMM in int32 or int64.
    gpu_kernel = parallel.gpu.CUDAKernel([cuda_path,'.ptx'],[cuda_path,'.cu']);
    gpu_kernel.GridSize=[bw_n,ah_n,1];
    gpu_kernel.ThreadBlockSize=[blk_size,blk_size,1];
    
    % Get result matrix from GPU and reshape to output format.
    mat_c = intfunc(zeros(ah_n*blk_size,bw_n*blk_size));
    res_gpu = feval(gpu_kernel,a_pad,b_pad,ah_n*blk_size,aw_n*blk_size,bw_n*blk_size,up_bound,low_bound,mat_c);
    res_int = gather(res_gpu);
    
    % Re-quantization stage as described in DOC.
%     tmp_ = bitshift(res_int(1:ah,1:bw),-FracLen);
%     res = fi(double(tmp_)/2^(FracLen),mat_a.numerictype,mat_a.fimath);
    
    res = fi(double(res_int(1:ah,1:bw))/2^(2*FracLen),mat_a.numerictype,mat_a.fimath);
end