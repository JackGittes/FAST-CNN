% Author: Zhao Mingxin
% Date: 2018/12/22
% Description: This function is used to set device mode to multicore, if
% fails, it will throw a warning and set default mode SingleCore.
% The function is private access.

function setMultiCore(obj)
	try
		p = parcluster('local');
		obj.NumCores = p.NumWorkers;
		obj.Mode = 'MultiCore';
	catch
		warning('Fail to turn on MultiCore mode.');
		obj.NumCores = 1;
		obj.Mode = 'SingleCore';
	end
end