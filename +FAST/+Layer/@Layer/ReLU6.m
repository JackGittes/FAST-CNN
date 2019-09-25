% Author: Zhao Mingxin
% Date:   2018/12/20
% Description: ReLU6 activation function

function res = ReLU6(~,im)
    im(im<0)=0;
    im(im>6)=6;
    res = im;
end