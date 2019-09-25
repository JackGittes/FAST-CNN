% Author: Zhao Mingxin
% Date: 2019/9/23
% Description: Get image name list and labels from a given dataset
% directory.
%{
    Args: full path of test dataset and there should be class directories
    under test_path. For example:
        test_path/class_1_folder/
        test_path/class_2_folder/
        ...
        test_path/class_X_folder/
    Images should be in class_X_folder, the name of class_X_folder is as
    you want.

    Return: 
        total_num: total number of all images in dataset.
        imlist: image names of dataset with full path
        lbs: the labels of dataset named from 1 to category number.
%}

function [total_num, imlist, lbs] = getImageListAndLabels(test_path)
    tmp_im_counter = 1;
    
    test_cls = dir(test_path);
    cls_names = {test_cls.name};
    tmp_cls_counter = 1;
    % Get subfolders under test folder which should have sub-category that 
    % that contains input images.
    for i=1:length(cls_names)
        if isfolder([test_path, filesep, cls_names{i}]) && ...
                ~strcmp(cls_names{i}, '.') && ~strcmp(cls_names{i}, '..')
            sub_cls{tmp_cls_counter}=cls_names{i};
            tmp_cls_counter = tmp_cls_counter+1;
        end
    end
    
    sub_cls_lbs = cell(1, length(sub_cls));
    for i = 1:length(sub_cls)
        tmp_ = dir([test_path,filesep,sub_cls{i},filesep]);
        img_names = {tmp_.name};
        % Skip "." and ".." directories. The check method is quite simple and
        % sometimes can have problems on some OS because "." and ".."
        % directories are not always on the first and second place.
        tmp_im_names = img_names(3:end);
        
        % Create labels according to folders and assign category
        % number in increasing order from one(not zero).
        sub_cls_lbs{i} = i*ones(1, length(tmp_im_names));
        
        for idx = 1:length(tmp_im_names)
            imlist{tmp_im_counter} = [test_path,filesep,sub_cls{i},filesep,tmp_im_names{idx}];
            tmp_im_counter = tmp_im_counter+1;
        end
    end
    imlist = imlist';
    total_num = length(imlist);
    lbs = cell2mat(sub_cls_lbs);
end