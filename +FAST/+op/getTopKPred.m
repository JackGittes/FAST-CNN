function res = getTopKPred(pred,k)
    [~,idx] = sort(pred,'descend');
    res = idx(1:k);
end