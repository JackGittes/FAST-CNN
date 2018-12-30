% Author: Zhao Mingxin
% Date: 2018/12/22
% Description: Very simple and dirty implementation.
%{
    AutoSession is a function that help us automatically detect changes in
    class definition and add these changes into class interfaces.
    
    Everytime you use a Net or Layer class, it's highly recommended that
    you call the ActiveSession.
%}
function res = ActiveSession(mode,hint)
    MAX_TRY = 5;
    if nargin == 0
		mode = 'SingleCore';
        hint = 1;
    elseif nargin == 1
        hint = 1;
    end
    
    % In order to fully clear residual data in memory, AutoDeclare will try
    % MAX_TRY times making sure that all changes have been added into class
    % interface.
    for i = 1:MAX_TRY
        try
            % Scan Layer and Net class folder and check if there are any
            % function changed. If new function added into Layer and Net
            % class or input/output definition of existing function
            % changed, the AutoDeclare will automatically modify the
            % class interface.
            FAST.utils.AutoDeclare('Layer', '+FAST/+Layer/@Layer/','FAST.Layer.BaseLayer','+FAST/+Layer/@Layer/');
            FAST.utils.AutoDeclare('LiteNet','+FAST/+Net/@LiteNet/','FAST.Net.Net','+FAST/+Net/@LiteNet/');
            break;
        catch
            continue;
        end
    end
    res = FAST.Layer.Layer;
    res.Device.setMode(mode);
    if hint == 1
        res.Device.getDeviceInfo();
    end
end