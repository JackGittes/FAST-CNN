function Untitled(model)
    for i=1:length(model)
        if ~isempty(model(i).bias)
            data = model(i).bias.data;
            data = data(data~=0);
        else
            data = [];
        end
        subplot(7,5,i);
        histogram(data,256);
        fprintf('max is %f\n',max(data(:)));
        fprintf('min is %f\n',min(data(:)));
    end
end