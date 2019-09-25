% Author: Zhao Mingxin
% Date:   2018/12/10
% Description: as below

% The first argument par is a 1-dim array which is little-endian format according to fbs
% definition. The second arg shape typically is a [N,C,H,W] array. This function aims to 
% transform flatc_buffer pre-defined parameters to TensorFlow-style
% parameters so that we can use these params to perform inference using
% FixedCNN simulation library.
function res = getTFStyleParam(par,shape)
    tmp = permute(reshape(par,fliplr(shape')),[4,3,2,1]);
    res = permute(tmp,[2,3,4,1]);
end