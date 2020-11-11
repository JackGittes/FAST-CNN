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
    end
	
	methods
		function obj = BaseLayer()
            obj.Device = FAST.utils.Device;
            warning('Computation Environment Initialized.');
        end
        
        function Mode = get.Mode(obj)
            Mode = obj.Device.Mode;
        end
        
        function delete(~)
%             disp('Residual Data Cleared.');
        end
	end
end