% Author: Zhao Mingxin
% Date:   2018/11/25
% Description: MobileNet Total Runtime Test.

% NOTE: Because we only want to get total runtime and don't care about actual 
% inference result, so I just generate random network parameters and forward 
% 28 layers once to get the total runtime. This code consumes about 3~5 
% minutes on PC with Intel Core i5-8400 CPU and 16.0GB RAM.

% PROBLEM: The total time will increase when you use longer word-length.
% Accoding to my observation, using 32 bit word-length will cost more time 
% than 64 bit, which is a confusing result.

wordlen =16;
fraclen =8;
f = fimath('CastBeforeSum',0, 'OverflowMode', 'Saturate', 'RoundMode', 'floor', ... 
'ProductMode', 'SpecifyPrecision', 'SumMode', 'SpecifyPrecision', 'ProductWordLength',2*wordlen, ...
'ProductFractionLength',2*fraclen, 'SumWordLength', 2*wordlen, 'SumFractionLength', 2*fraclen);
t = numerictype('WordLength', wordlen, 'FractionLength',fraclen);
roundm = 'floor';

nn = FAST.ActiveSession('SingleCore');
% MobileNet Begin
profile on

tic
% Layer 1
net = nn.Conv2d(fi(randi(64,224,224,3),t,f),fi(randi(64,3,3,3,32),t,f),t,f,[2,2],'SAME');
net = nn.AddBias(net,fi(randi(64,1,32)),t,f);
net = nn.ReLU(net);

t1 = toc;
fprintf('Layer %d completed in %fs ... \n',1,t1);
% Layer 2
net = nn.DepthwiseConv2d(net,fi(randi(64,3,3,32,1)),t,f,[1,1],'SAME');
net = nn.AddBias(net,fi(randi(64,1,32)),t,f);
net = nn.ReLU(net);

t2 = toc;
fprintf('Layer %d completed in %fs ... \n',2,t2-t1);
% Layer 3
net = nn.Conv2d(net,fi(randi(64,1,1,32,64),t,f),t,f,[1,1],'SAME');
net = nn.AddBias(net,fi(randi(64,1,64)),t,f);
net = nn.ReLU(net);

t3 = toc;
fprintf('Layer %d completed in %fs ... \n',3,t3-t2);
% Layer 4
net = nn.DepthwiseConv2d(net,fi(randi(64,3,3,64,1)),t,f,[2,2],'SAME');
net = nn.AddBias(net,fi(randi(64,1,64)),t,f);
net = nn.ReLU(net);

t4 = toc;
fprintf('Layer %d completed in %fs ... \n',4,t4-t3);
% Layer 5
net = nn.Conv2d(net,fi(randi(64,1,1,64,128),t,f),t,f,[1,1],'SAME');
net = nn.AddBias(net,fi(randi(64,1,128)),t,f);
net = nn.ReLU(net);

t5 = toc;
fprintf('Layer %d completed in %fs ... \n',5,t5-t4);
% Layer 6
net = nn.DepthwiseConv2d(net,fi(randi(64,3,3,128,1)),t,f,[1,1],'SAME');
net = nn.AddBias(net,fi(randi(64,1,128)),t,f);
net = nn.ReLU(net);

t6 = toc;
fprintf('Layer %d completed in %fs ... \n',6,t6-t5);
% Layer 7
net = nn.Conv2d(net,fi(randi(64,1,1,128,128),t,f),t,f,[1,1],'SAME');
net = nn.AddBias(net,fi(randi(64,1,128)),t,f);
net = nn.ReLU(net);

t7 = toc;
fprintf('Layer %d completed in %fs ... \n',7,t7-t6);
% Layer 8
net = nn.DepthwiseConv2d(net,fi(randi(64,3,3,128,1)),t,f,[2,2],'SAME');
net = nn.AddBias(net,fi(randi(64,1,128)),t,f);
net = nn.ReLU(net);

t8 = toc;
fprintf('Layer %d completed in %fs ... \n',8,t8-t7);
% Layer 9
net = nn.Conv2d(net,fi(randi(64,1,1,128,256),t,f),t,f,[1,1],'SAME');
net = nn.AddBias(net,fi(randi(64,1,256)),t,f);
net = nn.ReLU(net);

t9 = toc;
fprintf('Layer %d completed in %fs ... \n',9,t9-t8);
% Layer 10
net = nn.DepthwiseConv2d(net,fi(randi(64,3,3,256,1)),t,f,[1,1],'SAME');
net = nn.AddBias(net,fi(randi(64,1,256)),t,f);
net = nn.ReLU(net);

t10 = toc;
fprintf('Layer %d completed in %fs ... \n',10,t10-t9);
% Layer 11
net = nn.Conv2d(net,fi(randi(64,1,1,256,256),t,f),t,f,[1,1],'SAME');
net = nn.AddBias(net,fi(randi(64,1,256)),t,f);
net = nn.ReLU(net);

t11 = toc;
fprintf('Layer %d completed in %fs ... \n',11,t11-t10);
% Layer 12
net = nn.DepthwiseConv2d(net,fi(randi(64,3,3,256,1)),t,f,[2,2],'SAME');
net = nn.AddBias(net,fi(randi(64,1,256)),t,f);
net = nn.ReLU(net);

t12 = toc;
fprintf('Layer %d completed in %fs ... \n',12,t12-t11);
% Layer 13
net = nn.Conv2d(net,fi(randi(64,1,1,256,512),t,f),t,f,[1,1],'SAME');
net = nn.AddBias(net,fi(randi(64,1,512)),t,f);
net = nn.ReLU(net);

t13 = toc;
fprintf('Layer %d completed in %fs ... \n',13,t13-t12);
% Layer 14~23
tb=t13;
for i=1:5
    net = nn.DepthwiseConv2d(net,fi(randi(64,3,3,512,1)),t,f,[1,1],'SAME');
    net = nn.AddBias(net,fi(randi(64,1,512)),t,f);
    net = nn.ReLU(net);
    ta = toc;
    fprintf('Layer %d completed in %fs ... \n',2*(i-1)+14,ta-tb);
    
    net = nn.Conv2d(net,fi(randi(64,1,1,512,512),t,f),t,f,[1,1],'SAME');
    net = nn.AddBias(net,fi(randi(64,1,512)),t,f);
    net = nn.ReLU(net);
    tb = toc;
    fprintf('Layer %d completed in %fs ... \n',2*(i-1)+15,tb-ta);
end

% Layer 24
net = nn.DepthwiseConv2d(net,fi(randi(64,3,3,512,1)),t,f,[2,2],'SAME');
net = nn.AddBias(net,fi(randi(64,1,512)),t,f);
net = nn.ReLU(net);
t24 = toc;
fprintf('Layer %d completed in %fs ... \n',24,t24-tb);
% Layer 25
net = nn.Conv2d(net,fi(randi(64,1,1,512,1024),t,f),t,f,[1,1],'SAME');
net = nn.AddBias(net,fi(randi(64,1,1024)),t,f);
net = nn.ReLU(net);
t25 = toc;
fprintf('Layer %d completed in %fs ... \n',25,t25-t24);
% Layer 26
net = nn.DepthwiseConv2d(net,fi(randi(64,3,3,1024,1)),t,f,[1,1],'SAME');
net = nn.AddBias(net,fi(randi(64,1,1024)),t,f);
net = nn.ReLU(net);
t26 = toc;
fprintf('Layer %d completed in %fs ... \n',26,t26-t25);
% Layer 27
net = nn.Conv2d(net,fi(randi(64,1,1,1024,1024),t,f),t,f,[1,1],'SAME');
net = nn.AddBias(net,fi(randi(64,1,1024)),t,f);
net = nn.ReLU(net);
t27 = toc;
fprintf('Layer %d completed in %fs ... \n',27,t27-t26);
% Layer 28
net = nn.Pooling(net,t,f,[7,7],'AVG',[1,1],'VALID');
net = nn.AddBias(net,fi(randi(64,1,1024)),t,f);
net = nn.ReLU(net);
t28 = toc;
fprintf('Layer %d completed in %fs ... \n',28,t28-t27);
% Layer Ouput
net = reshape(net,[],1024);
net = net*fi(randi(64,1024,1000),t,f);
% net = nn.AddBias(net,fi(randi(64,1,1000)),t,f);
out = nn.ReLU(net);
tot = toc;
fprintf('Layer %s completed in %fs ... \n','Output',tot-t28);
% MobileNet End

profile viewer