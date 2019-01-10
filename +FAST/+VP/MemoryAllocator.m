function res = MemoryAllocator(type,varargin)
    Reg_type = {'Parameter','Map'};
    Allocator_reg = {'ParamsAllocator','MapAllocator'};
    AllocatorLUT = containers.Map(Reg_type,Allocator_reg);
    try
        func_str = AllocatorLUT(type);
    catch
        error("Allocator search error.");
    end
    alloc = str2func(func_str);
    res = alloc(varargin{:});
end