function [res,stat] = runOnDataset(obj)
%     if obj.needLog ~=0
%         LogID = fopen(obj.Log_path,'w');
%     end
    obj.InitialCheck(obj);
    
    device = FAST.utils.Device;
    lbs = obj.LabelList;
    Cores = device.setCores(obj.Config.Cores);
    [subStart,subEnd] = FAST.op.divideDataset(Cores,obj.Config.Start,obj.Config.End);
    
    nn = FAST.Layer.Layer;
    nn.Device.setMode('GPU');
    
    counter = 0;
    spmd
        tic
        corrt = 0;
        totNum = 0;
        for i=subStart{labindex}:subEnd{labindex}
            
            img = ImgLoader([obj.Config.ImgPath,obj.ImgList{i}]);
            
            prepocessFunc = str2func(obj.Config.Preprocess);
            input = prepocessFunc(img,obj.Config.INPUT_SIZE);
            [res,stat] = obj.Net(nn,obj.model,input);
            
            totNum = totNum +1;
            [~,idx] = max(res);
            if idx == lbs(i)
                corrt = corrt +1;
            end
            counter = counter +1;
            if counter~=0 && mod(counter,obj.PrintInterval)==0
                labBarrier;
                r = gop(@plus,[totNum,corrt],1);
                time_lab1 = toc;
                if labindex == 1
                   fprintf('Time: %6d, Total: %5d, Correct: %5d ,Acc-Top: %3.2f %%\n',time_lab1,r(1),r(2),r(2)/r(1)*100.0);
                end
            end
        end
        r = gop(@plus,[totNum,corrt],1);
        time_lab1 = toc;
        if labindex == 1
            fprintf('Time: %6d, Total: %5d, Correct: %5d ,Acc-Top: %3.2f %%\n',time_lab1,r(1),r(2),r(2)/r(1)*100.0);
        end
    end
end

function img = ImgLoader(path)
    try
        img = imread(path);
    catch
        error("Read Failure");
    end
    [~,~,d] = size(img);
    if d~=3
        img = img(:,:,1:3);
    end
end