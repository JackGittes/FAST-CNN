function res = SingleImageCrop(img,width,type)
	if nargin == 1
		type = 'Center';
        width = 128;
    elseif nargin == 2
        type = 'Center';
    end
    
    [h,w,~]=size(img); 
    if h>w
        scale = floor(width*[h/w,1]);
        tiny_im = imresize(img,scale);
%         pos = randi(max(scale-128));
        pos = max(floor((scale-width)/2));
        if pos==0
            pos = 1;
        end
        res = tiny_im(pos:pos+width-1,:,:);
    elseif h<w
        scale = floor(width*[1,w/h]);
        tiny_im = imresize(img,scale);
%         pos = randi(max(scale-128));
        pos = max(floor((scale-width)/2));
        if pos==0
            pos = 1;
        end
        res = tiny_im(:,pos:pos+width-1,:);
    else
        res = imresize(img,[width,width]);
    end
end