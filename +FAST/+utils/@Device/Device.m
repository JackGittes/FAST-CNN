% Author: Zhao Mingxin
% Date: 2018/12/22
% Description: Device class.
classdef Device < handle
    properties(SetAccess=private)
        Mode;
        NumCores;
    end
    methods
        function obj = Device()
            obj.Mode = 'SingleCore';
            obj.NumCores = 1;
        end
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
    methods(Access = private)
        function setGPU(obj)
            try
                gpuDevice();
                obj.Mode = 'GPU';
            catch
                obj.Mode = 'SingleCore';
                warning('Fail to get GPU device.');
            end
        end
        function setMultiCore(obj)
            try
                p = parcluster('local');
                obj.NumCores = p.NumWorkers;
                obj.Mode = 'MultiCore';
            catch
                warning('Fail to turn on MultiCore mode.');
                obj.NumCores = 1;
                obj.Mode = 'SingleCore';
            end
        end
        function setSingleCore(obj)
            obj.Mode = 'SingleCore';
            obj.NumCores = 1;
        end
    end
end