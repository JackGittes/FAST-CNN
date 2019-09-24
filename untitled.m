nn = FAST.ActiveSession('GPU');   
% Set accuracy report interval between every two results printed. If
% you turn on 15 cores and REPORT_INTERVAL is 10, that means the test
% process will print accuracy every 15*10=150 images.
REPORT_INTERVAL = 10;


% Specify your test image path(full path, not relative path).
test_path = '/media/zhaomingxin/Document/Dataset/Ship_Data/ship_two/ship_for_two/test';
self_path = mfilename('fullpath');
model = load('/media/zhaomingxin/winF/Github/fxp_sim/FAST-CNN/+FAST/+examples/params_float.mat');
wordlen = 32;
fraclen = 16;
f = fimath('CastBeforeSum',0, 'OverflowMode', 'Saturate', 'RoundMode', 'floor', ... 
'ProductMode', 'SpecifyPrecision', 'SumMode', 'SpecifyPrecision', 'ProductWordLength',wordlen, ...
'ProductFractionLength',fraclen, 'SumWordLength', wordlen, 'SumFractionLength', fraclen);
t = numerictype('WordLength', wordlen, 'FractionLength',fraclen); 


% Specify core number to run test procedure, NOTE: it's better to set Cores
% to be equal to your hardware core number.
Cores = 5;
Cores = nn.Device.setCores(Cores);

% Some necessary dataset info should be given here to load the dataset.
INPUT_SIZE = [32,32];

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
    for i=subStart{labindex}:subEnd{labindex}
        disp(i);
        img = imread(im_list{i});
        [~,~,d] = size(img);
        % In case of RGBA images, we merely take RGB channels and leave
        % out Alpha channel.
        if d~=3
            img = img(:,:,1:3);
        end
        input = imresize(img,INPUT_SIZE);
        % Call your CNN function here to apply forward once.
        [res,stat] = FAST.examples.baseline(nn, model, input, t, f);

        totNum = totNum +1;
        [~,idx] = max(squeeze(res));
        if idx==lbs(i)
            corrt=corrt+1;
        end

        tmp_name = im_list{i};
        disp([tmp_name(73:end-4),' lb: ',num2str(lbs(i)),' pred is:', num2str(idx)]);
        disp(squeeze(res.data));
        pause(0.1);

        % Calculate min/max info on different cores.
%         if i == subStart{labindex}
%             maxmin_old = findMaxMin(stat);
%         else
%             maxmin_old = simpleMaxMin(maxmin_old, findMaxMin(stat));
%         end

        counter=counter+1;
        if counter~=0 && mod(counter,REPORT_INTERVAL) == 0
            % Use labBarrier to synchronize operations on all cores because
            % demaged images and other unexpected errors may cause some
            % CPU core won't complete their workload when we call the
            % global operation(gop function), which may lead to test process
            % crash.
            labBarrier;
            r = gop(@plus,[totNum,corrt],1);
            time_lab1 = toc;
            if labindex == 1
                fprintf('Time: %6.2f, Total: %5d, Correct: %5d ,Acc-Top: %3.2f \n',time_lab1,r(1),r(2),r(2)/r(1)*100.0);
            end
        end
    end
    % Global operation(gop), compute image numbers that have been tested on
    % all cores as well as accumulate correct prediction numbers to get the test
    % accuracy.
    r = gop(@plus,[totNum,corrt],1);
    time_lab1 = toc;
    if labindex == 1
        fprintf('Time: %6.2f, Total: %5d, Correct: %5d ,Acc-Top: %3.2f \n',time_lab1,r(1),r(2),r(2)/r(1)*100.0);
    end
end

function res = findMaxMin(stat)
    NUM = length(stat);
    res = cell(1,NUM);
    for i = 1:NUM
        data = stat{i};
        res{i} = [min(data(:)),max(data(:))];
    end
end

function res = simpleMaxMin(x_old, x_new)
    NUM = length(x_old);
    res = cell(1,NUM);
    for i =1:NUM
        res{i}(1) = min(x_old{i}(1),x_new{i}(1));
        res{i}(2) = max(x_old{i}(2),x_new{i}(2));
    end
end