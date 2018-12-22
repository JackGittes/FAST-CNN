% Author: Zhao Mingxin
% Date:   2018/12/10
% Description: as below

function res = getTFStyleBias(ubias)
    int8bias = reshape(ubias,4,[])';
    [h,~]=size(int8bias);
    bias_cell = mat2cell(int8bias,ones(1,h),4);
    double_bias = cellfun(@(x) double(typecast(uint8(x),'int32')),bias_cell);
    res = double_bias';
end