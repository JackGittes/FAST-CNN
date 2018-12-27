% Author: Zhao Mingxin
% Date: 2018/12/26
% Description: Divide dataset into several parts and return Start and End
% position of every part in the entire dataset. The total number of parts
% is given by Cores.

function [subStart,subEnd] = divideDataset(Cores,nStart,nEnd)
    assert(Cores>0,"Available Cores must be greater than 0.");
    assert(nStart>=1 && nStart<=nEnd,"Input Start position is Not correct, Start must be greater than 0 and no greater than End.");
    assert(Cores <= nEnd-nStart+1,"Cores number is greater than samples number, some cores will have 0 sample.");
    SplitFunc = @(Len,Cores) floor(Len/Cores)*ones(1,Cores)+[ones(1,mod(Len,Cores)),zeros(1,Cores-mod(Len,Cores))];
    
    interval_len = SplitFunc(nEnd-nStart+1,Cores);
    [subStart,subEnd] = deal(cell(1,Cores),cell(1,Cores));
    
    for i = 1:Cores
        if i==1
            subStart{i}= 1;
        else
            subStart{i} = subEnd{i-1}+1;
        end
        subEnd{i}= subStart{i}+interval_len(i)-1;
    end
end