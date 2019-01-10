function res = ParamsAllocator(kernels,bias,offset)
    if nargin<3
        offset = 0;
    end
    KerN = length(kernels);
    tmp_ = struct;
    res = repmat(tmp_,KerN,1);
    StartAdd = offset+1;
    for i=1:KerN
        res(i).Name = ['Layer ',num2str(i)];
        res(i).KerByteWidth = 1;
        res(i).KernelStart = StartAdd;
        EndAdd = StartAdd + numel(kernels{i})-1;
        res(i).KernelEnd = EndAdd;
        StartAdd = EndAdd+1;
    end
    BiasStart = EndAdd+1;
    for i =1:KerN
        res(i).BiasByteWidth = 2;
        res(i).BiasStart = BiasStart;
        BiasEnd = BiasStart + numel(bias{i})*2-1;
        res(i).BiasEnd = BiasEnd;
        BiasStart = BiasEnd+1;
    end
end