nn = FAST.ActiveSession('SingleCore');
nn.Device.setMode('MultiCore');

test_path = 'H:/PythonProject/BoatNet/new/new/test/';
catg = {'boat','land','sea'};
model = load('./Test/shipnet.mat');

CLASS = 3;
MAX_STEP = 1;
MAX_IM_NUM = 6284;
INPUT_SIZE = [128,128];
counter = [0,0,0];


names = cell(1,CLASS);
for i = 1:CLASS
    tmp_ = dir([test_path,catg{i},'/']);
    img_names = {tmp_.name};
    names{i} = img_names(3:end);
end

corrt = 0;
for i = 1:MAX_STEP
    rand_cat = randi([1,3]);
    counter(rand_cat) = counter(rand_cat)+1;
    if counter(rand_cat)<= MAX_IM_NUM
        im_name = names{rand_cat}{counter(rand_cat)};
        im_path = [test_path,catg{rand_cat},'/',im_name];
        img = imread(im_path);
        
        [~,~,d] = size(img);
        if d~=3
            img = img(:,:,1:3);
        end
        input = imresize(img,INPUT_SIZE);
    else
        continue;
    end
    [res,stat] = ShipNet_test(nn,net,shipim);
    [~,idx] = max(res);
    
    if idx == rand_cat
        corrt = corrt + 1;
        fprintf('Step: %5d, Pred: right. Acc: %2.2f %%\n',i,double(corrt)/i*100);
    else
        fprintf('Step: %5d, Pred: wrong. Acc: %2.2f %%\n',i,double(corrt)/i*100);
    end
end
fprintf('Final Acc: %2.2f\n',double(corrt)/MAX_STEP);
