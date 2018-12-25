function getDeviceInfo(~)
    gpuInfo = getGPUInfo();
    cpuInfo = getCPUInfo();
    
    names = {gpuInfo.name;cpuInfo.name};
    counts = [gpuInfo.count;cpuInfo.count];
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
        res.count = gpuDeviceCount;
        res.status = 'Available';
    else
        res.name = 'None';
        res.name = 0;
        res.status = 'Unavailable';
    end
end

function res = getCPUInfo()
    res = struct;
    res.name = computer;
    p = parcluster;
    res.count = p.NumWorkers;
    res.status = 'Available';
end