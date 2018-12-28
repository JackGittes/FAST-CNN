function Untitled8(stat)
    h = ceil(length(stat)/5);
    for i = 1:length(stat)
        subplot(h,5,i);
        data = stat{i};
        histogram(data(:),256);
    end
end