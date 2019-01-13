% Author: Zhao Mingxin
% Date:   2019/1/8
% Description: 
%{
    Args: 
        A list of bias vector, please make sure the bias is 1-dim and the
        height is 1. The current implementation only supports big-endian
        format which stores high significant bit in low address with priority.
    Return:
        An UINT8 format cell with big-endian storage format.
    Error:
        If the bias shape is not [1 x n], it will throw an error indicating
        that input shape is not compatible.
%}

function res = storeBias(varargin)
    res_cell = cell(1,length(varargin));
    for i=1:length(varargin)
        bias_vec = fi(varargin{i},1,16,0);
        if CheckShape(bias_vec)>0
            Hex_Little_Endian = HexTransform(bias_vec);
            Hex_Big_Endian = flipud(reshape(Hex_Little_Endian,2,[]));
            res_cell{i} = Hex_Big_Endian(:)';
        else
            error("Bias shape must be 1 dimension with height equal to 1.");
        end
    end
    res = cell2mat(res_cell);
end

function res = CheckShape(x)
    sp = size(x);
    res = double(sp(1)==1 && length(sp)==2);
end