%written by Reyhane Hadipour
%introduction to intelligent systems Project
%---------------------------------------------%
clear all; clc;close all
%---------------- Data Set1 ------------------%
load I1_2
load V1_2
T = 0.7;
SOC0 = .7*3600;
[M1 N1] = size(I1_2);
As1(1) = I1_2(1)*T;
SOC(1) = SOC0-As1(1);
i = 2;
while SOC(i-1)>0
        As1(i) = As1(i-1) + I1_2(i)*T;
    SOC(i) = (SOC0 - As1(i));
    dV1(i) = (V1_2(i)-V1_2(i-1))/T;
    i = i+1;
end
SOC1 = SOC/SOC0*100;
V1 = V1_2(1:i-1);
I1 = I1_2(1:i-1);
input1 = [I1' V1' dV1'];
output1=SOC1
%------------- Data Set 2 -----------------
load I0_7
load V0_7
[M N] = size(I0_7);
As2(1) = I0_7(1)*T;
S2(1) = SOC0-As2(1);
i = 2;
while S2(i-1)>0
    As2(i) = As2(i-1) + I0_7(i)*T;
    S2(i) = (SOC0 - As2(i));
    dV2(i) = (V0_7(i)-V0_7(i-1))/T;
    i = i+1;
end
SOC2 = S2/SOC0*100;
V2 = V0_7(1:i-1);
I2 = I0_7(1:i-1);
input2 = [I2' V2' dV2'];
output2=SOC2
%------------- Data Set 3 -----------------
load I1_5
load V1_5
[M N] = size(I1_5);
As3(1) = I1_5(1)*T;
S3(1) = SOC0-As3(1);
i = 2;
while S3(i-1)>0
    As3(i) = As3(i-1) + I1_5(i)*T;
    S3(i) = (SOC0 - As3(i));
    dV3(i) = (V1_5(i)-V1_5(i-1))/T;
    i = i+1;
end
SOC3 = S3/SOC0*100;
V3 = V1_5(1:i-1);
I3 = I1_5(1:i-1);
input3 = [I3' V3' dV3'];
output3=SOC3
%------------- Data Set 4 (test) -----------------
load I_PRBS
load V_PRBS
[M N] = size(I_PRBS);
As4(1) = I_PRBS(1)*T;
S4(1) = SOC0-As4(1);
i = 2;
while S4(i-1)>0
    As4(i) = As4(i-1) + I_PRBS(i)*T;
    S4(i) = (SOC0 - As4(i));
    dV4(i) = (V_PRBS(i)-V_PRBS(i-1))/T;
    i = i+1;
end
SOC4 = S4/SOC0*100;
V4 = V_PRBS(1:i-1);
I4 = I_PRBS(1:i-1);
input4 = [I4' V4' dV4'];
output4=SOC4

save input1 input1
save output1 output1

save input2 input2
save output2 output2

save input3 input3
save output3 output3

save input4 input4
save output4 output4




% %---------------Training---------------------
input= [input1;input2;input3;input4];
SOC = [SOC1 SOC2 SOC3 SOC4];
net = newff(input',SOC,10);
net.trainParam.epochs = 50;
net.divideParam.trainInd = [1:10714];
net.divideParam.testInd = [10714+1:14186];
net = train(net,input',SOC);
Shad = sim(net,input4');
plot(SOC3)
hold on 
grid on
plot(Shad,'r')

