nStart = 1;
nEnd = 1;

wordlen =32;
fraclen =0;
f = fimath('CastBeforeSum',0, 'OverflowMode', 'Saturate', 'RoundMode', 'nearest', ... 
'ProductMode', 'SpecifyPrecision', 'SumMode', 'SpecifyPrecision', 'ProductWordLength',wordlen, ...
'ProductFractionLength',fraclen, 'SumWordLength', wordlen, 'SumFractionLength', fraclen);
t = numerictype('WordLength', wordlen, 'FractionLength',fraclen);

parsed_model = load('./Test/params_224_acc_87.34.mat');
MobileNet = FAST.Net.LiteNet();
MobileNet.setNumeric(t);
MobileNet.setFimath(f);
MobileNet.getLayer();
MobileNet.getModel(parsed_model.mobilenet_224_params);

img_path ='/media/zhaomingxin/winD/Dataset/ILSVRC2012_img_val/';
lbfile = load('./Test/validation_lbs.mat');

profile on
tic
t1 = toc;
val = lbfile.val_lbs;
[totNum,sp1,sp5,p1,p5] = deal(0.,0.,0.,0.,0.);
counter = 0;
for idx = nStart:nEnd
    imlb = val.Label(idx);
    try
        img = FAST.img.ILSVRC_loader(img_path,idx,lbfile);
        img = FAST.img.CropToShape(img,[224,256]);
        [p1,p5,stat] = FAST.Net.runNetOnce(MobileNet,img,imlb+2);
        totNum = totNum + 1;
        [sp1,sp5] = deal(sp1+p1,sp5+p5);
    catch err
        totNum = totNum + 0;
        disp(err);
        disp(err.stack);
    end
    counter = counter+1;

    if mod(counter,5)==0 && counter>0
        time_lab1 = toc;
        fprintf('Time: %6d, Total: %5d, Top-1: %5d, Top-5: %5d, Acc-Top-5: %3.2f %%\n',time_lab1,totNum,sp1,sp5,sp5/totNum*100.0);
    end
end
profile viewer