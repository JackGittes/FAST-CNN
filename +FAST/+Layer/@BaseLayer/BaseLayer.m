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
			obj.Device.setMode('GPU');
            fprintf(2,'Computation Environment Initialized.\n');
        end
        function Mode = get.Mode(obj)
            Mode = obj.Device.Mode;
        end
	end
end