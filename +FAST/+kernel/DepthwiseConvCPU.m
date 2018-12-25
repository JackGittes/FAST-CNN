% Author: Zhao Mingxin
% Date: 2018/12/22
% Description: Depthwise Convolution implemented on CPU(SingleCore and MultiCore)

function res = DepthwiseConvCPU(obj,im,ker,t,f,im_d,multiplier,channel_size,out_size,window_shape,stride)
%   Get element position of input feature map.
    im_pos = FAST.op.GetElemPos(im_d,channel_size,out_size,window_shape,stride);

%   Reshape kernel and input feature map into im2col cell
    ker_mat = reshape(permute(ker,[1,2,4,3]),[prod(window_shape),im_d*multiplier])';
    im_mat = reshape(im(im_pos),prod(window_shape),[]);

%   Calculate Conv2d result by GEMM (General Matrix Multiplication)
%   If Multi-Core mode is on, it will calculate GEMM with parfor otherwise it will calculate by cellfun locally.
%   TODO:
%       Need to improve GEMM performance here.
    res_cell = DepthwiseGEMM(obj,ker_mat,im_mat,im_d,multiplier,out_size,window_shape);
%   Reshape result cell into tensor format to match the output shape
    res = fi(zeros([out_size,im_d*multiplier]),t,f);

%   TODO: improve reshape operation.
    for i=1:im_d
        ch_res = permute(reshape(res_cell{i}',[fliplr(out_size),multiplier]),[2,1,3]);
        res(:,:,1+(i-1)*multiplier:i*multiplier)=ch_res;
    end
end

function res_cell = DepthwiseGEMM(obj,ker_mat,im_mat,im_d,multiplier,out_size,window_shape)
    num_core = obj.Device.NumCores;
    mode = obj.Mode;
    [cal_mode,~] = FAST.utils.TaskScheduler(num_core,multiplier,prod(window_shape),prod(out_size));

    if strcmp(mode,'MultiCore') && strcmp(cal_mode,'MultiCore')
        res_cell = cell(1,im_d);
        im_mat_sp = size(im_mat);
        im_blk_len = im_mat_sp(2)/im_d;
        parfor i=1:im_d
            ker_blk = ker_mat((i-1)*multiplier+1:i*multiplier,:);
            im_blk = im_mat(:,(i-1)*im_blk_len+1:i*im_blk_len);
            res_cell{i}= ker_blk*im_blk;
        end
    else
        ker_cell = mat2cell(ker_mat,ones(1,im_d)*multiplier,prod(window_shape))';
        im_cell = mat2cell(im_mat,prod(window_shape),prod(out_size)*ones(1,im_d));
        if num_core>0 && ~strcmp(mode,'SingleCore')
            res_cell = cell(1,im_d);
            for i=1:im_d
                res_cell{i} = FAST.kernel.MultiCoreGEMM(obj,ker_cell{i},im_cell{i});
            end
        else
            res_cell = cellfun(@fimtimes,ker_cell,im_cell,'UniformOutput',false);
        end
    end
end