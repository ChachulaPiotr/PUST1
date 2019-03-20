function [ error ] = doDMC( paras )   % Tylko dla auto

manual=1;

% Tylko dla auto
N=round(paras(1));
Nu=round(paras(2));
lambda=paras(3);

load StepResponse.mat;

% Tylko dla manual
% eNs=linspace(25,100,4);
% eNus=[linspace(5,20,4)];
% lambdas=[0.2,1,5];

% Ucinamy moment 0 zeby latwiej bylo operowac
stepResp=stepResp(2:end);

% Pobieramy horyzont dynamiki obiektu
D=length(stepResp);

% paras = [N, Nu, lambda]
% Wartosci s¹ zaokr¹glane, zeby fmincon zwraca³ wartoœci ca³kowite
% N=round(N);
% Nu=round(Nu);

% Tylko dla manual
% for i=1:length(eNs)
%     N=eNs(i);
%     for j=1:length(eNus)
%         Nu=eNus(j);
%         for k=1:length(lambdas)
%             lambda=lambdas(k);
            
error=0;

% Inicjalizacja macierzy M
M=zeros(N,Nu);
for j=1:Nu
    for i=j:N
        M(i,j)=stepResp(i-j+1);
    end
end

% Inicjalizacja macierzy Mp
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

% Liczymy macierze K, Ke, Ku
K=(M'*M+lambda*lambda*eye(Nu))^(-1)*M';
Ke=sum(K(1,:));
Ku=K(1,:)*Mp;

% Inicjalizujemy macierze przechowujace zmienne

sim_len=1200;
dUp=zeros(D-1,1);
Y=zeros(sim_len,1);
U=zeros(sim_len,1);
du=zeros(sim_len,1);
e=zeros(sim_len,1);
y=zeros(sim_len,1);
u=zeros(sim_len,1);
Yzad=zeros(sim_len,1);
kk=linspace(1,sim_len,sim_len)';

% Tworzymy horyzont wartosci zadanej
Yzad(1:D+11)=0.8;
Yzad(D+12:sim_len/3-1)=1.0;
Yzad(sim_len/3:2*sim_len/3-1)=0.6;
Yzad(2*sim_len/3:sim_len)=0.7;

% Ustalamy wartosci przed rozpoczeciem symulacji na wartosci w punktu pracy
Ypp=0.8;
Upp=2.0;
Y(1:D+11)=0.8;
U(1:D+11)=2.0;

% Wprowadzamy ograniczenia
Umin=1.2;
Umax=2.8;
deltaumax=0.25;
deltaumin=-0.25;
umin=Umin-Upp;
umax=Umax-Upp;

% Poczatek symulacji - zaczynamy w tej chwili w celu uproszczenia
% pozyskiwania wektora dUp
for k=D+12:sim_len
    % Symulujemy wyjscie obiektu
    Y(k)=symulacja_obiektu4Y(U(k-10),U(k-11),Y(k-1),Y(k-2));
    % Rzutujemy wartosc wyjscia wzgledem punktu pracy
    y(k)=Y(k)-Ypp;
    % Liczymy uchyb i uaktualniamy wspolczynnik bledu
    e(k)=Yzad(k)-Y(k);
    error=error+e(k)^2;
    % Pozyskujemy wektor dUp z wektora du
    dUp=du(k-D+1:k-1);
    dUp=flip(dUp);
    % Liczymy wartosc zmiany sterowania
    du_wyliczone=Ke*e(k)-Ku*dUp;

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
    % Liczymy wartosc sterowania i ja rzutujemy wzgledem punktu pracy
    u(k)=u(k-1)+du(k);
    U(k)=u(k)+Upp;
end
    
plot(Y);
hold on;
plot(Yzad,'--');
hold on;
title(num2str(error));
% plot (U);
hold off;

Tb=table(kk,Yzad);
writetable(Tb,'PROJ1_4_YzadDMC','WriteVariableNames',false,'Delimiter','space');


T=table(kk,Y);
TT=table(kk,U);
if manual==1
name="APROJ1_DMC_EXP_N="+string(N)+"_Nu="+string(Nu)+"_lambda="+string(lambda)+"error=_"+string(error)+".txt";
writetable(T,char(name),'WriteVariableNames',false,'Delimiter','space');
name2="APROJ1_DMC_EXP_STER_N="+string(N)+"_Nu="+string(Nu)+"_lambda="+string(lambda)+"error=_"+string(error)+".txt";
writetable(TT,char(name2),'WriteVariableNames',false,'Delimiter','space');

end

% Tylko dla manual
%         end
%     end
% end
save ('temp_table1.mat', 'T');
save ('temp_table2.mat','TT');
