import FAST.*
Cores = setCores(16);
[subStart,subEnd] = FAST.op.divideDataset(Cores,1,320);

wordlen =32;
fraclen =0;
f = fimath('CastBeforeSum',0, 'OverflowMode', 'Saturate', 'RoundMode', 'floor', ... 
'ProductMode', 'SpecifyPrecision', 'SumMode', 'SpecifyPrecision', 'ProductWordLength',wordlen, ...
'ProductFractionLength',fraclen, 'SumWordLength', wordlen, 'SumFractionLength', fraclen);
t = numerictype('WordLength', wordlen, 'FractionLength',fraclen);

param_path = './Test/mobilenet_v1_1.0_224_quant.json';
img_path ='D:/Dataset/ILSVRC2012_img_val/';
lbfile = load('./Test/validation_lbs.mat');
LogName = 'Log/ILSVRC2012_TOTAL_Log_test.txt';

MobileNet = LiteNetInitialize(param_path,t,f);

tic
t1 = toc;
spmd
    tic;
    val = lbfile.val_lbs;
    [totNum,sp1,sp5,p1,p5] = deal(0.,0.,0.,0.,0.);
    counter = 0;
    LogID = fopen(LogName,'w');
    for idx = subStart{labindex}:subEnd{labindex}
        imlb = val.Label(idx);
        try
            img = FAST.img.ILSVRC_loader(img_path,idx,lbfile);
            img = FAST.img.CropToShape(img,[224,256]);
            [p1,p5] = FAST.Net.runNetOnce(MobileNet,img,imlb+2);
            totNum = totNum + 1;
            [sp1,sp5] = deal(sp1+p1,sp5+p5);
        catch
            totNum = totNum + 0;
            fprintf('Image Read Failure in :%d\n',idx);
        end
        counter = counter+1;
        
        if mod(counter,5)==1
            labBarrier;
            r = gop(@plus,[totNum,sp1,sp5],1);
            time_lab1 = toc;
            if labindex == 1
                fprintf(LogID,'Time: %6d, Total: %5d, Top-1: %5d, Top-5: %5d, Acc-Top-5: %3.2f %%\n',time_lab1,r(1),r(2),r(3),r(3)/r(1)*100.0);
            end
        end
    end
    r = gop(@plus,[totNum,sp1,sp5],1);
    time_lab1 = toc;
    if labindex == 1
        fprintf(LogID,'Time: %6d, Total: %5d, Top-1: %5d, Top-5: %5d, Acc-Top-5: %3.2f %%\n',time_lab1,r(1),r(2),r(3),r(3)/r(1)*100.0);
    end
    fclose(LogID);
end

t2 = toc;
disp(t2-t1);

function Cores = setCores(Cores)
    p = gcp('nocreate');
    if isempty(p)
        tmp = parcluster;
        tmp.NumWorkers = Cores;
        parpool('local',Cores);
    else
        Cores = p.NumWorkers;
    end
end

function Net = LiteNetInitialize(path,t,f)
    Net = FAST.Net.LiteNet(path);
    Net.setNumeric(t);
    Net.setFimath(f);
    Net.getLayer();
end