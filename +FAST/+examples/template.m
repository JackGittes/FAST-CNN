%{ 
    -------- THIS IS AN AUTO-GENERATED NETWORK TEMPLATE --------
    NOTE: There is no guarantee for correctness. To start a 
    simulation, check the topology with the original network and 
    add necessary operations in the below code.

    (1). The shortcut connection is ignored in conversion.
    (2). Numeric type cast may be incorrect.
    ------------------------------------------------------------ 
%} 
% Author: Zhao Mingxin
% Date: 2020-11-02

function [im, stat] = template(nn, net, im)
    f = fimath('CastBeforeSum',0, 'OverflowMode', 'Saturate', 'RoundMode', 'floor', ... 
    'ProductMode', 'SpecifyPrecision', 'SumMode', 'SpecifyPrecision', 'ProductWordLength', 32, ... 
     'ProductFractionLength', 0, 'SumWordLength', 32, 'SumFractionLength', 0); 
    t = numerictype('WordLength', 32, 'FractionLength', 0); 

% --- Layer: root.layer1.0
    im = nn.Conv2d(im, net{1}.Weight, t, f, [2, 2], 'SAME');
    im = nn.AddBias(im, net{1}.Bias, t, f);
    im = cast_int(im, net{1}.Mul, net{1}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.layer2.0
    im = nn.Conv2d(im, net{2}.Weight, t, f, [2, 2], 'SAME');
    im = nn.AddBias(im, net{2}.Bias, t, f);
    im = cast_int(im, net{2}.Mul, net{2}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.layer3.0
    im = nn.Conv2d(im, net{3}.Weight, t, f, [2, 2], 'SAME');
    im = nn.AddBias(im, net{3}.Bias, t, f);
    im = cast_int(im, net{3}.Mul, net{3}.Shift);
    im = nn.ReLU(im);
    im = nn.Pooling(im, t, f, [4, 4], 'AVG', [4, 4], 'VALID');

% --- Layer: root.fc.0
    im = nn.PointwiseConv2d(im, net{5}.Weight, t, f);
    im = nn.AddBias(im, net{5}.Bias, t, f);
    im = cast_int(im, net{5}.Mul, net{5}.Shift);
    
    stat ={};
end

function res = cast_int(im, mul, sft) 
    im(im < -32768) = -32768;
    im(im > 32767) = 32767;
    im = im * mul;
    im = bitshift(im, -sft);
    im(im > 127) = 127;
    im(im < -128) = -128;
    res = im;
end
