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