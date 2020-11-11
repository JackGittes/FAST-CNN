% Author: Zhao Mingxin
% Date: 2019/09/23
% Description: Fixed point simulation example on GPU with multicore parallel 
% acceleration.
%{
    Args:
        test_path: test dataset full path
        params_path: path to load CNN parameters.
    Returns:
        maxmin_res: statistic result of intermediate feature map
%}

function full_test_gpu_template(test_path, params_path)
    % Create a "nn" object and set computation mode to GPU.
    nn = FAST.ActiveSession('GPU');
    % Set accuracy report interval between every two results printed. If
    % you turn on 15 cores and REPORT_INTERVAL is 10, that means the test
    % process will print accuracy every 15*10=150 images.
    REPORT_INTERVAL = 10;
    
    if nargin < 4
        % Specify your test image path(full path, not relative path).
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

    % Specify core number to run test procedure, NOTE: it's better to set Cores
    % to be equal to your hardware core number.
    Cores = 10;
    Cores = nn.Device.setCores(Cores);

    % Some necessary dataset info should be given here to load the dataset.
    
    % Create image name list from given dataset folder for reading images
    [TOTAL_NUM,im_list,lbs] = FAST.img.getImageListAndLabels(test_path);

    startpoint = 1;
    endpoint = TOTAL_NUM;

    % Give your total picture number here to allocate workload on different CPU
    % cores, for example, if total pic number is 2000 and your CPU have 4
    % cores, then it's better to test 500 pics per core. 
    [subStart,subEnd] = FAST.op.divideDataset(Cores,startpoint,endpoint);
    spmd
        tic;
        % Set correct number and total number of tested images to 0 then start
        % the test process.
        corrt = 0;
        totNum = 0;
        counter = 0;
        acc1 = 0;
        acc5 = 0;
        for i=subStart{labindex}:subEnd{labindex}
            try
                img = imread(im_list{i});
                [~,~,d] = size(img);
                % In case of RGBA images, we merely take RGB channels and leave
                % out Alpha channel.
                if d~=3
                    img = img(:,:,1:3);
                end
                input = FAST.img.CropToShape(img, [224, 224]);
                % Call your CNN function here to apply forward once.
                [res,~] = FAST.examples.template(nn, model, input);

                totNum = totNum +1;
                
                [p1,p5]=FAST.op.checkTopPred(res,lbs(i));
                acc1 = acc1 + p1;
                acc5 = acc5 + p5;
            catch
%                 idx = 0;
            end

            counter=counter+1;
            if counter~=0 && mod(counter,REPORT_INTERVAL) == 0
                % Use labBarrier to synchronize operations on all cores because
                % demaged images and other unexpected errors may cause some
                % CPU core won't complete their workload when we call the
                % global operation(gop function), which may lead to test process
                % crash.
                labBarrier;
                r = gop(@plus,[totNum,acc1,acc5],1);
                time_lab1 = toc;
                if labindex == 1
                    fprintf('Time: %6.2f, Total: %5d, Correct: %5d ,Acc-1: %3.2f%% Acc-5: %3.2f%%\n',...
                        time_lab1,r(1),r(2),r(2)/r(1)*100.0,r(3)/r(1)*100.0);
                end
            end
        end
        % Global operation(gop), compute image numbers that have been tested on
        % all cores as well as accumulate correct prediction numbers to get the test
        % accuracy.
        r = gop(@plus,[totNum,corrt],1);
        time_lab1 = toc;
        if labindex == 1
            fprintf('Time: %6.2f, Total: %5d, Correct: %5d ,Acc-Top: %3.2f %%\n',time_lab1,r(1),r(2),r(2)/r(1)*100.0);
        end
    end
end
