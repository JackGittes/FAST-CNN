% ShipNet backbone fixed-point version test.

function [res,stat] = ShipNet_baseline(nn,model,input,t,f)
    if nargin < 4
        wordlen = 32;
        fraclen = 22;
        f = fimath('CastBeforeSum',0, 'OverflowMode', 'Saturate', 'RoundMode', 'floor', ... 
        'ProductMode', 'SpecifyPrecision', 'SumMode', 'SpecifyPrecision', 'ProductWordLength',wordlen, ...
        'ProductFractionLength',fraclen, 'SumWordLength', wordlen, 'SumFractionLength', fraclen);
        t = numerictype('WordLength', wordlen, 'FractionLength',fraclen);
    end
    stat = cell(1,12);
    input = fi(double(input)/256,t,f);
    stat{1}=input.data;
    conv1 = nn.Conv2d(input,fi(model(1).weight,t,f),t,f,[2,2],'SAME');
    stat{2}=conv1.data;
    
    bias1 = nn.AddBias(conv1,fi(model(1).bias,t,f),t,f);
    stat{3} = bias1.data;
    relu1 = nn.ReLU(bias1);
    
    stat{4} = relu1.data;
    conv2 = nn.Conv2d(relu1,fi(model(2).weight,t,f),t,f,[2,2],'SAME');
    stat{5} = conv2.data;
    bias2 = nn.AddBias(conv2,fi(model(2).bias,t,f),t,f);
    stat{6} = bias2.data;
    relu2 = nn.ReLU(bias2);

    stat{7} = relu2.data;
    conv3 = nn.Conv2d(relu2,fi(model(3).weight,t,f),t,f,[2,2],'SAME');
    stat{8} = conv3.data;
    bias3 = nn.AddBias(conv3,fi(model(3).bias,t,f),t,f);
    stat{9} = bias3.data;
    relu3 = nn.ReLU(bias3);

    pool1 = nn.Pooling(relu3,t,f,[4,4],'AVG',[4,4],'VALID');
    
    flat = reshape(permute(pool1,[3,2,1]),[1,1,256]);
    stat{10} = pool1.data;
    fc1 = nn.Conv2d(flat,fi(model(4).weight,t,f),t,f,[1,1],'VALID');
    stat{11} = fc1.data;
    res = nn.AddBias(fc1,fi(model(4).bias,t,f),t,f);
    stat{12} = res.data;
end