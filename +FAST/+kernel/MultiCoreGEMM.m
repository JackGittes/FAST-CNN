% Author: Zhao Mingxin
% Date:   2018/11/27
% Description: The core function for GEMM with MultiCore support.
%{
    NOTE: Up to now(2018/11/27), the GEMM function will give obviously acceleration for
    LARGE matrix-matrix multiplication but mediate and small scale matrix-matrix 
    multiplication will suffer from communication delay between different cores 
    so that the time becomes longer than ordinary MM inevitablely.

    Update 2018/11/29: Add matrix shape judge function. Now the
    MultiCoreGEMM can automatically choose single-core and multi-core mode
    to perform GEMM according to the shape of input matrix. 
    
    Update: I tested this module on different platforms including 4 cores
    LAPTOP, 6 cores PC,12 cores Centos server and 40 cores ubuntu server
    .The result shows that the MultiCoreGEMM can outperform default
    single-core fimtimes when input matrix is very large and consume
    nearly equal time to MATLAB default fitimes when matrix is small.
%}

function res = MultiCoreGEMM(obj,mat_a,mat_b)
    [ah,aw] = size(mat_a);
    [bh,bw] = size(mat_b);
    assert(aw==bh,"Matrix Inner Dimension For Multiplication Must Match.");
    
    shape = [ah,aw,bw];
    switch obj.Mode
        case 'MultiCore'
    % Now the TaskScheduler is simple but effective in most conditions. I
    % will update its algorithm in the future.
            [cal_mode,row_per_wk] = FAST.utils.TaskScheduler(obj.Device.NumCores,ah,aw,bw);
            switch cal_mode
                case 'A_ROW'
                    res = RowBlockMM(mat_a,mat_b,row_per_wk,shape);
                case 'B_COL'
                    res = ColBlockMM(mat_a,mat_b,row_per_wk,shape);
                case 'A_B_BLK'
                    res = BlockBlockMM(mat_a,mat_b,row_per_wk,shape);
                case 'SingleCore'
                    res = mat_a*mat_b;
                otherwise
                    error('Unknown Computation Mode Detected.');
            end
        case 'SingleCore'
            res = mat_a*mat_b;
    end
end

% shape=[ah,aw,bw]
% RowBlockMM performs GEMM by dividing mat_a into blocks 
function res = RowBlockMM(mat_a,mat_b,row_per_wk,shape)
    a_blk = mat2cell(mat_a,row_per_wk,shape(2));
    spmd
        tmp_res = a_blk{labindex}*mat_b;
    end
    res = repmat(mat_a(1),[shape(1),shape(3)]);
    rowStart = 1;
    for i = 1:length(row_per_wk~=0)
        res(rowStart:rowStart+row_per_wk(i)-1,:)=tmp_res{i};
        rowStart = rowStart + row_per_wk(i);
    end
end

% ColBlockMM performs GEMM by dividing mat_b into blocks
function res = ColBlockMM(mat_a,mat_b,row_per_wk,shape)
    b_blk = mat2cell(mat_b,shape(2),row_per_wk);
    spmd
        tmp_res = mat_a*b_blk{labindex};
    end
    res = repmat(mat_a(1),[shape(1),shape(3)]);
    colStart = 1;
    for i = 1:length(row_per_wk~=0)
        res(:,colStart:colStart+row_per_wk(i)-1)=tmp_res{i};
        colStart = colStart + row_per_wk(i);
    end
end

% BlockBlockMM performs GEMM by dividing mat_a and mat_b into blocks.It finally
% gathers every block results from labs and adds them together.
function res = BlockBlockMM(mat_a,mat_b,row_per_wk,shape)
    a_cell=mat2cell(mat_a,shape(1),row_per_wk);
    b_cell=mat2cell(mat_b,row_per_wk,shape(3));
    spmd
        res_tmp = a_cell{labindex}*b_cell{labindex};
    end
    res = repmat(mat_a(1),[shape(1),shape(3)]);
    for i=1:length(row_per_wk~=0)
        res=res_tmp{i}+res;
    end
end

% Here is a additional function which is designed for large pool cluster
% for example a serve has more than 128 cores. To be completed.