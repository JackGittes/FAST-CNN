function [data,mem_tab,byte_mat]= prepareData(img,model,orgin_model)
    offset = numel(img)-1;
    memForInput = getInput(offset);
    memForParams = FAST.VP.MemoryAllocator('Parameter',[model.kernel,{model.FC}],model.bias,offset);
    
    offset = FAST.VP.mem.getSectionEndAddr(memForParams);

    memForMaps = FAST.VP.MemoryAllocator('Map',size(img),orgin_model,offset);
    mem_tab = [memForInput;memForParams;memForMaps];
    
    conv_ = FAST.VP.storeKernels(model.kernel{:});
    FC_ = FAST.VP.reshapeFC(model.FC);
    bias_byte = FAST.VP.storeBias(model.bias{:});

    img_ = floor(double(img)/2);
    img_c2r = permute(img_,[2,1,3]);
    ker = [conv_,FC_];
    
    [img_fi,ker_fi]=deal(fi(img_c2r(:)',1,8,0),fi(ker,1,8,0));

    tmp_ = cellfun(@HexTransform,{img_fi,ker_fi},'UniformOutput',false);
    [img_byte,ker_byte]=tmp_{:};
    
    Byte_align = FAST.VP.checkBitAlign([img_byte,ker_byte],2);
    
    ByteStr = [Byte_align,bias_byte];
    [data,byte_mat] = writeMemPipeline(ByteStr);
end

function tmp = getInput(offset)
    tmp = struct;
    tmp.Name = 'INPUT';
    tmp.KerByteWidth = 1;
    tmp.KernelStart = 0;
    tmp.KernelEnd = offset;
    tmp.BiasByteWidth = [];
    tmp.BiasStart = [];
    tmp.BiasEnd = [];
end