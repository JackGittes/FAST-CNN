clear model tmp shipim data mem_tab
model = load('Test/ShipNet_VAL_ACC_95.15.mat');
shipim = load('Test/shipImg.mat');

model = model.model;
shipim = shipim.im;

tmp = struct;
tmp.kernel = cell(1,3);
tmp.bias = cell(1,4);
for i =1:3
    tmp.kernel{i}=model(i).weight;
    tmp.bias{i}=model(i).bias;
end
tmp.bias{4}=model(6).bias;
tmp.FC = model(6).weight;

% profile on 
[data,mem_tab,b_m]=FAST.VP.prepareData(shipim,tmp,model);
% profile viewer
[h,~] = size(data);
data = [data;repmat('0',[2048-h,256])];
Byte_Data = [uint8(b_m.data);zeros(2048-h,32)];
TaskData_Vec_UINT8 = reshape(fliplr(Byte_Data)',1,[]);

fileID = fopen('./Test/taskdata.dat','w');
fprintf(fileID,data);
fclose(fileID);

fileID = fopen('./Test/taskdata.bin','w');
fwrite(fileID,TaskData_Vec_UINT8);
fclose(fileID);

FAST.VP.test.genTaskdata(data);