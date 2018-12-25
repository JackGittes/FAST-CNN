% Author: Zhao Mingxin
% Date: 2018/12/22
% Description: Very simple and dirty implementation.

function res = ActiveSession(mode)
    path = '+FAST/+layer/@Layer/';
    MAX_TRY = 5;
    if nargin == 0
		mode = 'SingleCore';
    end
    for i = 1:MAX_TRY
        try
            FAST.utils.AutoDeclare('Layer',path,'FAST.layer.BaseLayer','+FAST/+layer/@Layer/');
            break;
        catch
            continue;
        end
    end
    res = FAST.layer.Layer;
    res.Device.setMode(mode);
end