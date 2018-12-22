function res = ActiveSession(mode,path)
	if nargin == 0
		mode = 'MultiCore';
		path = '+FAST\+Layer\@Layer\';
	end
	FAST.utils.AutoDeclare('Layer',path,'FAST.Layer.BaseLayer','+FAST\+Layer\@Layer\');
    res = FAST.Layer.Layer;
    res.Device.setMode(mode);
end