weight_file ='./Test/shipcoarse05_loss_50.h5';
clear net
tmp = struct;
net = repmat(tmp,[5,1]);
layers = {'conv1','conv2','conv3','conv4','FC'};
for i =1:5
    layer_name = layers{i};
    weight_name = strcat( '/', layer_name, '/', layer_name, '/',  'kernel:0');
    bias_name = strcat( '/', layer_name, '/', layer_name, '/',  'bias:0');
    tmp_w = h5read(weight_file,weight_name);
    tmp_b = h5read(weight_file,bias_name);
    net(i).weight = permute(tmp_w,[4,3,2,1]);
    net(i).bias = permute(tmp_b,[2,1]);
end