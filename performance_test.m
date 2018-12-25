Cores = 40;

p = gcp('nocreate'); % If no pool, do not create new one.
if isempty(p)
    tmp = parcluster;
    tmp.NumWorkers = Cores;
    parpool('local',Cores);
else
    poolsize = p.NumWorkers;
end

nStart = 1;
nEnd = 200;

SplitFunc = @(Len,Cores) floor(Len/Cores)*ones(1,Cores)+[ones(1,mod(Len,Cores)),zeros(1,Cores-mod(Len,Cores))];
interval_len = SplitFunc(nEnd-nStart+1,Cores);

subStart = cell(1,length(interval_len));
subEnd = cell(1,length(interval_len));

for i = 1:length(interval_len)
    if i==1
        subStart{i}=1;
        subEnd{i}= subStart{i}+interval_len(i)-1;
    else
        subStart{i} = subEnd{i-1}+1;
        subEnd{i}= subStart{i}+interval_len(i)-1;
    end
end

wordlen =32;
fraclen =0;
f = fimath('CastBeforeSum',0, 'OverflowMode', 'Saturate', 'RoundMode', 'nearest', ... 
'ProductMode', 'SpecifyPrecision', 'SumMode', 'SpecifyPrecision', 'ProductWordLength',wordlen, ...
'ProductFractionLength',fraclen, 'SumWordLength', wordlen, 'SumFractionLength', fraclen);
t = numerictype('WordLength', wordlen, 'FractionLength',fraclen);

param_path = '/home/zhaomingxin/FAST-CNN/Test/mobilenet_v1_1.0_128_quant.json';
MobileNet = FAST.Net.LiteNet(param_path);
MobileNet.setNumeric(t);
MobileNet.setFimath(f);
MobileNet.getLayer();

img_path ='/home/zhaomingxin/Datasets/ILSVRC2012/val/ILSVRC2012_img_val/' ;
lbfile = load('/home/zhaomingxin/FAST-CNN/Test/validation_lbs.mat');

nameNum = [num2str(subStart{1},'%05d'),'_',num2str(subEnd{1},'%05d')];
    filename = strcat('Log/ILSVRC2012_VAL_',nameNum,'.txt');
    LogID = fopen(filename,'w');

profile on
    [totNum,pred1,pred5] = FAST.Net.runOnDataset(subStart{1},subEnd{1},MobileNet,...
    lbfile,img_path,@FAST.img.ILSVRC_loader,LogID);
    res=[totNum,pred1,pred5];
profile viewer