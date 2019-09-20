% Author: Zhao Mingxin
% Date: 2018/12/22
% Description: This function is used to set device mode to multicore, if
% fails, it will throw a warning and set default mode SingleCore.
% The function is private access.

% Update: 2019/09/20: Some errors found in this file, fix them.
% 1. Turn on multicore when parpool is already active will incur an error.
% 2. Computation mode can't be set correctly in some occasions, fix them.

function setMultiCore(obj)
	cluster_available = length(gcp('nocreate'));
	if cluster_available > 0
		tmp_cluster_info = gcp('nocreate');
		pool_available = tmp_cluster_info.NumWorkers;
	else
		pool_available = 0;
	end
	if strcmp(obj.Mode, 'MultiCore') && pool_available > 0
		warning('Parallel pool and multicore mode is already on.');
	% Check if there's a active parpool, if not, turn on PCT and set the computation
	% mode.
	elseif pool_available == 0 && ~strcmp(obj.Mode, 'MultiCore')
		% Some errors maybe occur during opening parpool, catch it and give a warning.
		try
			p = parcluster('local');
			obj.NumCores = p.NumWorkers;
			obj.Mode = 'MultiCore';
			parpool('local');
		catch
			warning('Fail to turn on MultiCore mode.');
			obj.NumCores = 1;
			obj.Mode = 'SingleCore';
		end
	% Check if we are already turn on PCT, if so, there's no need to turn
	% on PCT otherwise MATLAB will throw an error. Only we need to do is 
	% change the computation mode to MultiCore.
	elseif pool_available > 0 && ~strcmp(obj.Mode, 'MultiCore')
		warning('Parallel pool is already, reset the computation mode to multicore.');
		obj.NumCores = pool_available;
		obj.Mode = 'MultiCore';
	else
	% Given that there's still some occasions that we can't handle, we check it and 
	% give a warning.
		warning('Unknown error occurred. Please check PCT configuration.');
		obj.NumCores = 1;
		obj.Mode = 'SingleCore';
	end
end

function res = getCurrentStatus()

end