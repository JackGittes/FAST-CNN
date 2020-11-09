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
% Date: 2020-11-07

function [im, stat] = template(nn, net, im)
    f = fimath('CastBeforeSum',0, 'OverflowMode', 'Saturate', 'RoundMode', 'round', ... 
    'ProductMode', 'SpecifyPrecision', 'SumMode', 'SpecifyPrecision', 'ProductWordLength', 32, ... 
     'ProductFractionLength', 0, 'SumWordLength', 32, 'SumFractionLength', 0); 
    t = numerictype('WordLength', 32, 'FractionLength', 0); 

% --- WARNING: Input is adjusted to [-128, 127].
% --- If your pre-processing is not like this,
% --- change it to what you used.
    norm_im = single(im) / 255;
    norm_im(:,:,1) = (norm_im(:,:,1) - 0.485) / 0.229;
    norm_im(:,:,2) = (norm_im(:,:,2) - 0.456) / 0.224;
    norm_im(:,:,3) = (norm_im(:,:,3) - 0.406) / 0.225;

    im = fi(round(norm_im * 48.1), t, f);

% --- Layer: root.features.0.0
    im = nn.ZeroPad2d(im, [1, 1]);
    im = nn.Conv2d(im, net{1}.Weight, t, f, [2, 2], 'VALID');
    im = nn.AddBias(im, net{1}.Bias, t, f);
    im = cast_int(im, net{1}.Mul, net{1}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.1.conv.0.0
    im = nn.ZeroPad2d(im, [1, 1]);
    im = nn.DepthwiseConv2d(im, net{2}.Weight, t, f, [1, 1], 'VALID');
    im = nn.AddBias(im, net{2}.Bias, t, f);
    im = cast_int(im, net{2}.Mul, net{2}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.1.conv.0
    im = nn.PointwiseConv2d(im, net{3}.Weight, t, f);
    im = nn.AddBias(im, net{3}.Bias, t, f);
    im = cast_int(im, net{3}.Mul, net{3}.Shift);

% --- Layer: root.features.2.conv.0.0
    im = nn.PointwiseConv2d(im, net{4}.Weight, t, f);
    im = nn.AddBias(im, net{4}.Bias, t, f);
    im = cast_int(im, net{4}.Mul, net{4}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.2.conv.1.0
    im = nn.ZeroPad2d(im, [1, 1]);
    im = nn.DepthwiseConv2d(im, net{5}.Weight, t, f, [2, 2], 'VALID');
    im = nn.AddBias(im, net{5}.Bias, t, f);
    im = cast_int(im, net{5}.Mul, net{5}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.2.conv.0
    im = nn.PointwiseConv2d(im, net{6}.Weight, t, f);
    im = nn.AddBias(im, net{6}.Bias, t, f);
    im1 = cast_int(im, net{6}.Mul, net{6}.Shift);

% --- Layer: root.features.3.conv.0.0
    im = nn.PointwiseConv2d(im1, net{7}.Weight, t, f);
    im = nn.AddBias(im, net{7}.Bias, t, f);
    im = cast_int(im, net{7}.Mul, net{7}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.3.conv.1.0
    im = nn.ZeroPad2d(im, [1, 1]);
    im = nn.DepthwiseConv2d(im, net{8}.Weight, t, f, [1, 1], 'VALID');
    im = nn.AddBias(im, net{8}.Bias, t, f);
    im = cast_int(im, net{8}.Mul, net{8}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.3.conv.0
    im = nn.PointwiseConv2d(im, net{9}.Weight, t, f);
    im = nn.AddBias(im, net{9}.Bias, t, f);
    im = cast_int(im, net{9}.Mul, net{9}.Shift);

% --- Element-wise Addition: root.features.3.0
    im = nn.Add(im1, im, net{10}.Mul_L, net{10}.Shift_L, net{10}.Mul_R, net{10}.Shift_R);

% --- Layer: root.features.4.conv.0.0
    im = nn.PointwiseConv2d(im, net{11}.Weight, t, f);
    im = nn.AddBias(im, net{11}.Bias, t, f);
    im = cast_int(im, net{11}.Mul, net{11}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.4.conv.1.0
    im = nn.ZeroPad2d(im, [1, 1]);
    im = nn.DepthwiseConv2d(im, net{12}.Weight, t, f, [2, 2], 'VALID');
    im = nn.AddBias(im, net{12}.Bias, t, f);
    im = cast_int(im, net{12}.Mul, net{12}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.4.conv.0
    im = nn.PointwiseConv2d(im, net{13}.Weight, t, f);
    im = nn.AddBias(im, net{13}.Bias, t, f);
    im1 = cast_int(im, net{13}.Mul, net{13}.Shift);

% --- Layer: root.features.5.conv.0.0
    im = nn.PointwiseConv2d(im1, net{14}.Weight, t, f);
    im = nn.AddBias(im, net{14}.Bias, t, f);
    im = cast_int(im, net{14}.Mul, net{14}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.5.conv.1.0
    im = nn.ZeroPad2d(im, [1, 1]);
    im = nn.DepthwiseConv2d(im, net{15}.Weight, t, f, [1, 1], 'VALID');
    im = nn.AddBias(im, net{15}.Bias, t, f);
    im = cast_int(im, net{15}.Mul, net{15}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.5.conv.0
    im = nn.PointwiseConv2d(im, net{16}.Weight, t, f);
    im = nn.AddBias(im, net{16}.Bias, t, f);
    im = cast_int(im, net{16}.Mul, net{16}.Shift);

% --- Element-wise Addition: root.features.5.0
    im2 = nn.Add(im1, im, net{17}.Mul_L, net{17}.Shift_L, net{17}.Mul_R, net{17}.Shift_R);

% --- Layer: root.features.6.conv.0.0
    im = nn.PointwiseConv2d(im2, net{18}.Weight, t, f);
    im = nn.AddBias(im, net{18}.Bias, t, f);
    im = cast_int(im, net{18}.Mul, net{18}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.6.conv.1.0
    im = nn.ZeroPad2d(im, [1, 1]);
    im = nn.DepthwiseConv2d(im, net{19}.Weight, t, f, [1, 1], 'VALID');
    im = nn.AddBias(im, net{19}.Bias, t, f);
    im = cast_int(im, net{19}.Mul, net{19}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.6.conv.0
    im = nn.PointwiseConv2d(im, net{20}.Weight, t, f);
    im = nn.AddBias(im, net{20}.Bias, t, f);
    im = cast_int(im, net{20}.Mul, net{20}.Shift);

% --- Element-wise Addition: root.features.6.0
    im = nn.Add(im2, im, net{21}.Mul_L, net{21}.Shift_L, net{21}.Mul_R, net{21}.Shift_R);

% --- Layer: root.features.7.conv.0.0
    im = nn.PointwiseConv2d(im, net{22}.Weight, t, f);
    im = nn.AddBias(im, net{22}.Bias, t, f);
    im = cast_int(im, net{22}.Mul, net{22}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.7.conv.1.0
    im = nn.ZeroPad2d(im, [1, 1]);
    im = nn.DepthwiseConv2d(im, net{23}.Weight, t, f, [2, 2], 'VALID');
    im = nn.AddBias(im, net{23}.Bias, t, f);
    im = cast_int(im, net{23}.Mul, net{23}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.7.conv.0
    im = nn.PointwiseConv2d(im, net{24}.Weight, t, f);
    im = nn.AddBias(im, net{24}.Bias, t, f);
    im1 = cast_int(im, net{24}.Mul, net{24}.Shift);

% --- Layer: root.features.8.conv.0.0
    im = nn.PointwiseConv2d(im1, net{25}.Weight, t, f);
    im = nn.AddBias(im, net{25}.Bias, t, f);
    im = cast_int(im, net{25}.Mul, net{25}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.8.conv.1.0
    im = nn.ZeroPad2d(im, [1, 1]);
    im = nn.DepthwiseConv2d(im, net{26}.Weight, t, f, [1, 1], 'VALID');
    im = nn.AddBias(im, net{26}.Bias, t, f);
    im = cast_int(im, net{26}.Mul, net{26}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.8.conv.0
    im = nn.PointwiseConv2d(im, net{27}.Weight, t, f);
    im = nn.AddBias(im, net{27}.Bias, t, f);
    im = cast_int(im, net{27}.Mul, net{27}.Shift);

% --- Element-wise Addition: root.features.8.0
    im2 = nn.Add(im1, im, net{28}.Mul_L, net{28}.Shift_L, net{28}.Mul_R, net{28}.Shift_R);

% --- Layer: root.features.9.conv.0.0
    im = nn.PointwiseConv2d(im2, net{29}.Weight, t, f);
    im = nn.AddBias(im, net{29}.Bias, t, f);
    im = cast_int(im, net{29}.Mul, net{29}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.9.conv.1.0
    im = nn.ZeroPad2d(im, [1, 1]);
    im = nn.DepthwiseConv2d(im, net{30}.Weight, t, f, [1, 1], 'VALID');
    im = nn.AddBias(im, net{30}.Bias, t, f);
    im = cast_int(im, net{30}.Mul, net{30}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.9.conv.0
    im = nn.PointwiseConv2d(im, net{31}.Weight, t, f);
    im = nn.AddBias(im, net{31}.Bias, t, f);
    im = cast_int(im, net{31}.Mul, net{31}.Shift);

% --- Element-wise Addition: root.features.9.0
    im3 = nn.Add(im2, im, net{32}.Mul_L, net{32}.Shift_L, net{32}.Mul_R, net{32}.Shift_R);

% --- Layer: root.features.10.conv.0.0
    im = nn.PointwiseConv2d(im3, net{33}.Weight, t, f);
    im = nn.AddBias(im, net{33}.Bias, t, f);
    im = cast_int(im, net{33}.Mul, net{33}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.10.conv.1.0
    im = nn.ZeroPad2d(im, [1, 1]);
    im = nn.DepthwiseConv2d(im, net{34}.Weight, t, f, [1, 1], 'VALID');
    im = nn.AddBias(im, net{34}.Bias, t, f);
    im = cast_int(im, net{34}.Mul, net{34}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.10.conv.0
    im = nn.PointwiseConv2d(im, net{35}.Weight, t, f);
    im = nn.AddBias(im, net{35}.Bias, t, f);
    im = cast_int(im, net{35}.Mul, net{35}.Shift);

% --- Element-wise Addition: root.features.10.0
    im = nn.Add(im3, im, net{36}.Mul_L, net{36}.Shift_L, net{36}.Mul_R, net{36}.Shift_R);

% --- Layer: root.features.11.conv.0.0
    im = nn.PointwiseConv2d(im, net{37}.Weight, t, f);
    im = nn.AddBias(im, net{37}.Bias, t, f);
    im = cast_int(im, net{37}.Mul, net{37}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.11.conv.1.0
    im = nn.ZeroPad2d(im, [1, 1]);
    im = nn.DepthwiseConv2d(im, net{38}.Weight, t, f, [1, 1], 'VALID');
    im = nn.AddBias(im, net{38}.Bias, t, f);
    im = cast_int(im, net{38}.Mul, net{38}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.11.conv.0
    im = nn.PointwiseConv2d(im, net{39}.Weight, t, f);
    im = nn.AddBias(im, net{39}.Bias, t, f);
    im1 = cast_int(im, net{39}.Mul, net{39}.Shift);

% --- Layer: root.features.12.conv.0.0
    im = nn.PointwiseConv2d(im1, net{40}.Weight, t, f);
    im = nn.AddBias(im, net{40}.Bias, t, f);
    im = cast_int(im, net{40}.Mul, net{40}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.12.conv.1.0
    im = nn.ZeroPad2d(im, [1, 1]);
    im = nn.DepthwiseConv2d(im, net{41}.Weight, t, f, [1, 1], 'VALID');
    im = nn.AddBias(im, net{41}.Bias, t, f);
    im = cast_int(im, net{41}.Mul, net{41}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.12.conv.0
    im = nn.PointwiseConv2d(im, net{42}.Weight, t, f);
    im = nn.AddBias(im, net{42}.Bias, t, f);
    im = cast_int(im, net{42}.Mul, net{42}.Shift);

% --- Element-wise Addition: root.features.12.0
    im2 = nn.Add(im1, im, net{43}.Mul_L, net{43}.Shift_L, net{43}.Mul_R, net{43}.Shift_R);

% --- Layer: root.features.13.conv.0.0
    im = nn.PointwiseConv2d(im2, net{44}.Weight, t, f);
    im = nn.AddBias(im, net{44}.Bias, t, f);
    im = cast_int(im, net{44}.Mul, net{44}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.13.conv.1.0
    im = nn.ZeroPad2d(im, [1, 1]);
    im = nn.DepthwiseConv2d(im, net{45}.Weight, t, f, [1, 1], 'VALID');
    im = nn.AddBias(im, net{45}.Bias, t, f);
    im = cast_int(im, net{45}.Mul, net{45}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.13.conv.0
    im = nn.PointwiseConv2d(im, net{46}.Weight, t, f);
    im = nn.AddBias(im, net{46}.Bias, t, f);
    im = cast_int(im, net{46}.Mul, net{46}.Shift);

% --- Element-wise Addition: root.features.13.0
    im = nn.Add(im2, im, net{47}.Mul_L, net{47}.Shift_L, net{47}.Mul_R, net{47}.Shift_R);

% --- Layer: root.features.14.conv.0.0
    im = nn.PointwiseConv2d(im, net{48}.Weight, t, f);
    im = nn.AddBias(im, net{48}.Bias, t, f);
    im = cast_int(im, net{48}.Mul, net{48}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.14.conv.1.0
    im = nn.ZeroPad2d(im, [1, 1]);
    im = nn.DepthwiseConv2d(im, net{49}.Weight, t, f, [2, 2], 'VALID');
    im = nn.AddBias(im, net{49}.Bias, t, f);
    im = cast_int(im, net{49}.Mul, net{49}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.14.conv.0
    im = nn.PointwiseConv2d(im, net{50}.Weight, t, f);
    im = nn.AddBias(im, net{50}.Bias, t, f);
    im1 = cast_int(im, net{50}.Mul, net{50}.Shift);

% --- Layer: root.features.15.conv.0.0
    im = nn.PointwiseConv2d(im1, net{51}.Weight, t, f);
    im = nn.AddBias(im, net{51}.Bias, t, f);
    im = cast_int(im, net{51}.Mul, net{51}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.15.conv.1.0
    im = nn.ZeroPad2d(im, [1, 1]);
    im = nn.DepthwiseConv2d(im, net{52}.Weight, t, f, [1, 1], 'VALID');
    im = nn.AddBias(im, net{52}.Bias, t, f);
    im = cast_int(im, net{52}.Mul, net{52}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.15.conv.0
    im = nn.PointwiseConv2d(im, net{53}.Weight, t, f);
    im = nn.AddBias(im, net{53}.Bias, t, f);
    im = cast_int(im, net{53}.Mul, net{53}.Shift);

% --- Element-wise Addition: root.features.15.0
    im2 = nn.Add(im1, im, net{54}.Mul_L, net{54}.Shift_L, net{54}.Mul_R, net{54}.Shift_R);

% --- Layer: root.features.16.conv.0.0
    im = nn.PointwiseConv2d(im2, net{55}.Weight, t, f);
    im = nn.AddBias(im, net{55}.Bias, t, f);
    im = cast_int(im, net{55}.Mul, net{55}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.16.conv.1.0
    im = nn.ZeroPad2d(im, [1, 1]);
    im = nn.DepthwiseConv2d(im, net{56}.Weight, t, f, [1, 1], 'VALID');
    im = nn.AddBias(im, net{56}.Bias, t, f);
    im = cast_int(im, net{56}.Mul, net{56}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.16.conv.0
    im = nn.PointwiseConv2d(im, net{57}.Weight, t, f);
    im = nn.AddBias(im, net{57}.Bias, t, f);
    im = cast_int(im, net{57}.Mul, net{57}.Shift);

% --- Element-wise Addition: root.features.16.0
    im = nn.Add(im2, im, net{58}.Mul_L, net{58}.Shift_L, net{58}.Mul_R, net{58}.Shift_R);

% --- Layer: root.features.17.conv.0.0
    im = nn.PointwiseConv2d(im, net{59}.Weight, t, f);
    im = nn.AddBias(im, net{59}.Bias, t, f);
    im = cast_int(im, net{59}.Mul, net{59}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.17.conv.1.0
    im = nn.ZeroPad2d(im, [1, 1]);
    im = nn.DepthwiseConv2d(im, net{60}.Weight, t, f, [1, 1], 'VALID');
    im = nn.AddBias(im, net{60}.Bias, t, f);
    im = cast_int(im, net{60}.Mul, net{60}.Shift);
    im = nn.ReLU(im);

% --- Layer: root.features.17.conv.0
    im = nn.PointwiseConv2d(im, net{61}.Weight, t, f);
    im = nn.AddBias(im, net{61}.Bias, t, f);
    im = cast_int(im, net{61}.Mul, net{61}.Shift);

% --- Layer: root.features.18.0
    im = nn.PointwiseConv2d(im, net{62}.Weight, t, f);
    im = nn.AddBias(im, net{62}.Bias, t, f);
    im = cast_int(im, net{62}.Mul, net{62}.Shift);
    im = nn.ReLU(im);
    
    im = nn.Pooling(im, t, f, [7, 7], 'AVG', [7, 7], 'VALID');
% --- Layer: root.classifier.1.0
    im = nn.PointwiseConv2d(im, net{63}.Weight, t, f);
    im = nn.AddBias(im, net{63}.Bias, t, f);
%     im = cast_int(im, net{63}.Mul, net{63}.Shift);

    stat={};  % Collect desired intermediate results in stat.
end

function res = cast_int(im, mul, sft) 
%------ Uncomment to use intermediate results cast.------
%    im(im < -32768) = -32768;
%    im(im > 32767) = 32767;
%-------------------- Comment end. ----------------------
    im = im * mul;
    im = bitshift(im, -sft);
    im(im > 127) = 127;
    im(im < -128) = -128;
    res = im;
end
