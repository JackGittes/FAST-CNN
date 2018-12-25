function img = ILSVRC_loader(path,idx,lbfile)
    val = lbfile.val_lbs;
    imname = char(strcat(path,val.FileName(idx)));
    try
        img = imread(imname);
        [~,~,d]=size(img);
        if d~=3
            error('Format Failure');
        end
    catch
        error('Read Failure');
    end
end