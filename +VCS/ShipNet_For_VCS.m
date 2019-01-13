% ShipNet backbone fixed-point version test.

function res = ShipNet_For_VCS(nn,model,input,t,f)
    if nargin < 4
        wordlen = 32;
        fraclen = 0;
        f = fimath('CastBeforeSum',0, 'OverflowMode', 'Saturate', 'RoundMode', 'floor', ... 
        'ProductMode', 'SpecifyPrecision', 'SumMode', 'SpecifyPrecision', 'ProductWordLength',wordlen, ...
        'ProductFractionLength',fraclen, 'SumWordLength', wordlen, 'SumFractionLength', fraclen);
        t = numerictype('WordLength', wordlen, 'FractionLength',fraclen);
    end
    
    conv1 = nn.Conv2d(input,fi(model(1).weight,t,f),t,f,[2,2],'SAME');
    bias1 = nn.AddBias(conv1,fi(model(1).bias,t,f),t,f);
    relu1 = nn.ReLU(bias1);
    relu_sft_1 = bitshift(relu1,-9);

    conv2 = nn.Conv2d(relu_sft_1,fi(model(2).weight,t,f),t,f,[2,2],'SAME');
    bias2 = nn.AddBias(conv2,fi(model(2).bias,t,f),t,f);
    relu2 = nn.ReLU(bias2);
    relu_sft_2 = bitshift(relu2,-8);

    conv3 = nn.Conv2d(relu_sft_2,fi(model(3).weight,t,f),t,f,[2,2],'SAME');
    bias3 = nn.AddBias(conv3,fi(model(3).bias,t,f),t,f);
    relu3 = nn.ReLU(bias3);
    relu_sft_3 = bitshift(relu3,-4);

    pool1 = nn.Pooling(relu_sft_3,t,f,[4,4],'AVG',[4,4],'VALID');
    
    flat = reshape(permute(pool1,[3,1,2]),[1,1,256]);
    
    fc1 = nn.Conv2d(flat,fi(model(6).weight,t,f),t,f,[1,1],'VALID');
    res = nn.AddBias(fc1,fi(model(6).bias,t,f),t,f);
end