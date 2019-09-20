function subdir = compile_cuda()
    try
        os_status = system('nvcc -V');
    catch
        os_status = 1;
    end
    if os_status > 0
        error('No NVCC compiler found, please check cuda support and env variable.');
    end
    self_path = mfilename('fullpath');
    cuda_path = [self_path(1:end-19), '+cuda'];
    subdir = {dir(cuda_path)};
    folder_name = {subdir{1}.name};
    
    cuda_root = subdir{1}.folder;
    for i = 1:length(folder_name)
        sub_path = [cuda_root, filesep, folder_name{i}];
        if isfolder(sub_path) && ~strcmp(folder_name{i}, '.') && ...
                ~strcmp(folder_name{i}, '..')
           
           
        end
    end
    function cu_files = get_cu_file(root_path)
        root_files = {dir(root_path)};
        file_names = {root_files{1}.name};
        for idx = 1:length(file_names)
           sub_file_name = [root_path, filesep, file_names{idx}];
           if strcmp(sub_file_name(end-3:end), '.cu') && isfile(sub_file_name)
               system('nvcc -cuda x.cu -keep');
               cu_file{idx}.file_name = sub_file_name;
               cu_file{idx}.file_name = 
           end
        end
    end
end

