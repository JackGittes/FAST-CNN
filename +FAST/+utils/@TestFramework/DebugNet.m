function [res,stat] = DebugNet(obj,profile_flag)
    if nargin>1
        if profile_flag == true
            profile_map = {'profile on','profile viewer'};
        else
            profile_map = {'',''};
        end
    elseif nargin == 1
        profile_map = {'',''};
    end
    eval(profile_map{1});

    
    
    
    
    
    
    eval(profile_map{2});
end