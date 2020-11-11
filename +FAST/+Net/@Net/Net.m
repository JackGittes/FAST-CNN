% Author: Zhao Mingxin
% Date: 2018/12/23
% Description: Net class.

classdef Net < handle
    properties(SetAccess = private)
        model;
        inputs;
        nn;
    end
    
    properties(SetAccess = private)
        Numeric;
        Fimath;
    end
    
    methods
        function getInputs(obj,input_im)
            obj.inputs = input_im;
        end
        
        function setParams(obj,json_params)
            obj.params = json_params;
        end
        
        function getModel(obj,model)
            obj.model = model;
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
    end
end