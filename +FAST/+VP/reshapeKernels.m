function res = reshapeKernels(k)
    [h,w,k_in,k_out]=size(k);
    tmp_ = reshape(permute(k,[1,2,4,3]),h*w,2,[]);
    tmp_ = permute(tmp_,[2,1,3]);
    flt_ = tmp_(:);
    
    grp = k_out/2;
    
    flt_ = reshape(flt_,2*h*w,[]);
    k_cell = mat2cell(flt_,2*h*w,ones(1,grp*k_in));
    tmp_ = reshape(reshape(k_cell,grp,[])',1,[]);
    res = cell2mat(tmp_);
    res = res(:);
end