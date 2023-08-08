%written by Reyhane Hadipour
%introduction to intelligent systems Project

function [models_data,Model_output,W]=train_lolimot(datainput_train,dataoutput_train,datainput_test,dataoutput_test,input_range,num_output,neuron_max,goal_perf)

clc
[N,temp]=size(datainput_train);
[N_test,temp]=size(datainput_test);
X=[ones(N,1),datainput_train];
Y=dataoutput_train;
phi=ones(N,1);
[P temp]=size(input_range);

for i=1:P
    max_u(1,i)=input_range(i,2);
    min_u(1,i)=input_range(i,1);
end

models_data=[min_u,(min_u+max_u)./2,max_u-min_u];

teta_hat=pinv(X.'*X)*X.'*Y;

Y_hat=X*teta_hat;
error1=Y-Y_hat;
models_data(1,3*P+1)=sse(error1);

num_model_break=1;
M=1;
error_train(M,1)=sse(error1);
error_test(M,1)=sim_lolimot(models_data,teta_hat,datainput_test,dataoutput_test);

while (M<neuron_max)

    n=num_model_break;
    for i=1:P
        for j=1:P
            if  i==j
                c1(i,j)=models_data(n,j)+models_data(n,2*P+j)/4;
                c2(i,j)=models_data(n,j)+3*models_data(n,2*P+j)/4;
                delta1(i,j)=models_data(n,2*P+j)/2;
                delta2(i,j)=models_data(n,2*P+j)/2;
                min1(i,j)=models_data(n,j);
                min2(i,j)=models_data(n,j)+models_data(n,2*P+j)/2;
            else 
                c1(i,j)=models_data(n,P+j);
                c2(i,j)=models_data(n,P+j);
                delta1(i,j)=models_data(n,2*P+j);
                delta2(i,j)=models_data(n,2*P+j);
                min1(i,j)=models_data(n,j);
                min2(i,j)=models_data(n,j);
            end 
        end  
    end 
    zegma1=delta1/3;
    zegma2=delta2/3;
    
    gauss1=ones(N,P);
    gauss2=ones(N,P);
    temp1=ones(N,1);
    temp2=ones(N,1);
    for i=1:P
        temp1=ones(N,1);
        temp2=ones(N,1);
        for j=1:P
            temp1=temp1.*gaussmf(datainput_train(:,j),[zegma1(i,j) c1(i,j)]);
            temp2=temp2.*gaussmf(datainput_train(:,j),[zegma2(i,j) c2(i,j)]);
        end 
        gauss1(:,i)=temp1;
        gauss2(:,i)=temp2;
    end
    
    for i=1:P
        mu(:,n,i)=gauss1(:,i);
        mu(:,M+1,i)=gauss2(:,i);
    end
    zegma_mu=ones(N,P);
    for i=1:P
        zegma_mu(:,i)=(sum(mu(:,:,i).')).';
    end
    for i=1:P
        for j=1:M+1
            phi(:,j,i)=mu(:,j,i)./zegma_mu(:,i);
        end

        w1(:,i)=pinv(X.'*diag(phi(:,n,i))*X)*X.'*diag(phi(:,n,i))*Y;
        w2(:,i)=pinv(X.'*diag(phi(:,M+1,i))*X)*X.'*diag(phi(:,M+1,i))*Y;
            
        Y_hat1(:,i)=X*w1(:,i);
        Y_hat2(:,i)=X*w2(:,i); 
        yhat_break_model(:,i)=phi(:,n,i).*Y_hat1(:,i)+phi(:,M+1,i).*Y_hat2(:,i);
        Y_total(:,i)=yhat_break_model(:,i);
        for j=1:M
            if (j~=n)
                Y_total(:,i)=Y_total(:,i)+save_yhat(:,j).*phi(:,j,i);
            end 
        end
        perf(:,i)=mse(Y_total(:,i)-Y) ;
    end
    
    [perf_train cut]=min(perf); 
    perf_n=(Y_hat1(:,cut)-Y).'*diag(phi(:,n,cut))*(Y_hat1(:,cut)-Y);
    perf_M_pluse_1=(Y_hat2(:,cut)-Y).'*diag(phi(:,M+1,i))*(Y_hat2(:,cut)-Y);
    models_data(n,:)=[min1(cut,:),c1(cut,:),delta1(cut,:),perf_n];
    models_data(M+1,:)=[min2(cut,:),c2(cut,:),delta2(cut,:),perf_M_pluse_1];
    W(:,n)=w1(:,cut);
    W(:,M+1)=w2(:,cut);
    save_yhat(:,n)=Y_hat1(:,cut);
    save_yhat(:,M+1)=Y_hat2(:,cut);
    for i=1:P
        mu(:,:,i)=mu(:,:,cut);
    end
    Model_output=Y_total(:,cut);
    M=M+1
    error_train(M,1)=sim_lolimot(models_data,W,datainput_train,Y);
    error_test(M,1)=sim_lolimot(models_data,W,datainput_test,dataoutput_test);
    
    if ((perf_train<goal_perf))
        break;
    end
    [max_2,num_model_break]=max(models_data(:,3*P+1));

end 

plot([1:M],error_train(:,1),'b')
hold on
plot([1:M],error_test(:,1),'r')
title('Training MSE & Test MSE')
xlabel('Number of Neurons')
legend('Training Error','Test Error')
grid