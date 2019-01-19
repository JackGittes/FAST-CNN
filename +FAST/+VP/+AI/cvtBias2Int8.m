function [res,new_model] = cvtBias2Int8(model)
    tmp_ = struct;
    tmp_.factor = [];
    tmp_.bias_a = [];
    tmp_.re_bias = [];
    new_model = model;
    
    res = repmat(tmp_,length(model),1);
    for i=1:length(model)
        if ~isempty(model(i).bias)
            res(i).factor = FAST.VP.AI.BiasConverter(model(i).bias.data);
            res(i).bias_a = int8(round(model(i).bias.data/res(i).factor));
            res(i).re_bias = double(res(i).bias_a)*res(i).factor;
            new_model(i).bias = fi(res(i).re_bias,1,16,0);
        else
            res(i).factor = [];
            res(i).bias_a = [];
            res(i).re_bias = [];
        end
    end     
end