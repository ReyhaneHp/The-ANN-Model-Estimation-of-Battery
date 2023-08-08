%written by Reyhane Hadipour
%introduction to intelligent systems Project

clc;
clear;
close all;

%%
load input1;
load output1;


%%
% Normalizing output data
T1 = gen_output1; T2 = gen_output2;
T3 = gen_output3; T4 = gen_output4;
T =output1;

[gen_output1,min1,max1] = premnmx(gen_output1);
[gen_output2,min2,max2] = premnmx(gen_output2);
[gen_output3,min3,max3] = premnmx(gen_output3);
[gen_output4,min4,max4] = premnmx(gen_output4);
% 
 cut_indx=2500;
% 
% input1_tr = gen_input1(1:cut_indx)';
% output1_tr = gen_output1(1:cut_indx)';
% input1_te = gen_input1(cut_indx+1:end)';
% output1_te = gen_output1(cut_indx+1:end)';
% 
% input2_tr = gen_input2(1:cut_indx)';
% output2_tr = gen_output2(1:cut_indx)';
% input2_te = gen_input2(cut_indx+1:end)';
% output2_te = gen_output2(cut_indx+1:end)';
% 
% input3_tr = gen_input3(1:cut_indx)';
% output3_tr = gen_output3(1:cut_indx)';
% input3_te = gen_input3(cut_indx+1:end)';
% output3_te = gen_output3(cut_indx+1:end)';
% 
% input4_tr = gen_input4(1:cut_indx)';
% output4_tr = gen_output4(1:cut_indx)';
% input4_te = gen_input4(cut_indx+1:end)';
% output4_te = gen_output4(cut_indx+1:end)';

input_tr = input1(1:2500,:)';
output_tr = output1(1:2500);

input_te =input1(2501:3151,:)';
output_te =output1(2501:3151);

%%

in_reg = 3;   % Number of input regressors
out_reg = 1;  % Number of output regressors
lag = 1;      % System delay

P_tr = [];
P_te = [];

t = lag + in_reg +out_reg;

for k = lag:in_reg+lag-1
    P_tr = [P_tr ; input_tr(:,t-k:end-k)];
end
for k = 1:out_reg
    P_tr=[P_tr ; output_tr(:,t-k:end-k)];
end

for k = lag:in_reg+lag-1
    P_te = [P_te ; input_te(:,t-k:end-k)];
end

for k = 1:out_reg
    P_te = [P_te ; output_te(:,t-k:end-k)];
end

%%
T_tr = output_tr(:,t:end);
T_te = output_te(:,t:end);
T_train = T(:,t:cut_indx)';
T_test = T(:,cut_indx+1:end)';


number_of_neurons = 20;
input_range = minmax(P_tr);
number_of_outputs = 1;

[Model_data,Model_out_tr,W] = train_lolimot(P_tr',T_tr(1,:)',P_te',T_te(1,:)',input_range,number_of_outputs,number_of_neurons,0);
[Error,Model_out_te] = sim_lolimot(Model_data,W,P_te',T_te(1,:)');


MSE_tr = mse(Model_out_tr-T_tr(1,:)');
MSE_te = mse(Model_out_te-T_te(1,:)');

figure
plot(1:length(T_tr(1,:)),T_tr(1,:),'r');
hold on;
plot(1:50:length(T_tr(1,:)),Model_out_tr(1:50:end),'*')
legend('SOC GOAL','SOC estimate')
title('SOC , Input: Train Data')
xlabel('Time Samples')
  
figure
plot(1:length(T_te(1,:)),T_te(1,:),'r');
hold on;
plot(1:10:length(T_te(1,:)),Model_out_te(1:10:end),'*')
legend('SOC GOAL','SOC estimate')
title('SOC , Input: Test Data')
xlabel('Time Samples')

figure(4)
plot(1:length(T_tr),T_tr(1,:)-Model_out_tr','r')
title('error between Output train Data & Network Output for train data')
%legend('Real Output')
xlabel('Time Samples')

hold on

plot(length(T_tr)+1:length(T_tr)+length(T_te),T_te-Model_out_te','b')
title('error between Output Test Data & Network Output for test data')
%legend('Real Output')
xlabel('Time Samples')