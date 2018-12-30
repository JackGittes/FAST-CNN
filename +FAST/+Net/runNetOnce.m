% Author: Zhao Mingxin
% Date: 2018/12/25
% Description: Forward Net once.

function [p1,p5,stat] = runNetOnce(net,input_img,label)
    net.getInputs(input_img);
    [pred,stat] = net.Forward_v5();
    [p1,p5]=FAST.op.checkTopPred(pred,label);
end