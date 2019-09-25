function [res,alpha] = cvtFP2FXP(params)
    [ub,lb] = deal(max(params(:)),min(params(:)));
    [val,idx] = max(abs([ub,lb]));
    if idx == 1 && ub>0
        alpha = val/127;
    elseif idx == 2 && lb < 0
        alpha = val/128;
    end
    [res.mul,res.shift] = FAST.lite.getMulShift(alpha,1,1,8);
    tmp_ = round(params*1/alpha);
    tmp_(tmp_>127)=127;
    tmp_(tmp_<-128)=-128;
    res.params = tmp_;
    alpha = 1/alpha;
end