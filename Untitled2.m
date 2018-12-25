for i = 1:300
    try
        nargin('+FAST/+Layer/@Layer/AddBias.m');
    catch
        disp('error occur');
    end
end