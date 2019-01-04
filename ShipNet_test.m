% ShipNet backbone fixed-point version test.

function [res,stat] = ShipNet_test(nn,model,input,t,f)
    if nargin < 4
        wordlen = 16;
        fraclen = 0;
        f = fimath('CastBeforeSum',0, 'OverflowMode', 'Saturate', 'RoundMode', 'floor', ... 
        'ProductMode', 'SpecifyPrecision', 'SumMode', 'SpecifyPrecision', 'ProductWordLength',wordlen, ...
        'ProductFractionLength',fraclen, 'SumWordLength', wordlen, 'SumFractionLength', fraclen);
        t = numerictype('WordLength', wordlen, 'FractionLength',fraclen);
    end
    stat = cell(1,12);
    
    input_ = floor(double(input)*127/255);
    
    input = fi(input_,t,f);
    
    k1 = round(model(1).weight*148);
    k1 = CastInt8(k1);
    stat{1}=k1;
    
    conv1 = nn.Conv2d(input,fi(k1,t,f),t,f,[2,2],'SAME');
    
    b1 = round(model(1).bias*148*127);
    stat{2}=b1;
    
    bias1 = nn.AddBias(conv1,fi(b1,t,f),t,f);
    relu1 = nn.ReLU(bias1);
    
    relu1 = bitshift(relu1,-9);
    relu1 = CastInt8(relu1);
    
    
    k2 = round(model(2).weight*62.5);
    k2 = CastInt8(k2);
    stat{3} = k2;
    
    conv2 = nn.Conv2d(relu1,fi(k2,t,f),t,f,[2,2],'SAME');
    
    b2 = round(model(2).bias*36*62.5);
    stat{4} = b2;
    
    bias2 = nn.AddBias(conv2,fi(b2,t,f),t,f);
    relu2 = nn.ReLU(bias2);
    
    relu2 = bitshift(relu2,-8);
    relu2 = CastInt8(relu2);
    
    k3 = round(model(3).weight*34.3);
    k3 = CastInt8(k3);
    stat{5} = k3;
    
    conv3 = nn.Conv2d(relu2,fi(k3,t,f),t,f,[2,2],'SAME');
   
    b3 = round(model(3).bias*34.3*8.4);
    stat{6} = b3;
    
    bias3 = nn.AddBias(conv3,fi(b3,t,f),t,f);
    relu3 = nn.ReLU(bias3);
    
    relu3 = bitshift(relu3,-4);
    
    relu3 = CastInt8(relu3);

    pool1 = nn.Pooling(relu3,t,f,[4,4],'LiteAVG',[4,4],'VALID');
     
    pool1 = CastInt8(pool1);
     
    flat = reshape(permute(pool1,[3,2,1]),[1,1,256]);
    
    k4 = round(model(4).weight*34.34);
    k4 = CastInt8(k4);
    stat{7} = k4;
    
    fc1 = nn.Conv2d(flat,fi(k4,t,f),t,f,[1,1],'VALID');

    b4 = round(model(4).bias*34.34*5.15*4);
    stat{8} = b4;
    
    res = nn.AddBias(fc1,fi(b4,t,f),t,f);
end

function res = CastInt8(x)
    x(x>127)=127;
    x(x<-128)=-128;
    res = x;
end