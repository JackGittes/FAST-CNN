% Author: Zhao Mingxin
% Date:   2018/11/25
% Description: as below

function res = AddBias(~,im,bias,t,f)
    [im_h,im_w,im_d]=size(im);
    FracLen = t.FractionLength;
    WordLen = t.WordLength;
    
    if strcmp(f.OverflowAction,'Saturate') && strcmp(t.Signedness,'Signed')
        up_bound = 2^(WordLen-1)-1;
        low_bound = -2^(WordLen-1);
        
        int_bias = int32(bias.data*2^FracLen);
        int_im = int32(im.data*2^FracLen);
        tmp = reshape(repmat(int_bias,[im_h*im_w,1]),[im_h,im_w,im_d]);
        
        res = int_im + tmp;
        res(res > up_bound) = up_bound;
        res(res < low_bound) = low_bound;
        
        res = fi(res/2^(2*FracLen),t,f);
    else
        tmp = reshape(repmat(bias,[im_h*im_w,1]),[im_h,im_w,im_d]);
        res = im + tmp;
    end
end