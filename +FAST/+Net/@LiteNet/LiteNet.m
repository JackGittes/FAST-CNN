classdef LiteNet < handle
    properties(SetAccess = private)
        params;
        inputs;
        nn;
    end
    
    properties(Access = public)
        Numeric;
        Fimath;
    end
    
    methods(Static)
        function res = getJSONParams(path)
            fprintf(2,'Loading parameters from JSON file.\n');
            res = jsondecode(fileread(path));
            fprintf(2,'Parameters Loaded.\n');
        end
    end
    
    methods
        % Constructor: If JSON path provided, it will get params from JSON.
        % Otherwise, you can set params later.
        function obj = LiteNet(path)
            if nargin>0
                try
                    obj.params = obj.getJSONParams(path);
                catch
                    error('LiteNet Initialization Failed.');
                end
            end
        end
    end
    
    methods
        function getInputs(obj,input_im)
            obj.inputs = input_im;
        end
        
        function setParams(obj,json_params)
            obj.params = json_params;
        end
        
        function setNumeric(obj,Numerictype)
            obj.Numeric = Numerictype;
        end
        
        function setFimath(obj,Fimath)
            obj.Fimath = Fimath;
        end
        
        function getLayer(obj)
            obj.nn = FAST.Layer.Layer;
            obj.nn.Device.setMode('GPU');
            obj.nn.Device.getDeviceInfo();
        end
        res = Forward(obj);
    end
end