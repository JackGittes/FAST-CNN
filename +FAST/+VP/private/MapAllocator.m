% Author: Zhao Mingxin
% Date:   2019/1/8
% Description: This function allocates memory for feature maps assuming
% that the hardware has an infinite memory space.

function res = MapAllocator(input_size,model,offset)
    LayerN = length(model);
    CurAdd = 0+offset;
    MapNum = 1;
    for i =1:LayerN
        if i == 1
            net_size = input_size;
        end
        Layer = model(i);
        switch Layer.type
            case {'Conv2d','Pooling'}
                if strcmp(Layer.type,'Conv2d')
                    ker_shape = size(Layer.weight);
                else
                    ker_shape = Layer.builtin.window;
                end
                net_size = getOutsize(Layer.type,net_size,ker_shape,Layer.builtin.stride,Layer.builtin.padding);
                res(MapNum) = MemIncrease(net_size,CurAdd+1,MapNum);
                CurAdd = prod(net_size) + CurAdd;
                MapNum = MapNum+1;
            case 'Flatten'
                net_size = [1,1,prod(net_size)];
            otherwise
                warning("Unsupported Type.");
                fprintf(Layer.type);
        end
    end
    res = res';
end

function res = MemIncrease(net_size,offset,i)
    tmp = struct;
    LayerID = num2str(i);
    tmp.Name = ['FeatureMap ',LayerID];
    tmp.KerByteWidth = 1;
    tmp.KernelStart = offset;
    tmp.KernelEnd = tmp.KernelStart+prod(net_size)-1;
    tmp.BiasByteWidth = [];
    tmp.BiasStart = [];
    tmp.BiasEnd = [];
    res = tmp;
end