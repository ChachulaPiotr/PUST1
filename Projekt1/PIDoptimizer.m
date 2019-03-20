

x0=[1,1,1];
lb=[0.01,0.01,0.01];
ub=[50,50,50];
[paras,error]=fmincon(@doPID,x0,[],[],[],[],lb,ub);

K=paras(1);
Ti=paras(2);
Td=paras(3);

load('temp_table1.mat');
load('temp_table2.mat');

name="PROJ1_PID_OPT K="+string(K)+" Ti="+string(Ti)+" Td="+string(Td)+"error= "+string(error)+".txt";
name2="PROJ1_PID_OPT_STER K="+string(K)+" Ti="+string(Ti)+" Td="+string(Td)+"error= "+string(error)+".txt";
writetable(Tb,char(name),'WriteVariableNames',false,'Delimiter','space');
writetable(TT,char(name2),'WriteVariableNames',false,'Delimiter','space');

delete('temp_table1.mat');
delete('temp_table2.mat');