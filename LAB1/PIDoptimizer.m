

x0=[10,100,1];
lb=[0.01,0.01,0.01];
ub=[30,1000,100];
paras=fmincon(@doPID,x0,[],[],[],[],lb,ub);
