% Author: Zhao Mingxin
% Date: 2018/12/25
% Description: Check Top-1 and Top-5 Correctness.

function [p1,p5] = checkTopPred(pred,lb)
    top5 = FAST.op.getTopKPred(pred,5);
    [~,top1] = max(pred);
    p1 = double(top1==lb);
    p5 = double(ismember(lb,top5));
end