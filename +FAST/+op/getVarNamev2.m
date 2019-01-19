function res = getVarNamev2(varargin)
    if length(varargin)>1
        res = [sprintf('%s',inputname(1)),FAST.op.getVarNamev2(varargin{2:end})];
    else
        res = sprintf('%s',inputname(1));
    end
end