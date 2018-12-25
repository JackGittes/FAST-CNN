% Author: Zhao Mingxin
% Date:   2018/12/09
% Description: as below

% This function used to dequantize tflite fixed-point params.
function res = dequantParams(par,par_type,quant)
    switch par_type
        case 'Weight'
            zp = quant.zero_point;
            scale = quant.scale;
            res = scale*(double(par)-zp);
        case 'Bias'
            zp = quant.zero_point;
            scale = quant.scale;
            res = scale*(double(par)-zp);
        otherwise
            error('Unknown Params Type');
    end
end