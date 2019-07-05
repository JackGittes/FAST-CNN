function res = reshapeKernels(k,par_grp)
    if nargin < 2
        par_grp =2;
    end
    par_grp = par_grp*2;
    
    if length(size(k)) == 4
        [h,w,k_in,k_out]=size(k);
    else
        [h,w,k_out]=size(k);
        k_in = 1;
    end
    col_array
    
    tmp_ = reshape(permute(k,[2,1,4,3]),h*w,par_grp,[]);
    tmp_ = permute(tmp_,[2,1,3]);
    flt_ = tmp_(:);
    
    grp = k_out/par_grp;
    
    flt_ = reshape(flt_,par_grp*h*w,[]);
    k_cell = mat2cell(flt_,par_grp*h*w,ones(1,grp*k_in));
    tmp_ = reshape(reshape(k_cell,grp,[])',1,[]);
    res = cell2mat(tmp_);
    res = res(:);
end