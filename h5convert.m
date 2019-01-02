weight_file = './Test/shipnet_128x128_97.31.h5';
net_input =  [128, 128, 3];
conv_stride = 1;
conv_pad = 0;
pool_size = [2, 2];
pool_stride = 2;
pool_pad = 0;

weight_mults = [1, 1, 1, 1];
% weight_mults = [8, 4, 2, 1];
w_mults_idx = 1;

% h5disp(weight_file);
weights_info = h5info(weight_file);
layer_names = weights_info.Attributes(1).Value;
layer_num = length(layer_names);
output_layer_idx = 1;

for i = 1:layer_num
    layer_name = layer_names{i};
    net.layers{output_layer_idx} = {}; 
    if (contains(lower(layer_name), 'conv')) || (contains(lower(layer_name), 'fc'))
        disp(layer_name);
        weight_name = strcat( '/', layer_name, '/', layer_name, '/',  'kernel:0');
%         bias_name = strcat( '/', layer_name, '/', layer_name, '/',  'bias:0');
        data = h5read(weight_file, weight_name);
        weight = permute(data, [4,3,2,1]);
%         data = h5read(weight_file, bias_name);
%         bias = permute(data, [2,1]);
        net.layers{output_layer_idx} = {};
        net.layers{output_layer_idx}.type = 'conv';
      
        net.layers{output_layer_idx}.weights{1} = weight*weight_mults(w_mults_idx);
        w_mults_idx = w_mults_idx + 1;
        weight_size = size(weight);
        net.layers{output_layer_idx}.weights{2} = single(zeros(1,weight_size(4)));
        net.layers{output_layer_idx}.stride = conv_stride;
        net.layers{output_layer_idx}.dilate = 1;
        net.layers{output_layer_idx}.opts = {};
        net.layers{output_layer_idx}.pad = conv_pad;
        output_layer_idx = output_layer_idx + 1;        
    end
    if (contains(lower(layer_name), 'relu'))
        disp(layer_name);
        net.layers{output_layer_idx}.type = 'relu';
        net.layers{output_layer_idx}.leak = 0;
        output_layer_idx = output_layer_idx + 1;
    end
    if (contains(lower(layer_name), 'pool'))
        disp(layer_name);
        net.layers{output_layer_idx}.type = 'pool';
        net.layers{output_layer_idx}.method = 'max';
        net.layers{output_layer_idx}.pool = pool_size;
        net.layers{output_layer_idx}.stride = pool_stride;
        net.layers{output_layer_idx}.pad = pool_pad;
        net.layers{output_layer_idx}.opts = {};
        output_layer_idx = output_layer_idx + 1;
    end 
    
    if i == layer_num
        net.layers{output_layer_idx}.type = 'softmax';
        net.layers{output_layer_idx}.method = 'max';
        net.layers{output_layer_idx}.stride = 0;
        net.layers{output_layer_idx}.pad = 0;
        net.layers{output_layer_idx}.opts = {};
    end    
end
net.meta.inputSize = net_input;
net.meta.classes.name = {"ship", "land", "sea"};

save('model.mat', 'net')