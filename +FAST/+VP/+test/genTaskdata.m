function genTaskdata(data,path,filename)
    if nargin<2
        path='./Test/';
        filename = 'taskdata.dat';
    end
    [h,~] = size(data);
    fileID = fopen([path,filename],'w');
    for i=1:h
        fprintf(fileID,[data(i,:),'\n']);
    end
    fclose(fileID);
end