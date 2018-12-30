% Author: Zhao Mingxin
% Date: 2018/12/26
% Description: Get device information and check status.

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

function res = getGPUInfo()
    res = struct;
    if gpuDeviceCount>0
        gd = gpuDevice();
        res.name = gd.Name;
        res.num = gpuDeviceCount;
        res.status = 'Available';
    else
        res.name = 'None';
        res.num = 0;
        res.status = 'Unavailable';
    end
end

function res = getCPUInfo()
    res = struct;
    res.name = computer;
    p = parcluster;
    res.num = p.NumWorkers;
    res.status = 'Available';
end