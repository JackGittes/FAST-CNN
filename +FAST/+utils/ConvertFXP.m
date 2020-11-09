function res = ConvertFXP(Net)
    f = fimath('CastBeforeSum',0, 'OverflowMode', 'Saturate', 'RoundMode', 'round', ... 
    'ProductMode', 'SpecifyPrecision', 'SumMode', 'SpecifyPrecision', 'ProductWordLength', 32, ... 
     'ProductFractionLength', 0, 'SumWordLength', 32, 'SumFractionLength', 0); 
    t = numerictype('WordLength', 32, 'FractionLength', 0); 

    par_len = length(Net);
    for i=1:par_len
        if isfield(Net{i}, 'Weight')
            Net{i}.Weight = fi(Net{i}.Weight, t, f);
        end
        if isfield(Net{i}, 'Bias')
            Net{i}.Bias = fi(Net{i}.Bias, t, f);
        end
    end
    res = Net;
end