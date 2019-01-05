% Author: Zhao Mingxin
% Date:   2019/1/4

function SetupCheck(obj)
    % Check Layer and Net class interface.
    FAST.ActiveSession();
    % Check config and model.
    assert(isempty(obj.ImgList),"Image list is empty.");
    assert(isempty(obj.LabelList),"Label list is empty.");
    assert(isempty(obj.Net),"No available network found in TestFramework.");
    assert(isempty(obj.Model),"Network weights should be provided before test.");
    if isempty(obj.LogID)
        warning("No LogID is provided, test procedure will still continue without log.");
    end
    if isempty(obj.Stat)
        warning("No statistic information is specified, no parameters' statistic information will be collected.");
    end
end