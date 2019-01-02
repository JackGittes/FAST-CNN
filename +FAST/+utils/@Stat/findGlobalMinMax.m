% Author: Zhao Mingxin
% Date:   2019/1/2
% Description:
function res = findGlobalMinMax(stat)
    NUM = length(stat);
    tmp_=cell(1,NUM);
    for i=1:NUM
        tmp_{i}=stat{i};
        tmp_{i}=reshape(cell2mat(tmp_{i}),2,[])';
    end
    tmpr_ = cell2mat(tmp_);
    min_tmp = tmpr_(:,1:2:2*NUM-1);
    max_tmp = tmpr_(:,2:2:2*NUM);
    res = [min(min_tmp,[],2),max(max_tmp,[],2)];
end