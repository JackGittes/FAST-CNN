function [totNum,sp1,sp5] = runOnDataset(imStart,imEnd,net,lbs,impath,Loader,LogID)
    val = lbs.val_lbs;
    [totNum,sp1,sp5] = deal(0,0,0);
    
    for idx = imStart:imEnd
        imlb = val.Label(idx);
        try
            img = Loader(impath,idx,lbs);
            totNum = totNum + 1;
        catch
            fprintf('Image Read Failure in :%d\n',idx);
            continue;
        end

        img = FAST.img.CropToShape(img,[224,256]);
        [p1,p5] = FAST.Net.runNetOnce(net,img,imlb+2);
        
        [sp1,sp5] = deal(sp1+p1,sp5+p5);
        
        fprintf(LogID,'Image ID: %5d, Top1: %2d, Top5: %2d, Top1 Total: %5d, Top5 Total: %5d\n, Total: %5d',idx,p1,p5,sp1,sp5,totNum);
    end
    fclose(LogID);
end