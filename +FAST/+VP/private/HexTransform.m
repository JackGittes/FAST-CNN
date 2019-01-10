% Author: Zhao Mingxin
% Date:   2019/1/8
%{
    Args: 
        tensor/matrix/vector of fi object.
    Return:
        Byte form tensor/matrix/vector ranging from [0,255]
    For example, if a fi number is 16 bitwidth, HexTransform will split
    this number into two UINT8 number.
%}

function res = HexTransform(x)
    hex_str = x.hex;
    hex_str(hex_str==' ')='';
    hexN = length(hex_str);
    hex_cell = mat2cell(hex_str,1,2*ones(1,hexN/2));
    res = cellfun(@hex2dec,hex_cell);
end