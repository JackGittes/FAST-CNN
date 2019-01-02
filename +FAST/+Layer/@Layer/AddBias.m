% Author: Zhao Mingxin
% Date:   2018/11/25
% Description: as below

function res = AddBias(~,im,bias,t,f)
    [im_h,im_w,im_d]=size(im);
%     assert(isfi(im)&&isfi(bias),"AddBias is Only used for fi object");
%     if strcmp(f.OverflowAction,'Saturate') && strcmp(t.Signedness,'Signed')
%     
%         [int_im,int_bias,~,FracLen,up_bound,low_bound] = FAST.kernel.FiToInt(im,bias,'int64');
%         tmp = reshape(repmat(int_bias,[im_h*im_w,1]),[im_h,im_w,im_d]);
%         
%         res = int_im + tmp;
%         res(res > up_bound) = up_bound;
%         res(res < low_bound) = low_bound;
%         
%         res = fi(double(res)/2^(FracLen),t,f);
%     else
%         tmp = reshape(repmat(bias,[im_h*im_w,1]),[im_h,im_w,im_d]);
%         res = im + tmp;
%     end
%     
    tmp = reshape(repmat(bias,[im_h*im_w,1]),[im_h,im_w,im_d]);
    res = im + tmp;
end