
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

load normal_step_response.mat;

% Ucinamy moment 0 zeby latwiej bylo operowac
stepResp=stepResp(2:end);

D=length(step_response);
N=80;
Nu=60;
lambda=1;

    addpath('F:\SerialCommunication'); % add a path to the functions
    initSerialControl COM3 % initialise com port


error=0;

M=zeros(N,Nu);
for j=1:Nu
    for i=j:N
        M(i,j)=stepResp(i-j+1);
    end
end

Mp=zeros(N,D-1);
for i=1:N
    for j=1:D-1
        if (i+j)<=D
            Mp(i,j)=stepResp(i+j)-stepResp(j);
        else
            Mp(i,j)=stepResp(end)-stepResp(j);
        end
    end
end


K=(M'*M+lambda*lambda*eye(Nu))^(-1)*M';
Ke=sum(K(1,:));
Ku=K(1,:)*Mp;

dUp=zeros(D-1,1);
        
% Koniec czesci przedregulacyjnej

sim_len=1800;

Y=zeros(sim_len,1);
U=zeros(sim_len,1);
du=zeros(sim_len,1);
e=zeros(sim_len,1);
y=zeros(sim_len,1);
u=zeros(sim_len,1);
Yzad=zeros(sim_len,1);


Yzad(1:sim_len/3-1)=37.0;
Yzad(sim_len/3:2*sim_len/3-1)=33.0;
Yzad(2*sim_len/3:sim_len)=34.5;


Ypp=34.5;
Upp=29.0;

Y(1:D+20)=0.8;
U(1:D+20)=2.0;

kk=linspace(1,sim_len,sim_len)';

Umin=1.2;
Umax=2.8;
deltaumax=0.25;
deltaumin=-0.25;
umin=Umin-Upp;
umax=Umax-Upp;

% Koniec deklaracji innych waznych rzeczy


for k=D+21:sim_len
    measurements = readMeasurements(1:7); % read measurements from 1 to 1
    Y(k)=measurements(1)
    y(k)=Y(k)-Ypp;
    e(k)=Yzad(k)-Y(k);
    error=error+e(k)^2;
    
    dUp=du(k-D+1:k-1);
    du_wyliczone=Ke*e(k)-Ku*dUp;
    
%     u_wyliczone=1;
    % Rzutowanie ograniczen na wartosc sterowania
    if du_wyliczone<deltaumin
        du_wyliczone=deltaumin;
    elseif du_wyliczone>deltaumax
        du_wyliczone=deltaumax;
    end
    % Rzutowanie ograniczen na wartosc zmiany sterowania
    if du_wyliczone+u(k-1)<umin
        du_wyliczone=umin-u(k-1);
    elseif du_wyliczone+u(k-1)>umax
        du_wyliczone=umax-u(k-1);
    end
    du(k)=du_wyliczone;
    u(k)=u(k-1)+du(k);
    U(k)=u(k)+Upp;
        sendControls([ 1, 2, 3, 4, 5, 6], ... send for these elements
    [50, 0, 0, 0, U(k), 0]);  % new corresponding control valuesdisp(measurements); % process measurements

end
    
plot(Y);
hold on;
plot(Yzad,'--');
hold on;
title(num2str(error));
% plot (U);
hold off;


T=table(kk,Y);
name="LAB1_DMC_EXP N="+string(N)+" Nu="+string(Nu)+" lambda="+string(lambda)+"error= "+string(error)+".txt";
% name="PROJ1_PID_OPT K="+string(K)+" Ti="+string(Ti)+" Td"+string(Td);
writetable(T,char(name),'WriteVariableNames',false,'Delimiter','space');
T=table(kk,U);
name="LAB1_DMC_EXP_STER N="+string(N)+" Nu="+string(Nu)+" lambda="+string(lambda)+"error= "+string(error)+".txt";
writetable(T,char(name),'WriteVariableNames',false,'Delimiter','space');
