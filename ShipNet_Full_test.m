nn = FAST.ActiveSession('GPU');

test_path = '/media/zhaomingxin/winF/PythonProject/BoatNet/train/';
catg = {'boat','sea'};
% model = load('./+ning/');

Cores = 15;
Cores = nn.Device.setCores(Cores);

CLASS = 2;
MAX_STEP = 1000;
MAX_IM_NUM = 6284;
INPUT_SIZE = [32,32];
EMA_ALPHA = 0.01;
TOTAL_NUM = 12067+28496;

names = cell(1,CLASS);
for i = 1:CLASS
    tmp_ = dir([test_path,catg{i},'/']);
    img_names = {tmp_.name};
    names{i} = img_names(3:end);
end

imlist = cell(CLASS*MAX_IM_NUM,1);
counter = [0,0,0];
for i = 0:CLASS*MAX_IM_NUM-1
    tmp_ = mod(i,CLASS)+1;
    counter(tmp_) = counter(tmp_)+1;
    imlist{i+1} = [catg{tmp_},'/',names{tmp_}{counter(tmp_)}];
end


lbs = [ones(1,12067),2*ones(1,28496)];

startpoint = 1;
endpoint = TOTAL_NUM;
[subStart,subEnd] = FAST.op.divideDataset(Cores,startpoint,endpoint);
counter = 0;
spmd
    tic
    corrt = 0;
    totNum = 0;
    for i=subStart{labindex}:subEnd{labindex}
        img = imread([test_path,imlist{i}]);
        [~,~,d] = size(img);
        if d~=3
            img = img(:,:,1:3);
        end
        input = imresize(img,INPUT_SIZE);
        [res,stat] = ning.ning_ShipNet_baseline(nn,net,input);
        
        totNum = totNum +1;
        [~,idx] = max(res);
        if idx==lbs(i)
            corrt = corrt +1;
        end
        
        if i==subStart{labindex}
            maxmin_old = findMaxMin(stat);
        else
            maxmin_new = simpleMaxMin(maxmin_old,findMaxMin(stat));
        end
        
        counter = counter +1;
        if counter~=0 && mod(counter,10)==0
            labBarrier;
            r = gop(@plus,[totNum,corrt],1);
            time_lab1 = toc;
            if labindex == 1
                fprintf('Time: %6d, Total: %5d, Correct: %5d ,Acc-Top: %3.2f %%\n',time_lab1,r(1),r(2),r(2)/r(1)*100.0);
            end
        end
    end
    r = gop(@plus,[totNum,corrt],1);
    time_lab1 = toc;
    if labindex == 1
        fprintf('Time: %6d, Total: %5d, Correct: %5d ,Acc-Top: %3.2f %%\n',time_lab1,r(1),r(2),r(2)/r(1)*100.0);
    end
end


function Cores = setCores(Cores)
    p = gcp('nocreate');
    if isempty(p)
        tmp = parcluster;
        tmp.NumWorkers = Cores;
        parpool('local',Cores);
    else
        Cores = p.NumWorkers;
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

function res = EMA(x_old,x_new,alpha)
    NUM = length(x_old);
    res = cell(1,NUM);
    for i =1:NUM
        res{i} = x_old{i}*alpha + x_new{i}*(1-alpha);
    end
end

function res = simpleMaxMin(x_old,x_new)
    NUM = length(x_old);
    res = cell(1,NUM);
    for i =1:NUM
        res{i}(1) = min(x_old{i}(1),x_new{i}(1));
        res{i}(2) = max(x_old{i}(2),x_new{i}(2));
    end
end