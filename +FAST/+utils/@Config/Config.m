% Author: Zhao Mingxin
% Date:   2019/1/2
% Last change: 2019/1/2

classdef Config
    properties
        INPUT_SIZE = [128,128];
        Preprocess = 'imresize';
        Start = 1;
        End = 2000;
        ImgPath = 'H:/PythonProject/BoatNet/new/new/test/';
        CLASS = 3;
        Cores = 15;
    end
end