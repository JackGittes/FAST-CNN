function Untitled8(stat)
    h = ceil(length(stat)/5);
    for i = 1:length(stat)
        subplot(h,5,i);
        if ~isempty(stat(i).weight)
            data = stat(i).bias(:);
        else
            data = [];
        end
        histogram(data(data~=0),256);
        fprintf("Layer %d, max is %3d,min is %3d\n",i,max(data),min(data))
    end
end