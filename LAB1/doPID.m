function [ error ] = doPID( paras )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

sim_len=1200;
% 
% K=38;
% Ti=1/12;
% Td=3;
% Czas probkowania
T=1;
error=0;

% Parametry wygodnego, dyskretnego PIDa
r0=paras(1)*(1+T/(2*paras(2))+paras(3)/T);
r1=paras(1)*(T/(2*paras(2))-(2*paras(3)/T)-1);
r2=paras(1)*paras(3)/T;

Y=zeros(sim_len,1);
U=zeros(sim_len,1);
e=zeros(sim_len,1);
y=zeros(sim_len,1);
u=zeros(sim_len,1);
Yzad=zeros(sim_len,1);

Ypp=33;
Upp=29;

Y(1:11)=33;
U(1:11)=29;

kk=linspace(1,sim_len,sim_len)';

Yzad(1:29)=33;
Yzad(30:sim_len/3-1)=40;
Yzad(sim_len/3:2*sim_len/3-1)=30;
Yzad(2*sim_len/3:sim_len)=40;


% U w przedziale 1.2:2.8; u w przedziale -0.8:0.8
Umin=0;
Umax=100;
umin=Umin-Upp;
umax=Umax-Upp;


for k=12:sim_len
    y(k)=symulacja_obiektuLAB(u, y, k);
    Y(k)=y(k)+Ypp;
    e(k)=Yzad(k)-Y(k);
    error=error+e(k)^2;
    
    u_wyliczone=r2*e(k-2)+r1*e(k-1)+r0*e(k)+u(k-1);
%     u_wyliczone=1;
    % Rzutowanie ograniczen na wartosc sterowania
    if u_wyliczone<umin
        u_wyliczone=umin;
    elseif u_wyliczone>umax
        u_wyliczone=umax;
    end
    u(k)=u_wyliczone;
    U(k)=u_wyliczone+Upp;
    
end
plot(Y);
hold on;
plot(Yzad,'--');
hold on;
title(num2str(error));
plot (U);
hold off;

% T=table(kk,Y);
% name="PROJ1_PID_EXP K="+string(K)+" Ti="+string(Ti)+" Td="+string(Td)+"error= "+string(error)+".txt";
% % name="PROJ1_PID_OPT K="+string(K)+" Ti="+string(Ti)+" Td"+string(Td);
% writetable(T,char(name),'WriteVariableNames',false,'Delimiter','space');
% T=table(kk,U);
% name="PROJ1_PID_EXP_STER K="+string(K)+" Ti="+string(Ti)+" Td="+string(Td)+"error= "+string(error)+".txt";
% writetable(T,char(name),'WriteVariableNames',false,'Delimiter','space');