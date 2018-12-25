spmd
    tmp = labindex + [1:10];
    for i = tmp
        a = i;
        res = gop(@plus,a,1);
        disp(res);
    end
end
    
    