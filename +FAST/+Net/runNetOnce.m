% Author: Zhao Mingxin
% Date: 2018/12/25
% Description: Forward Net once.

function [p1,p5] = runNetOnce(net,input_img,label)
    net.getInputs(input_img);
    pred = net.Forward();
    [p1,p5]=FAST.op.checkTopPred(pred,label);
end