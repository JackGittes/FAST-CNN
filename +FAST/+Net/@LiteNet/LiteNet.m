% Author: Zhao Mingxin
% Date: 2018/12/22

classdef LiteNet < handle
    properties(SetAccess = private)
        model;
        inputs;
        nn;
        strategy_list;
    end
    
    properties(SetAccess = private)
        Numeric;
        Fimath;
    end
    
    methods
        function obj = LiteNet()
            
        end
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
        [res1,res2] = Forward(obj);
        res = Forward_v2(obj);
        [res1,res2] = Forward_v3(obj);
        [res1,res2] = Forward_v4(obj);
    end
end