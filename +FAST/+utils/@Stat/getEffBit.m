function res = getEffBit(num)
    num(num==0)=1;
    res = ceil(log2(num+1));
end