function [subStart,subEnd] = divideDataset(Cores,nStart,nEnd)
    SplitFunc = @(Len,Cores) floor(Len/Cores)*ones(1,Cores)+[ones(1,mod(Len,Cores)),zeros(1,Cores-mod(Len,Cores))];
    
    interval_len = SplitFunc(nEnd-nStart+1,Cores);
    [subStart,subEnd] = deal(cell(1,Cores),cell(1,Cores));

    for i = 1:Cores
        if i==1
            subStart{i}=1;
        else
            subStart{i} = subEnd{i-1}+1;
        end
        subEnd{i}= subStart{i}+interval_len(i)-1;
    end
end