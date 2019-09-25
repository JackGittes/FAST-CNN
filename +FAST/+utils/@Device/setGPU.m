% Author: Zhao Mingxin
% Date: 2018/12/22
% Description: function to turn on GPU device, if No CUDA device available,
% it will throw a warning and change mode to Default SingleMore.

function setGPU(obj)
    % Sometimes, the GPU query can incur a GPU memory overflow error when 
    % there's already a GPU-based process running on the system.
	try
        if gpuDeviceCount > 0
            obj.Mode = 'GPU';
        else
            obj.Mode = 'SingleCore';
        end
	catch
		obj.Mode = 'SingleCore';
		warning('Fail to get GPU device.');
	end
end