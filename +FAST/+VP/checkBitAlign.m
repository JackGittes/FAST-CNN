function res = checkBitAlign(x,bitlen)
    if nargin<2
        bitlen = 2;
    else
        assert(bitlen>0,"bitlen must be greater than 0.");
    end
    NUM = length(x);
    zpad = ceil(NUM/bitlen)*bitlen - NUM;
    res = [x,zeros(1,zpad)];
end