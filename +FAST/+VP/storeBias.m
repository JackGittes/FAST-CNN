function res = storeBias(varargin)
    res_cell = cell(1,length(varargin));
    for i=1:length(varargin)
        b = fi(varargin{i},1,16,0);
        if CheckShape(b)>0
            res_cell{i} = HexTransform(b);
        else
            error("Bias shape must be 1 dimension with height equal to 1.");
        end
    end
    res = cell2mat(res_cell);
end

function res = CheckShape(x)
    sp = size(x);
    if sp(1) == 1 && length(sp) == 2
       res = 1; 
    else
       res = -1;
    end
end