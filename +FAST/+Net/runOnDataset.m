function [totNum,pred_top_1,pred_top_5] = runOnDataset(imStart,imEnd,net,lbs,impath,Loader,LogID)
    val = lbs.val_lbs;
    
    totNum = 0;
    pred_top_1 = 0;
    pred_top_5 = 0;
    
    for idx = imStart:imEnd
        imlb = val.Label(idx);
        
        try
            img = Loader(impath,idx,lbs);
        catch err
            fprintf('Image Read Failure in :%d\n',idx);
            disp(err);
            continue;
        end
        
        totNum = totNum + 1;
        
        img = FAST.img.SingleImageCrop(img);
        net.getInputs(img);
        pred = net.Forward();
        
        top5 = FAST.op.getTopKPred(pred,5);
        [~,top1] = max(pred);
        if top1 == imlb+2
            pred_top_1 = pred_top_1 + 1;
            pred_top_5 = pred_top_5 + 1;
            pred1 = 1;
            pred5 = 1;
        elseif ismember(imlb+2,top5)
            pred_top_5 = pred_top_5 +1;
            pred1 = 0;
            pred5 = 1;
        else
            pred1 = 0;
            pred5 = 0;
        end
        
        fprintf(LogID,'Image ID: %5d, Top1: %2d, Top5: %2d, Total: %d, Top1 Total: %5d, Top5 Total: %5d\n',idx,pred1,pred5,pred_top_1,pred_top_5,totNum);
    end
    fclose(LogID);
end