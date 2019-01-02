function Untitled2(stat)
    for i=1:length(stat)
        data = stat{i};
        fprintf('i is %d, Max is %4.4f, Min is %4.4f\n',i,max(data(:)),min(data(:)));
    end
     h = ceil(length(stat)/4);
    for i=1:length(stat)
        subplot(h,4,i);
        data = stat{i};
        data = data(:);
        histogram(data(data~=0),256);
    end
end