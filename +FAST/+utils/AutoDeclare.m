% Author: Zhao Mingxin
% Date: 2018/12/22
% Description: This script is used to auto generate class properties and
% write down to a class declaration file. The reason for doing this is
% seperating implementation details and corresponding interfaces so that we
% can extend its function without changing original codes. 
% All we need is writing a new function and putting it into a specific 
% folder, then the AutoDeclare will generate interface for this function.

function AutoDeclare(classname,path,parent,dest)
	resfile = [dest,classname,'.m'];
	fileID = fopen(resfile,'w');

	gen_info = GenInfo();
	author_info = AuthorInfo('Zhao Mingxin');
	class_title = ClassTitle(classname,parent);

	fprintf(fileID,gen_info);
	fprintf(fileID,author_info);
	fprintf(fileID,class_title);
    try
        props = getClassMethods(path,classname);
    catch
        fclose(fileID);
        error('Get Properties Error');
    end
	writeMethods(fileID,props);
	fprintf(fileID,'end\n');
	fclose(fileID);
end

function res = GenInfo(code_info)
    if nargin == 0
        code_info = ['MATLAB ',version('-release')];
    end
    current_time = string(datetime);
    code_stamp = [' By ',code_info];
    res = ['%% Auto Generated in ',char(current_time),code_stamp,'\n'];
end

function res = AuthorInfo(name)
    if nargin == 0
        name = 'No Name';
    end
    res = ['%% Author: ',name,'\n'];
end

function res = ClassTitle(classname,parent)
    if nargin == 1
        parent = 'handle';
    end
    res = ['classdef ',classname,' < ',parent,'\n'];
end

function res = getClassMethods(path,classname)
    names = dir(path);
    res = struct;
    k=1;
    for i = 3:length(names)
       filename = names(i).name;
       if checkName(filename,classname)
            res(k).name = getArgFunc(path,filename);
            k=k+1;
       end
    end
end

function writeMethods(fileID,props)
    fprintf(fileID,'\t methods\n');
    for i = 1:length(props)
        fprintf(fileID,['\t\t',props(i).name,';\n']);
    end
    fprintf(fileID,'\t end\n');
end

function argfunc = getArgFunc(path, filename)
    func = [path,filename];
    arginn = nargin(func);
    argoutn = nargout(func);
    arginlist = 'obj';
    argoutlist = '';
    for j = 1:arginn-1
       arginlist = strcat(arginlist,',Arg',num2str(j));
    end
    arginlist = ['(',arginlist,')'];
    for j = 1:argoutn
       argoutlist = strcat(argoutlist,',Out',num2str(j));
    end
    if argoutn>0
        argoutlist = ['[',argoutlist(2:end),']'];
    end
    argfunc = [argoutlist,'=',filename(1:end-2),arginlist];
end
function res = checkName(filename,classname)
    res = strcmp(filename(end-1:end),'.m') && ...
        ~strcmp(filename(1:end-2),classname);
end