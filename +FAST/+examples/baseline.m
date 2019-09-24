% Author: Zhao Mingxin
% Date: 2019/09/23
% Description: Network definition.

function [res,stat] = baseline(nn,model,input,t,f)
    tensor_order = [4,3,2,1];
 
    stat = cell(1,12);
    input = fi((double(input)/255-0.5)/0.5,t,f);
    stat{1}=input.data;
    conv1 = nn.Conv2d(input,permute(fi(model(1).net_0,t,f),tensor_order),t,f,[2,2],'SAME');
    stat{2}=conv1.data;
    
    bias1 = nn.AddBias(conv1,fi(model(1).net_1,t,f),t,f);
    stat{3} = bias1.data;
    relu1 = nn.ReLU(bias1);
    
    stat{4} = relu1.data;
    conv2 = nn.Conv2d(relu1,permute(fi(model(1).net_2,t,f),tensor_order),t,f,[2,2],'SAME');
    stat{5} = conv2.data;
    bias2 = nn.AddBias(conv2,fi(model(1).net_3,t,f),t,f);
    stat{6} = bias2.data;
    relu2 = nn.ReLU(bias2);

    stat{7} = relu2.data;
    conv3 = nn.Conv2d(relu2,permute(fi(model(1).net_4,t,f),tensor_order),t,f,[2,2],'SAME');
    stat{8} = conv3.data;
    bias3 = nn.AddBias(conv3,fi(model(1).net_5,t,f),t,f);
    stat{9} = bias3.data;
    relu3 = nn.ReLU(bias3);

    pool1 = nn.Pooling(relu3,t,f,[4,4],'AVG',[4,4],'VALID');
    
    flat = reshape(permute(pool1,[2,1,3]),[1,1,32]);
    stat{10} = pool1.data;
    fc1 = nn.Conv2d(flat, permute(reshape(fi(model(1).net_6,t,f),[1,1,2,32]),[1,2,4,3])...
        ,t,f,[1,1],'VALID');
    
    stat{11} = fc1.data;
    res = nn.AddBias(fc1,fi(model(1).net_7,t,f),t,f);
    stat{12} = res.data;
%     flat = reshape(permute(pool1,[2,1,3]),[1,32]);
%     fc1 = flat*fi(fliplr(model.net_6'),t,f);
%     res = fc1+fi(model.net_7,t,f);
%     stat{11} = res.data;
end