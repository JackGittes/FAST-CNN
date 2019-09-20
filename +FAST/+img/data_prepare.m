data = open('model_adj.mat');
image =imread('timg1.jpg');
wordlen =8;
fraclen =0;
fs = fimath('CastBeforeSum',0, 'OverflowMode', 'Saturate', 'RoundMode', 'floor', ... 
'ProductMode', 'SpecifyPrecision', 'SumMode', 'SpecifyPrecision', 'ProductWordLength',wordlen, ...
'ProductFractionLength',fraclen, 'SumWordLength', wordlen, 'SumFractionLength', fraclen);
fr = fimath('CastBeforeSum',0, 'OverflowMode', 'Saturate', 'RoundMode', 'floor', ... 
'ProductMode', 'SpecifyPrecision', 'SumMode', 'SpecifyPrecision', 'ProductWordLength',2*wordlen, ...
'ProductFractionLength',2*fraclen, 'SumWordLength', 2*wordlen, 'SumFractionLength', 2*fraclen);
ts = numerictype('WordLength', wordlen, 'FractionLength',fraclen);
tr = numerictype('WordLength', 2*wordlen, 'FractionLength',2*fraclen);
image =bitshift(image,-1);
image = fi(image,ts,fs);
temp=zeros(1,16384);
cnt=0;
for i=1:32:97
    for j=1:32:97
        k = reshape(image(i:i+31,j:j+31),1,1024);
        temp(1,cnt*1024+1:(cnt+1)*1024)=k;
        cnt=cnt+1;
    end
end
image =temp;
kernel_sobel=[1 0 2 0 1 0 0 0 0 0 0 0 -1 0 -2 0 -1 0 1 0 0 0 -1 0 2 0 0 0 -2 0 1 0 0 0 -1 0];
layer1_kernel=data.net.layers{1,1}.weights{1,1};
layer1_bias=data.net.layers{1,1}.weights{1,2};
weight1=int8(zeros(4,18));
for i=1:1:4
    temp1 = reshape(layer1_kernel(:,:,1,2*i-1)',1,9);
    temp2 = reshape(layer1_kernel(:,:,1,2*i)',1,9);
    temp =[temp1;temp2];
    temp= reshape(temp,1,18);
    weight1(i,:)=temp;
end
layer2_kernel=data.net.layers{1,4}.weights{1,1};
layer2_bias=data.net.layers{1,4}.weights{1,2};
weight2=int8(zeros(64,18));
for i=1:2:15
    for j=1:1:8
        temp1 = reshape(layer2_kernel(:,:,j,i)',1,9);
        temp2 = reshape(layer2_kernel(:,:,j,i+1)',1,9);
        temp =[temp1;temp2];
        temp= reshape(temp,1,18);
        weight2(i*4+j-4,:)=temp;
    end
end
layer3_kernel=data.net.layers{1,7}.weights{1,1};
layer3_bias=data.net.layers{1,7}.weights{1,2};
weight3=int8(zeros(128,18));
for i=1:2:16
    for j=1:1:16
        temp1 = reshape(layer3_kernel(:,:,j,i)',1,9);
        temp2 = reshape(layer3_kernel(:,:,j,i+1)',1,9);
        temp =[temp1;temp2];
        temp= reshape(temp,1,18);
        weight3(i*8+j-8,:)=temp;
    end
end
layerf_kernel=data.net.layers{1,11}.weights{1,1};
layerf_bias=data.net.layers{1,11}.weights{1,2};
weightf=int8(zeros(48,2));
tpz=zeros(1,1);
for i=1:1:3
    for j=1:1:16
        temp = layerf_kernel(:,:,j,i)';
        temp = [temp,tpz];
        weightf(i*16+j-16,:)=temp;
    end
end
weight = [weight1; weight2;weight3];
weight = int8([kernel_sobel,reshape(weight',1,3528), reshape(weightf',1,96)]);
bias=[layer1_bias,layer2_bias,layer3_bias,layerf_bias];
temp1=zeros(1,43);temp2=zeros(1,43);
for i=1:1:43
    if bias(i)>=0
        temp1(i)=rem(bias(i),256);
        temp2(i)=floor(bias(i)/256);
    else
        x = 65536 + bias(i);
        temp1(i)=rem(x,256);
        temp2(i)=floor(x/256);
    end
end
bias=reshape([temp1;temp2],1,86);
kernal_data=single(zeros(1,65536));
% (1,1:16384)=image;
kernal_data(1,16385:20044)= weight;
kernal_data(1,20481:20566)=bias;
for i=1:1:20566
    if  kernal_data(1,i)<0
        kernal_data(1,i)=uint8(kernal_data(1,i)+256);
    end
end
result=dec2bin(uint8(kernal_data),8);
% kernal_data=reshape(kernal_data',256,256)';
name='taskdata.dat';
fid=fopen(name,'wt');
for i=1:1:2048
    for j=32:-1:1
        fprintf(fid,'%s',result((i-1)*32+j,:));
    end
    fprintf(fid,'\n');
end
fclose(fid);
