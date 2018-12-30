% Author: Zhao Mingxin
% Date: 2018/12/23
% Description: Parent class for Layer class.
% More details info, pls refer to FAST DOC

classdef BaseLayer < handle
	properties(SetAccess = private,Dependent)
		Mode;
    end
	properties
		Device;
	end
	
	methods
		function obj = BaseLayer()
            obj.Device = FAST.utils.Device;
            fprintf(2,'Computation Environment Initialized.\n');
        end
        function Mode = get.Mode(obj)
            Mode = obj.Device.Mode;
        end
        
        function delete(~)
%             disp('Residual Data Cleared.');
        end
	end
end