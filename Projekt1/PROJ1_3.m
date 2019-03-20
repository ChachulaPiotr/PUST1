load 'Odpowiedz skokowa U=2.5.mat'

deltaY=Y(end)-Y(1);
Upp=2;
Ypp=0.8;

% Przesuwamy wykres o 11 jednostek w lewo aby skok byl w chwili k=0
Y=Y(12:end);

% Przycinamy do wartosci w ktorej odpowiedz sie praktycznie nie zmienia

for i=1:length(Y)
    if (Y(i)>Y(1)+0.99999*deltaY)
        break
    end
end

% Zaokraglamy zeby ladnie na wykresach wygladalo
D=i;

stepResp=Y(1:D+1);

% Rzutujemy odpowiedz skokowa wzgledem punktu pracy oraz skoku rownego 0.5
stepResp=(stepResp-Ypp)/0.5;
kk=linspace(0,D,D+1)';
T=table(kk,stepResp);
writetable(T,'PROJ1_3','WriteVariableNames',false,'Delimiter','space');

save ('StepResponse','stepResp');

