% Author: Zhao Mingxin
% Date:   2018/11/29
% Description: as below

% TaskScheduler accepts [worker numbers n, mat_a and mat_b shape] and 
% arranges rows of matrix to different workers to perform MultiCoreGEMM. The rules mainly due to
% height of mat_a and width of mat_b. 

% NOTE: Cannon or SUMMA Algorithm is the well-known GEMM parallel method while MATLAB does't support 
% finely manipulate matrix between workers so I just adopt simple rules to schedule tasks.

% TODO: deal with aw>>ah condition

function  [cal_mode,row_per_wk] = TaskScheduler(n,ah,aw,bw)
    SplitFunc = @(row,n_wk) floor(row/n_wk)*ones(1,n_wk)+...
        [ones(1,mod(row,n_wk)),zeros(1,n_wk-mod(row,n_wk))];
    sp = [ah,bw];

    LargeThresh = 128*128*64;
    alpha = 100;
  % Initialize cal_mode to 'SingleCore' and if n==0 return  
    row_per_wk = NaN;
    cal_mode = 'SingleCore';
    if n==0
        warning('No Active Parallel Pool Found.');
        return
    end
    
   % ubl_ft means workload unbalance factor. Ubl_ft is used to determine
   % which split mode will take effect.
    ubl_ft =  ceil(sp/n)./(sp/n)-1;
    
    if LargeThresh - ah*aw*bw>0
        row_per_wk = zeros(1,n);
        cal_mode = 'SingleCore';
    elseif aw>alpha*ah && aw>alpha*bw
        row_per_wk = SplitFunc(aw,n);
        cal_mode = 'A_B_BLK';
    else
        if ubl_ft(1)<ubl_ft(2)
            row_per_wk = SplitFunc(ah,n);
            cal_mode = 'A_ROW';
        elseif ubl_ft(1)>=ubl_ft(2)
            row_per_wk = SplitFunc(bw,n);
            cal_mode = 'B_COL';
        else
            row_per_wk = zeros(1,n);
            cal_mode = 'Unknown';
        end
    end
end