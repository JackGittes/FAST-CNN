% Author: Zhao Mingxin
% Date: 2018/12/26
% Description: Get device information and check status.
% Device information is useful for users to check if their codes run normally.

function getDeviceInfo(~)
    gpuInfo = getGPUInfo();
    cpuInfo = getCPUInfo();
    
    names = {gpuInfo.name;cpuInfo.name};
    counts = [gpuInfo.num;cpuInfo.num];
    status = {gpuInfo.status;cpuInfo.status};
    tab_name = {'GPU Info','CPU Info'};
    res = table(names,counts,status,'RowNames',tab_name,'VariableNames',{'DeviceID','Number','Status'});
    fprintf('\n');
    disp(res);
end

% Must be CUDA compatible GPU. AMD and other GPU vendors are not supported
% by MATLAB parallel computation toolbox.
function res = getGPUInfo()
    res = struct;
    if gpuDeviceCount>0
        gd = gpuDevice(2);
        res.name = gd.Name;
        res.num = gpuDeviceCount;
        res.status = 'Available';
    else
        res.name = 'None';
        res.num = 0;
        res.status = 'Unavailable';
    end
end

% It's very complex to get CPU ID and details from MATLAB API, so I just
% replace CPU info with OS info. What you will see on command window is
% 'PCWIN64' or something like this.
function res = getCPUInfo()
    res = struct;
    res.name = computer;
    p = parcluster;
    res.num = p.NumWorkers;
    res.status = 'Available';
end