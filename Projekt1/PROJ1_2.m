
Y=zeros(201,1);
U=zeros(201,1);
Y(1:11)=0.8;
U(1:11)=2.0;
kk=linspace(0,200,201)';
Us=[2.1, 2.2, 2.5];

% Skok wartosci sterowania w chwili k=11

for i=1:length(Us)
    U(12:200)=Us(i);
    for k=12:201
        Y(k)=symulacja_obiektu4Y(U(k-10),U(k-11),Y(k-1),Y(k-2));
    end
    T=table(kk,Y);
    filename="PROJ1_2 Uskok="+string(Us(i))+".txt";
    writetable(T,filename,'WriteVariableNames',false,'Delimiter','space');
end

save('Odpowiedz skokowa U=2.5.mat','Y');

Us2=linspace(1.2,2.8,17)';
Ystat=zeros(length(Us2),1);


for i=1:length(Us2)
    U(12:200)=Us2(i);
    for k=12:201
        Y(k)=symulacja_obiektu4Y(U(k-10),U(k-11),Y(k-1),Y(k-2));
    end
    Ystat(i)=Y(k);

end
T=table(Us2,Ystat);
writetable(T,'PROJ1_2 char_stat','WriteVariableNames',false,'Delimiter','space');
plot(Y);