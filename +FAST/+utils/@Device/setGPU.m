% Author: Zhao Mingxin
% Date: 2018/12/22
% Description: 

function setGPU(obj)
	try
		gpuDevice();
		obj.Mode = 'GPU';
	catch
		obj.Mode = 'SingleCore';
		warning('Fail to get GPU device.');
	end
end