% Author: Zhao Mingxin
% Date:   2020/11/03
% Description: ZeroPad2d method.
%{ 
    NOTE: You should alway be extremely careful when your network
    has padding operations. Particularly, if your network is handling
    small feature maps, differents padding modes would lead to 
    significantly different results (e.g. completely wrong classifications).
    
    Therefore, a flexible padding method is introduced here to match the
    implementations in PyTorch.

    padding = [left, right, top, bottom]
%}

function res = ZeroPad2d(~, im, padding)
    t = im.numerictype;
    f = im.fimath;
    [h, w, d] = size(im);
    if length(padding) == 4
        w_pad = padding(1) + padding(2) + w;
        h_pad = padding(3) + padding(4) + h;
    elseif length(padding) == 2
        w_pad = padding(1) * 2 + w;
        h_pad = padding(2) * 2 + h;
        padding = [padding(1), padding(1), padding(2), padding(2)];
    end
    
    res = fi(zeros([h_pad, w_pad, d]), t, f);
    res(1+padding(1):end-padding(2),1+padding(3):end-padding(4), :) = im;
end