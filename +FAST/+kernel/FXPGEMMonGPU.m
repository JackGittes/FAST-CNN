% Author: Zhao Mingxin
% Date:   2018/12/11
% Description: as below
%{
   Fixed point matrix multiplication on GPU.
   Only support bit-width<32 bits as GPU is more efficient.
   This code is tested on Nvidia GTX 1050Ti GPU and Nvidia GTX 1080 GPU.
%}
% TODO: It's a very simple implementation on GPU and does't use any
% advanced optimization techniques such as shared memory and loop tiling.
% So there's still a large margin to improve its performance.

function res = FXPGEMMonGPU(mat_a,mat_b)
    if ~isfi(mat_a) || ~isfi(mat_b)
        error('GPU Fixed point GEMM only support fi object for now.');
    end
    [ah,aw]=size(mat_a);
    [bh,bw]=size(mat_b);
    if aw~=bh
        error('Inner Dimension Must Match.');
    end
    
    % Get quantization info. 
    t = mat_a.numerictype;
    f = mat_a.fimath;
    FracLen = t.FractionLength;
%   WordLen = t.WordLength;
    
    % Set OverFlow bounds and apply pre-set overflow action on GPU
    CUDA_len = max([32,f.ProductWordLength]);
    up_bound = 2^(CUDA_len-1)-1;
    low_bound = -2^(CUDA_len-1);
  
    % More details please refer to CUDA Programming GUIDE.
    % Recommended CUDA block size is 16*16 or no more than 512.
    blk_size = 16;
    ah_n = ceil(ah/blk_size);
    aw_n = ceil(aw/blk_size);
    bh_n = ceil(bh/blk_size);
    bw_n = ceil(bw/blk_size);
    
    % Dequantization stage as described in DOC.
    a_pad = int32(zeros(ah_n*blk_size,aw_n*blk_size));
    b_pad = int32(zeros(bh_n*blk_size,bw_n*blk_size));
    
    a_int = mat_a.data*(2^mat_a.FractionLength);
    b_int = mat_b.data*(2^mat_b.FractionLength);
    
    a_pad(1:ah,1:aw)=int32(a_int);
    b_pad(1:bh,1:bw)=int32(b_int);
    
    % Send matrix to GPU and apply GPU GEMM in int32.
    gpu_kernel = parallel.gpu.CUDAKernel('+FAST\+cuda\matmul\matmul.ptx','+FAST\+cuda\matmul\matmul.cu');
    gpu_kernel.GridSize=[bw_n,ah_n,1];
    gpu_kernel.ThreadBlockSize=[blk_size,blk_size,1];
    
    % Get result matrix from GPU and reshape to output format.
    mat_c = int32(zeros(ah_n*blk_size,bw_n*blk_size));
    res_gpu = feval(gpu_kernel,a_pad,b_pad,ah_n*blk_size,aw_n*blk_size,bw_n*blk_size,up_bound,low_bound,mat_c);
    res = gather(res_gpu);
    
    % Re-quantization stage as described in DOC.
    res = fi(res(1:ah,1:bw)/2^(2*FracLen),t,f);
end