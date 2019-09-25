% Author: Zhao Mingxin
% Date:   2018/12/25
% Description: as below
%{
    Args: 
        a/b: fi object need to be converted to INT type.
        type: specific output format, no default value.
    Return:
    Error: 
        TypeError_1: non-fi object inputs detected.
        TypeError_2: non-supported convert type.
%}

function [int_a,int_b,WordLen,FracLen,up_bound,low_bound] = FiToInt(a,b,type)
    assert(isfi(a)&&isfi(b),"Convert Function Only supports fi object.");
    type_reg = {'int64','int32'};
    assert(ismember(type,type_reg),"Unsupported Convert Type.");
    
    Input_cell = {a,b};

    [WordLen,FracLen] = deal(a.WordLength,a.FractionLength);
    
    convt_func = str2func(type);
    
    % TODO: upbound and lowbound need to be change.
    up_bound = 2^(WordLen-1)-1;
    low_bound = -2^(WordLen-1);
    Output_cell = cellfun(@(x) convt_func(x.int),Input_cell,'UniformOutput',false);
    
    [int_a,int_b]=Output_cell{:};
end