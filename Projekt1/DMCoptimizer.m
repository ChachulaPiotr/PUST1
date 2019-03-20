
x0=[20,20,100];
lb=[1,1,0.01];
ub=[120,120,100];
[paras,error]=fmincon(@doDMC,x0,[],[],[],[],lb,ub);

N=paras(1);
Nu=paras(2);
lambda=paras(3);

load('temp_table1.mat');
load('temp_table2.mat');
name="PROJ1_DMC_OPT N="+string(N)+" Nu="+string(Nu)+" lambda="+string(lambda)+"error= "+string(error)+".txt";
writetable(T,char(name),'WriteVariableNames',false,'Delimiter','space');
name2="PROJ1_DMC_OPT_STER N="+string(N)+" Nu="+string(Nu)+" lambda="+string(lambda)+"error= "+string(error)+".txt";
writetable(TT,char(name2),'WriteVariableNames',false,'Delimiter','space');

delete('temp_table1.mat');
delete('temp_table2.mat');