
T1=42;
T2=43;
K=0.2859;
Td=3;

alfa1=exp(-(1/T1));
alfa2=exp(-(1/T2));
a1=-alfa1-alfa2;
a2=alfa1*alfa2;
b1=(K/(T1-T2))*(T1*(1-alfa1)-T2*(1-alfa2));
b2=(K/(T1-T2))*(alfa1*T2*(1-alfa2)-alfa2*T1*(1-alfa1));


U=zeros(length(step_resp)+Td+2,1);
Y=zeros(length(step_resp)+Td+2,1);
U(1:Td+2)=0;
U(Td+3:end)=1;
Y(1:Td+2)=0;


% skok w chwili Td+2

for k=Td+3:length(step_resp)+Td+2
    Y(k)=b1*U(k-Td-1)+b2*U(k-Td-2)-a1*Y(k-1)-a2*Y(k-2);
    error=error+(Y(k)-step_resp(k-Td-2,1))^2;
end



T=table(k,Y(Td+3:end),step_resp);
writetable(T,'aproximation','WriteVariableNames',false,'Delimiter','space');
save('approx.mat','Y');

plot(k,Y(Td+3:end),k,step_resp)