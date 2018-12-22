% Author: Zhao Mingxin
% Date:   2018/11/26
% Description: ReLU activation function

function im = ReLU(~,im)
    im(im<0)=0;   
end