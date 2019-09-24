% Author: Zhao Mingxin
% Date: 2019/09/24
% Description: Function for compiling cuda .cu file to .ptx file.

function compileCUDA()
    file_name=mfilename('fullpath');
    cuda_root=[file_name(1:end-length(mfilename)-8),filesep,'+cuda'];
    config_root=[file_name(1:end-length(mfilename)-8),filesep,'config'];
    
    fid=fopen([config_root,filesep,'cuda_compile.ini'],'r');
    config_file=textscan(fid,'%s','delimiter','\n');
    cuda_file=config_file{1};
    splitter=repmat('=',[1,50]);
    try
        disp(splitter);os_status = system('nvcc -V');disp(splitter);
    catch
        os_status = 1;
    end
    if os_status > 0
        error('No NVCC compiler found, please check cuda support and env variable.');
    end
    for i=1:length(cuda_file)
        cuda_file_fullpath = [cuda_root,filesep,cuda_file{i}];
        cuda_file_dir=dir(cuda_file_fullpath);
        cuda_file_folder=cuda_file_dir.folder;
        system(['nvcc -ptx ',cuda_file_fullpath,' -o ',...
            cuda_file_folder,filesep,cuda_file_dir.name(1:end-2),'ptx']);
    end
    disp('Compile CUDA file completed.')
end

