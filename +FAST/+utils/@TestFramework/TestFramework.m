% Author: Zhao Mingxin
% Date:   2019/1/4
% Description: Test framework for large dataset. You should initialize 
% TestFramework properties and provide at least THE Entrance and THE exit
% of your CNN. 
% For example, [res,stat]=Net(model,input) means that you have a
% specific CNN named Net and the Net gets parameters from the argument model and gets 
% input from some data_generator. Then the Net returns inference result and
% some statistic information like numeric distribution of feature
% map/kernel etc.

classdef TestFramework < handle
    properties
        ImgList;
        LabelList;
        Dataset;
        LogID;
        Stat;
        Net;
        PrintInterval = 10;
        Config;
        Model;
        % Parameters used to add additional information such as input arguments
        % and so on.
        Additional = 'None';
    end
    
    properties(Access = private)
        hint;
        needLog;
    end
    
    methods
        function obj = TestFramework()
            obj.Config = FAST.utils.Config;
        end
    end
    
    methods
        [res,stat] = runOnDataset(obj);
        SetupCheck(obj);
    end
end