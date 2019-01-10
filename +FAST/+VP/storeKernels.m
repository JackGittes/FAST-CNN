function res = storeKernels(varargin)
    tmp_ = cellfun(@FAST.VP.reshapeKernels,varargin,'UniformOutput',false);
    res = cell2mat(reshape(tmp_,[],1))'; 
end