% Author: Zhao Mingxin
% Date:   2018/12/31

function res = StrategyExecutor(~,stgy,input)
    [OpName,VarList] = deal(stgy.OpName,stgy.VarList);
    op_ = str2func(OpName);
    res = op_(input,VarList{:});
end