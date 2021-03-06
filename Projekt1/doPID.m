% function [ error ] = doPID( paras )   % Tylko dla auto

% Ustawiamy dlugosc symulacji
sim_len=1200;
manual=1;

% Tylko dla auto
% K=paras(1);
% Ti=paras(2);
% Td=paras(3);

% Czas probkowania
T=1;


% Tylko dla manual
Ks=[3.2];
Tis=[18.5];
Tds=[0.001];

% Tylko dla manual
for i=1:length(Ks)
    K=Ks(i);
    for j=1:length(Tis)
        Ti=Tis(j);
        for k=1:length(Tds)
            Td=Tds(k);
            error=0;
% Parametry wygodnego, dyskretnego PIDa
r0=K*(1+T/(2*Ti)+Td/T);
r1=K*(T/(2*Ti)-(2*Td/T)-1);
r2=K*Td/T;

% Inicjalizujemy macierze przechowujace zmienne
Y=zeros(sim_len,1);
U=zeros(sim_len,1);
e=zeros(sim_len,1);
y=zeros(sim_len,1);
u=zeros(sim_len,1);
Yzad=zeros(sim_len,1);
kk=linspace(1,sim_len,sim_len)';

% Ustalamy wartosci przed rozpoczeciem symulacji na wartosci w punktu pracy
Ypp=0.8;
Upp=2.0;
Y(1:11)=Ypp;
U(1:11)=Upp;

% Tworzymy horyzont wartosci zadanej
Yzad(1:29)=0.8;
Yzad(30:sim_len/3-1)=1.0;
Yzad(sim_len/3:2*sim_len/3-1)=0.6;
Yzad(2*sim_len/3:sim_len)=0.7;

% U w przedziale 1.2:2.8; u w przedziale -0.8:0.8
Umin=1.2;
Umax=2.8;
deltaumax=0.25;
umin=Umin-Upp;
umax=Umax-Upp;


for k=12:sim_len
    % Symulujemy wyjscie obiektu    
    Y(k)=symulacja_obiektu4Y(U(k-10),U(k-11),Y(k-1),Y(k-2));
    % Rzutujemy wartosc wyjscia wzgledem punktu pracy    
    y(k)=Y(k)-Ypp;
    % Liczymy uchyb i uaktualniamy wspolczynnik bledu
    e(k)=Yzad(k)-Y(k);
    error=error+e(k)^2;
    % Liczymy wartosc sterowania    
    u_wyliczone=r2*e(k-2)+r1*e(k-1)+r0*e(k)+u(k-1);

    % Rzutowanie ograniczen na wartosc sterowania
    if u_wyliczone<umin
        u_wyliczone=umin;
    elseif u_wyliczone>umax
        u_wyliczone=umax;
    end
    % Rzutowanie ograniczen na wartosc zmiany sterowania
    if u_wyliczone-u(k-1)<-deltaumax
        u_wyliczone=u(k-1)-deltaumax;
    elseif u_wyliczone-u(k-1)>deltaumax
        u_wyliczone=u(k-1)+deltaumax;
    end
    u(k)=u_wyliczone;
    U(k)=u_wyliczone+Upp;
    
 end
% Rysujemy pogladowo
plot(Y);
hold on;
plot(Yzad,'--');
hold on;
title(num2str(error));
plot (U);
hold off;

% Tb=table(kk,Yzad);
% writetable(Tb,'PROJ1_4_YzadPID','WriteVariableNames',false,'Delimiter','space');
% 
% 
% Tb=table(kk,Y);
% TT=table(kk,U);
% if manual==1
% name="PROJ1_PID_EXP error="+string(round(error,2))+" K="+string(K)+" Ti="+string(Ti)+" Td="+string(Td)+".txt";
% writetable(Tb,char(name),'WriteVariableNames',false,'Delimiter','space');
% name2="PROJ1_PID_EXP_STER error="+string(round(error,2))+" K="+string(K)+" Ti="+string(Ti)+" Td="+string(Td)+".txt";writetable(TT,char(name2),'WriteVariableNames',false,'Delimiter','space');
% writetable(TT,char(name),'WriteVariableNames',false,'Delimiter','space');
% end

% Tylko dla manual
        end
    end
end
% save ('temp_table1.mat', 'Tb');
% save ('temp_table2.mat','TT');