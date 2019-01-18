function res = reshapeFC(params)
    [~,~,~,d]=size(params);
    w = cell(1,d);
    for i = 1:d
        tmp = params(:,:,:,i);
        w{i} = reshape(permute(reshape(tmp,16,4,4),[3,2,1]),256,1)';
    end
    res = cell2mat(w);
end