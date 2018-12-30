% Author: Zhao Mingxin
% Date: 2018/12/30

classdef FastFi < handle
    properties
        numerictype;
        fimath;
        data;
    end
    
    properties(SetAccess = private,Dependent)
        int;
    end
    
    methods
        function obj = FastFi(d,t,f)
            wordlen =32;
            fraclen =0;
            default_f = fimath('CastBeforeSum',0, 'OverflowMode', 'Saturate', 'RoundMode', 'floor', ... 
            'ProductMode', 'SpecifyPrecision', 'SumMode', 'SpecifyPrecision', 'ProductWordLength',wordlen, ...
            'ProductFractionLength',fraclen, 'SumWordLength', wordlen, 'SumFractionLength', fraclen);
            default_t = numerictype('WordLength', wordlen, 'FractionLength',fraclen);
            
            if nargin == 0
                obj.fimath = default_f;
                obj.numerictype = default_t;
            elseif nargin == 1
                obj.data = d;
                obj.fimath = default_f;
                obj.numerictype = default_t;
            elseif nargin == 2
                obj.data = d;
                obj.numerictype = t;
                obj.fimath = default_f;
            elseif nargin == 3
                obj.data = d;
                obj.numerictype = t;
                obj.fimath = f;
            end
        end
        
        function set.numerictype(obj,x)
            assert(isnumerictype(x),"Must be numerictype.");
            obj.numerictype = x;
        end
        
        function set.fimath(obj,x)
            assert(isfimath(x),"Must be fimath.");
            obj.fimath = x;
        end
        
        function set.data(obj,data)
            assert(isnumeric(data),"Must be numeric.");
            obj.data = data;
        end
        
        function FormatConverter(obj)
            [d,t,f] = deal(obj.data,obj.numerictype,obj.fimath);
            tmp_ = fi(d,t,f);
            obj.data = tmp_.data;
        end
        
        function int = get.int(obj)
           fl = obj.numerictype.FractionLength;
           int = obj.data*2^fl;
        end
    end
end