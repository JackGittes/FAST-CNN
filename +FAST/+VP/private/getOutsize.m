% Author: Zhao Mingxin
% Date:   2019/1/8

function res = getOutsize(type,net_size,ker_shape,stride,padding)
    channel_size = net_size(1:2);
    if strcmp(type,'Conv2d')
        out_d = ker_shape(4);
        window_shape = ker_shape(1:2);
    else
        out_d = net_size(3);
        window_shape = ker_shape;
    end
    switch padding
        case 'SAME'
            out_size = ceil(channel_size./stride);
        case 'VALID'
            out_size = ceil((channel_size - window_shape +1)./stride);
        otherwise
            error("Unknown Padding Type.");
    end
    res = [out_size,out_d];
end