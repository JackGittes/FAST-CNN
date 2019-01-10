function [res,byte_mat] = writeMemPipeline(ByteStr)
    ByteN = length(ByteStr);
    zpad = ceil(ByteN/32)*32-ByteN;
    
    dataStr = [ByteStr,zeros(1,zpad)];
    data_uint8 = fliplr(reshape(dataStr,32,[])');
    
    byte_mat = fi(data_uint8,0,8,0);
    bin_mat = byte_mat.bin;
    bin_mat(bin_mat==' ')='';
    res = reshape(bin_mat,[],256);
end