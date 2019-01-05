% Author: Zhao Mingxin
% Date:   2019/1/4
% Description: Convert Keras .h5 file to tensorflow compatible format.
% NOTE: It's NOT a general purpose converter, just to convert ShipNet
% weight file. So it's better not to use it on other Keras CNN .h5 file. 

function net = h5Keras2TF(weight_file)
    if nargin == 0
        weight_file ='./Test/0122.h5';
    end
    tmp = struct;
    net = repmat(tmp,[4,1]);
    layers = {'conv1','conv2','conv3','FC_2'};
    for i =1:4
        layer_name = layers{i};
        weight_name = strcat( '/', layer_name, '/', layer_name, '/',  'kernel:0');
        bias_name = strcat( '/', layer_name, '/', layer_name, '/',  'bias:0');
        tmp_w = h5read(weight_file,weight_name);
        tmp_b = h5read(weight_file,bias_name);
        net(i).weight = permute(tmp_w,[4,3,2,1]);
        net(i).bias = permute(tmp_b,[2,1]);
    end
end