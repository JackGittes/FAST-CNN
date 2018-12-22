function res = SingleImageCrop(img,type)
	if nargin == 0
		type = 'Central';
	end
    [h,w,~]=size(img);
    [~,idx] = sort([h,w],'descend');
    scale = 
    if h>w
        scale = floor(128*[h/w,1]);
        tiny_im = imresize(img,scale);
%         pos = randi(max(scale-128));
        pos = max(floor((scale-128)/2));
        if pos==0
            pos = 1;
        end
        res = tiny_im(pos:pos+127,:,:);
    elseif h<w
        scale = floor(128*[1,w/h]);
        tiny_im = imresize(img,scale);
%         pos = randi(max(scale-128));
        pos = max(floor((scale-128)/2));
        if pos==0
            pos = 1;
        end
        res = tiny_im(:,pos:pos+127,:);
    else
        res = imresize(img,[128,128]);
    end
end