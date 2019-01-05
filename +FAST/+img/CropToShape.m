% Author: Zhao Mingxin
% Date: 2018/12/24
% Description: Crop function used to crop any input image to specific
% shape.
%{
    Args: 
        Input image(whatever depth), Output shape
    Return:
        Central cropped image with output shape.
    Error: No error defined in this function.
    TODO:
        Rewrite a more clean version.
%}

function res = CropToShape(img,shape)
    [h,w,~]=size(img);
    im_shape = [h,w];
    [scale,idx] = max(shape./im_shape);
    
    tmp_shape = ceil(scale*im_shape);
    timg_ = imresize(img,tmp_shape);
    
    if idx == 1
        pos = floor((tmp_shape(2)-shape(2))/2);
        if pos==0
            pos = 1;
        end
        res = timg_(:,pos:pos+shape(2)-1,:);
    else
        pos = floor((tmp_shape(1)-shape(1))/2);
        if pos==0
            pos = 1;
        end
        res = timg_(pos:pos+shape(1)-1,:,:);
    end
    res = imresize(res,shape);
end