% Author: Zhao Mingxin
% Date: 2019/1/3
% Description: Function used to transfer variable names to string.

function res = getVarName(varargin)
    LEN = length(varargin);
    assert(LEN >= 1,"Input variable number must >= 1.");
    res = sprintf('%s',inputname(1));
    if LEN >= 2
        for i= 2:LEN
            res = strcat(res,',',sprintf('%s',inputname(i)));
        end
    end
end