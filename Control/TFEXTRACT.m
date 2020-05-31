
y = zeros(size(InputAngle, 3),1);
y(:,1) = InputAngle(1,1,:);

u = zeros(size(OutputAngle, 3),1);
u(:,1) = OutputAngle(1,1,:);

%%
data1 = iddata(u,y,0.0005);
%%
data2 = iddata(u,y,0.0005);
%%
data3 = iddata(u,y,0.0005);
%%
TF11 = tfest(data1,2,1);
TF12 = tfest(data1,2,2);
TF2 = tfest(data1,3,1);
TF3 = tfest(data1,3,2);
%%
t = 0:0.05:5;
t=t';

