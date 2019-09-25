% Author: Zhao Mingxin
% Date:   2018/11/26

function res = getTopKPred(pred,k)
    [~,idx] = sort(pred,'descend');
    res = idx(1:k);
end