% Author: Zhao Mingxin
% Date: 2018/12/22
% Description: Device class.
% To control and manage computation device as well as provide current device info. 
% The function will continue to extend.

classdef Device < handle
    properties(SetAccess=private)
        Mode;
        NumCores;
    end
    methods
	% Constructor: Default mode is SingleCore.
        function obj = Device()
            obj.Mode = 'SingleCore';
            obj.NumCores = 1;
        end
	% A pubilc interface to set computation mode.
	% For now, GPU\SingleCore\MultiCore modes are supported.
        function setMode(obj,mode)
            switch mode
                case 'GPU'
                    setGPU(obj);
                case 'MultiCore'
                    setMultiCore(obj);
                case 'SingleCore'
                    setSingleCore(obj);
                otherwise
                    warning('Unknown Mode.');
            end
        end
    end
	% Implementation for setting different device mode.
    methods(Access = private)
        setGPU(obj);
        setMultiCore(obj);
        setSingleCore(obj);
    end
end