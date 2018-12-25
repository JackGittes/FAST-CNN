% Author: Zhao Mingxin
% Date:   2018/12/25
% Description: as below

function [int_a,int_b,WordLen,FracLen,up_bound,low_bound] = FiToInt(a,b,type)
    assert(isfi(a)&&isfi(b),"Convert Function Only supports fi object.");
    type_reg = {'int64','int32'};
    assert(ismember(type,type_reg),"Unsupported Convert Type.");
    
    Input_cell = {a,b};

    [WordLen,FracLen] = deal(a.WordLength,a.FractionLength);
    
    convt_func = str2func(type);
    
    up_bound = convt_func(a.intmax);
    low_bound = convt_func(a.intmin);
    Output_cell = cellfun(@(x) convt_func(x.int),Input_cell,'UniformOutput',false);
    
    [int_a,int_b]=Output_cell{:};
end