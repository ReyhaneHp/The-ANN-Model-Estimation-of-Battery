%written by Reyhane Hadipour
%introduction to intelligent systems Project

function [perfomanc,Y_hat_total]=sim_lolimot(Models_data,W,datainput,dataoutput)
[N,temp]=size(datainput);
number_input=temp;
[temp,number_output]=size(dataoutput);
[Model temp]=size(Models_data);
mu=ones(N,Model);
Yhat=ones(N,Model);
phit=ones(N,Model);
X=[ones(N,1),datainput];
 for i=1:Model
     Yhat(:,i)=X*W(:,i);
     
     for j=1:number_input 
        mu(:,i)=mu(:,i).*gaussmf(datainput(:,j),[Models_data(i,2*number_input+j)/3 Models_data(i,number_input+j)]);
     end     
 end
  zegma_mu=(sum(mu.')).';
  for i=1:Model
     phit(:,i)=mu(:,i)./zegma_mu;
 end
Y_hat_total=sum((Yhat.*phit).').';
perfomanc=mse(Y_hat_total-dataoutput);