% Author: Zhao Mingxin
% Date:   2019/1/1
% Description: Set device cores
% Last change: 2019/1/2

% NOTE: Although this method can change current available cores on your
% machine, it won't change computation Mode defined in Device class. The
% reason is that when validating your quantization algorithm on the entire
% dataset, you can divide the dataset into different parts and run each
% part on a Core. 

% For example, if you have 16 Cores in your CPU and the dataset has 3200
% images, then you can run CNN on each core with 200 images and every CNN
% can use GPU acceleration under computation Mode 'GPU'. By doing this, the
% time consumption will be dramatically reduced with the benefit of GPU
% acceleration and multicore parallelization.

% BE CAREFUL: If you directly change the Device Mode to 'MultiCore', the 
% Conv2d and DepthwiseConv2d function would only use MultiCore acceleration 
% instead of GPU.

function res = setCores(Cores)
    assert(isnumeric(Cores),"Cores number must be an integer.");
    assert(Cores>0 && Cores<=1024,"Cores should be positive and maximum is 1024.");
    p = gcp('nocreate');
    if isempty(p)
        try
            SpecificCoreOn(Cores);
            res = Cores;
        catch err
            warning_info = ['Can''t turn on specific cores on your machine,'...
                'maybe something wrong with your PCT config.'];
            warning(warning_info);
            disp(err);
            res = 1;
        end
    else
        if Cores ~= p.NumWorkers
            delete(p);
            try
                SpecificCoreOn(Cores);
                res = Cores;
            catch
                warning_info = ['Fail to get ',num2str(Cores),' Cores on this machine.'];
                warning(warning_info);
                fprintf(2,"Try to turn on default local parpool ...\n");
                try
                    parpool('local');
                    p = gcp('nocreate');
                    res = p.NumWorkers;
                catch
                    warning('Fail to turn on any parpool, maybe something wrong with your PCT config');
                    res = 1;
                end
            end
        else
            res = p.NumWorkers;
        end
    end
end

function SpecificCoreOn(Cores)
    tmp = parcluster;
    tmp.NumWorkers = Cores;
    parpool('local',Cores);
end