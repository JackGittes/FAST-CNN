% Author: Zhao Mingxin
% Date: 2019/09/23
% Description: Fixed point simulation example on single core cpu.
%{
    Args:
        test_path: test dataset full path
        params_path: path to load CNN parameters.
    Returns:
        omitted.
    NOTE: MultiCore and GPU computation mode both are hard to debug when the
    result is not as you expect, so normally you'll need to write a single
    core version to run CNN non-parallel and set breakpoint to debug. By
    doing this, you can find which part of your network and image
    preprocessing code has problems.
%}

function [res,stat] = full_test_non_multicore(test_path, params_path)
    % Create a "nn" object and set computation mode to GPU.
    nn = FAST.ActiveSession('GPU');
    
    REPORT_INTERVAL = 50;
    INPUT_SIZE = [32, 32];
    if nargin < 4
        % Specify your test image path.
        test_path = '/home/zhaomingxin/Datasets/new_for_two/train';
        self_path = mfilename('fullpath');
        model = load([self_path(1:end-length(mfilename)),...
                filesep,'params_float.mat']);
    else
        model = load(params_path);
    end
    [TOTAL_NUM,im_list,lbs] = FAST.img.getImageListAndLabels(test_path);
    corrt = 0;
    totNum = 0;
    tic;
    
    for i = 1:TOTAL_NUM
        img = imread(im_list{i});
        [~,~,d] = size(img);
        if d~=3
           img = img(:,:,1:3);
        end
        input = imresize(img,INPUT_SIZE);
        % Call your CNN function here to apply forward once.
        [res,stat] = FAST.examples.baseline(nn, model, input);
        
        totNum = totNum +1;
        [~,idx] = max(squeeze(res));
        if idx==lbs(i)
           corrt=corrt+1;
        end
        if mod(i, REPORT_INTERVAL) == 0
           fprintf('Time: %6.2f, Total: %5d, Correct: %5d ,Acc-Top: %3.2f %%\n',toc,totNum,corrt,corrt/totNum*100.0);
        end
    end
end
