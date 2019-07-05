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
    
    % In order to totally clear residual data in memory, AutoDeclare will try
    % MAX_TRY times to make sure that all changes have been added into class
    % interfaces.
    for i = 1:MAX_TRY
        try
            % Scan Layer and Net class folder and check if there are any
            % functions changed. If new function added into Layer and Net
            % class or input/output definition of existing function
            % changed, the AutoDeclare will automatically modify the
            % class interfaces.
            FAST.utils.AutoDeclare('Layer', '+FAST/+Layer/@Layer/','FAST.Layer.BaseLayer','+FAST/+Layer/@Layer/');
            FAST.utils.AutoDeclare('LiteNet','+FAST/+Net/@LiteNet/','FAST.Net.Net','+FAST/+Net/@LiteNet/');
            break;
        catch
            continue;
        end
    end
    % It will return a Layer class by default, because I want to
    % provide a Procedure Oriented Interface for someone who uses this
    % toolbox for the first time.
    res = FAST.Layer.Layer;
    res.Device.setMode(mode);
    % Default hint is 1 which means it will print device information on
    % MATLAB command window.
    if hint == 1
        res.Device.getDeviceInfo();
    end
end