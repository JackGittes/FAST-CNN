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

function [res,stat] = full_test_non_multicore_template(test_path, params_path)
    % Create a "nn" object and set computation mode to GPU.
    nn = FAST.ActiveSession('GPU');
    
    REPORT_INTERVAL = 50;
    INPUT_SIZE = [32, 32];
    if nargin < 4
        % Specify your test image path(full path, not relative path).
%         test_path = 'H:\Dataset\Ship_Data\Ship_Four_CLS\ShipMini\test';
        test_path = 'H:\Dataset\ImageNet\ILSVRC_2012\val';
        self_path = mfilename('fullpath');
        tmp = load([self_path(1:end-length(mfilename)),...
              filesep,'quantized.mat']);
		model = tmp.Net;
    else
        tmp = load(params_path);
		model = tmp.Net;
    end
	model = FAST.utils.ConvertFXP(model);
    
    [TOTAL_NUM,im_list,lbs] = FAST.img.getImageListAndLabels(test_path);
    corrt = 0;
    totNum = 0;
    tic;
    
    for i = 1:TOTAL_NUM
        try
            img = imread(im_list{i});
            [~,~,d] = size(img);
            if d~=3
               img = img(:,:,1:3);
            end
            input = FAST.img.CropToShape(img, [224, 224]);
        
%         input = imresize(img,INPUT_SIZE);
        % Call your CNN function here to apply forward once.
            [res,stat] = FAST.examples.template(nn, model, input);
            [~,idx] = max(squeeze(res));
        catch
            idx = 0;
        end
        disp([num2str(idx), '  ', num2str(lbs(i))])
        totNum = totNum +1;
        if idx==lbs(i)
           corrt=corrt+1;
        end
        if mod(i, REPORT_INTERVAL) == 0
           fprintf('Time: %6.2f, Total: %5d, Correct: %5d ,Acc-Top: %3.2f %%\n',toc,totNum,corrt,corrt/totNum*100.0);
        end
    end
end
