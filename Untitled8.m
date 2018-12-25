import FAST.*
Cores = setCores(4);
[subStart,subEnd] = FAST.op.divideDataset(Cores,1,16);

wordlen =16;
fraclen =0;
f = fimath('CastBeforeSum',0, 'OverflowMode', 'Saturate', 'RoundMode', 'nearest', ... 
'ProductMode', 'SpecifyPrecision', 'SumMode', 'SpecifyPrecision', 'ProductWordLength',wordlen, ...
'ProductFractionLength',fraclen, 'SumWordLength', wordlen, 'SumFractionLength', fraclen);
t = numerictype('WordLength', wordlen, 'FractionLength',fraclen);

param_path = './Test/mobilenet_v1_1.0_224_quant.json';
img_path ='D:/Dataset/ILSVRC2012/val/ILSVRC2012_img_val/' ;
lbfile = load('./Test/validation_lbs.mat');
LogName = 'Log/ILSVRC2012_TOTAL_Log.txt';

MobileNet = LiteNetInitialize(param_path,t,f);

profile on

val = lbfile.val_lbs;
[totNum,sp1,sp5] = deal(0,0,0);
for idx = subStart{1}:subEnd{1}
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
end
profile viewer

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