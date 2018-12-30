function res = GEMMwithSaturatedCast(mat_a,mat_b)
    assert(isa(mat_a,'FAST.Fi.FastFi')&&isa(mat_b,'FAST.Fi.FastFi'),"Must be FastFi");
    
    [ah,aw]=size(mat_a.data);
    [bh,bw]=size(mat_b.data);
    
    assert(aw==bh,"Inner Dimension Must Match.");
    
    [a_int,b_int,wl,fl] = deal(mat_a.numerictype.WordLength,mat_a.numerictype.FractionLength);
    [ub,lb] = deal(2^(wl-1)-1,-2^(wl-1));
    
    blk_size = 16;
    block_ = num2cell(ceil([ah,aw,bh,bw]/blk_size));
    [ah_n,aw_n,bh_n,bw_n] = block_{:};
    
    a_pad = int32(zeros(ah_n*blk_size,aw_n*blk_size));
    b_pad = int32(zeros(bh_n*blk_size,bw_n*blk_size));
    
    a_pad(1:ah,1:aw)=int32(a_int);
    b_pad(1:bh,1:bw)=int32(b_int);
    
    
    gpu_kernel = parallel.gpu.CUDAKernel('+FAST/+cuda/matmul/matmul.ptx','+FAST/+cuda/matmul/matmul.cu');
    gpu_kernel.GridSize=[bw_n,ah_n,1];
    gpu_kernel.ThreadBlockSize=[blk_size,blk_size,1];
    
    mat_c = int32(zeros(ah_n*blk_size,bw_n*blk_size));
    res_gpu = feval(gpu_kernel,a_pad,b_pad,ah_n*blk_size,aw_n*blk_size,bw_n*blk_size,ub,lb,mat_c);
    res = gather(res_gpu);
    
    data_res = res/2^(2*fl);
    res = FAST.Fi.FastFi(data_res,mat_a.numerictype,mat_a.fimath);
end