% Author: Zhao Mingxin
% Date: 2018/12/23
% Description: Parent class for Layer class.
% More details info, pls refer to FAST DOC

classdef BaseLayer < handle
	properties(SetAccess = private,Dependent)
		Mode;
    end
	properties(SetAccess = private)
		Device;
        ResultList;
        DebugLevel;
    end
	
	methods
		function obj = BaseLayer()
            obj.Device = FAST.utils.Device;
            obj.DebugLevel = 1;
            obj.ResultList={};
            warning('Computation Environment Initialized.');
        end
        function Mode = get.Mode(obj)
            Mode = obj.Device.Mode;
        end
        
        function set.DebugLevel(obj, level)
            switch level
                case 1
                    disp('Set debug level 1, no result will be collected.');
                case 2
                    disp('Set debug level 2, intermediate results will be recorded.');
                otherwise
                    error('Unknown debug level.');
            end
            obj.DebugLevel = level;
        end
        
        function appendResultList()
        end
        function delete(~)
%             disp('Residual Data Cleared.');
        end
	end
end