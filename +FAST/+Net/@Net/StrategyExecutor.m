% Author: Zhao Mingxin
% Date:   2018/12/31

function res = StrategyExecutor(obj,stgy,input)
    [OpName,VarList] = deal(stgy.OpName,stgy.VarList);
    op_ = str2func(OpName);
    res = op_(input,obj,VarList{:});
end