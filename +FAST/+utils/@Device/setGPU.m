% Author: Zhao Mingxin
% Date: 2018/12/22
% Description: function to turn on GPU device, if No CUDA device available,
% it will throw a warning and change mode to Default SingleMore.

function setGPU(obj)
	try
		gpuDevice(2);
		obj.Mode = 'GPU';
	catch
		obj.Mode = 'SingleCore';
		warning('Fail to get GPU device.');
	end
end