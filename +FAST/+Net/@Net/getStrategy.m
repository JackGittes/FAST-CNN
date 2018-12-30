function getStrategy(obj,config)
    if isempty(config)
        tmp_ = struct;
        tmp_.net = [];
        tmp_.weight = [];
        tmp_.bias = [];
        tmp_.Conv = [];
        tmp_.Output = [];
        tmp_.prePooling = [];
        tmp_.postPooling = [];
        obj.strategy_list = repmat(tmp_,[length(obj.model),1]);
    else
        obj.strategy_list = config;
    end
end