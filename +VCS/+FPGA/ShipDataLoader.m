function res = ShipDataLoader(bin_path,filename)
    if nargin == 0
        bin_path = './Test/';
        filename = 'ShipImgBin.bin';
    end
    bin_file = [bin_path,filename];
    fileID = fopen(bin_file,'w');
    
    test_path = 'H:/PythonProject/BoatNet/new/new/test/';
    catg = {'boat','land','sea'};
    imlist = getImgList(test_path,catg);
    
    INPUT_SIZE = [128,128];
    NUM = 8000;
    img_Byte = cell(1,NUM);
    for i=1:NUM
        img = imread([test_path,imlist{i}]);
        [~,~,d] = size(img);
        if d~=3
            img = img(:,:,1:3);
        end
        tmp_ = imresize(img,INPUT_SIZE);
        tmp_ = floor(double(tmp_)/2);
        img_c2r = permute(tmp_,[2,1,3]);
        img_UINT8 = uint8(img_c2r(:)');
        
        img_Byte{i}=img_UINT8;
    end
    img_Byte_Vec_UINT8 = cell2mat(img_Byte);
    fwrite(fileID,img_Byte_Vec_UINT8);
    fclose(fileID);
    res = img_Byte_Vec_UINT8;
end

function imlist = getImgList(test_path,catg)
    MAX_IM_NUM = 6284;
    CLASS = 3;
    names = cell(1,CLASS);
    for i = 1:CLASS
        tmp_ = dir([test_path,catg{i},'/']);
        img_names = {tmp_.name};
        names{i} = img_names(3:end);
    end

    imlist = cell(CLASS*MAX_IM_NUM,1);
    counter = [0,0,0];
    for i = 0:CLASS*MAX_IM_NUM-1
        tmp_ = mod(i,CLASS)+1;
        counter(tmp_) = counter(tmp_)+1;
        imlist{i+1} = [catg{tmp_},'/',names{tmp_}{counter(tmp_)}];
    end
end