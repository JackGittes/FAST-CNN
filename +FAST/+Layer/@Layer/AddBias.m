% Author: Zhao Mingxin
% Date:   2018/11/25
% Description: as below

function res = AddBias(~,im,bias,~,~)
    [im_h,im_w,im_d]=size(im); 
    [c, ~] = size(bias);
    if c > 1
        tmp_bias = bias';
    else
        tmp_bias = bias;
    end
    % tmp = reshape(repmat(tmp_bias,[im_h*im_w,1]),[im_h,im_w,im_d]);
    tmp = reshape(repmat(tmp_bias.data,[im_h*im_w,1]),[im_h,im_w,im_d]);
    res = fi(im.data+tmp, im.numerictype,im.fimath);
%     res = im + tmp;
end