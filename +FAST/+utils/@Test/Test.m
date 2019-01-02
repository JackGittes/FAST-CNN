classdef Test < handle
    properties
        ImgList;
        LabelList;
        Dataset;
        LogID;
        Stat;
        Net;
        PrintInterval=10;
        Config;
        model;
    end
    
    properties(Access = private)
        hint;
        needLog;
    end
    
    methods
        function obj = Test()
            obj.Config = FAST.utils.Config;
        end
    end
    
    methods
        [res,stat] = runOnDataset(obj);
    end
end