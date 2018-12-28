% Author: Zhao Mingxin
% Date: 2018/12/27

function res = readJSON(path)
    fprintf(2,'Loading parameters from JSON file.\n');
    res = jsondecode(fileread(path));
    fprintf(2,'Parameters Loaded.\n');
end