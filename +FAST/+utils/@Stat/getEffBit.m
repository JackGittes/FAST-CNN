% Author: Zhao Mingxin
% Date: 2019/1/1
% Description: This function calculate the Most Significant Bit of a
% positive integer, it's useful for us to check the bitwidth distribution
% of parameters in a neural network.

function res = getEffBit(num)
    num(num==0)=1;
    res = ceil(log2(num+1));
end