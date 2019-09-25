% Author: Zhao Mingxin
% Date:   2018/11/26
% Description: Calculate im2col element position of original input map

function res = GetElemPos(im_d,channel_size,out_size,window_shape,stride)
    pool_len = channel_size-window_shape+1;
    
    pos_one_col = repmat([1:stride(1):pool_len(1)],[out_size(2),1]);
    gap_every_col = repmat(stride(2)*pool_len(1)*[0:out_size(2)-1]',[1,out_size(1)]);
    pos = pos_one_col+gap_every_col;
      
    tmp = im2col(reshape([1:prod(channel_size)],channel_size),window_shape,'sliding');
    
    tmp = tmp(:,pos(:));

    [t1,t2] = size(tmp);
    tmp_elem = repelem((0:im_d-1)*prod(channel_size),t1,t2)+repmat(tmp,1,im_d);
    res = reshape(tmp_elem,[t1,t2,im_d]);
end