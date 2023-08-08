%written by Reyhane Hadipour
%introduction to intelligent systems Project

load input1
load SOC1

for i=1:2:2100
    input1(i,:)=[];
    SOC1(:,i)=[];
    size(input1)
end
for i=1:2:1400
    input1(i,:)=[];
    SOC1(:,i)=[];
    size(input1)
end
% for i=1:2:800
%     input1(i,:)=[];
%     SOC1(:,i)=[];
%     size(input1)
% end
% for i=1:2:600
%     input1(i,:)=[];
%     SOC1(:,i)=[];
%     size(input1)
% end
% for i=1:2:400
%     input1(i,:)=[];
%     SOC1(:,i)=[];
%     size(input1)
% end
% for i=1:2:300
%     input1(i,:)=[];
%     SOC1(:,i)=[];
%     size(input1)
% end
% for i=1:2:200
%     input1(i,:)=[];
%     SOC1(:,i)=[];
%     size(input1)
% end
% for i=1:2:150
%     input1(i,:)=[];
%     SOC1(:,i)=[];
%     size(input1)
% end
% for i=1:2:100
%     input1(i,:)=[];
%     SOC1(:,i)=[];
%     size(input1)
% end
% for i=1:2:70
%     input1(i,:)=[];
%     SOC1(:,i)=[];
%     size(input1)
% end
% for i=1:2:50
%     input1(i,:)=[];
%     SOC1(:,i)=[];
%     size(input1)
% end
% for i=1:2:40
%     input1(i,:)=[];
%     SOC1(:,i)=[];
%     size(input1)
% end
net = newrb(input1',SOC1,4)
%Shad = sim(net,input2');
%plot(SOC2)
hold on 
grid on
plot(Shad,'r')