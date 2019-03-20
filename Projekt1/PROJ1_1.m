
Y=zeros(200,1);
U=zeros(200,1);
Y(1:11)=0;
U(1:200)=2;
kk=linspace(0,200,201)';



for k=12:201
    Y(k)=symulacja_obiektu4Y(U(k-10),U(k-11),Y(k-1),Y(k-2));
end

T=table(kk,Y);
writetable(T,'PROJ1_1.txt','WriteVariableNames',false,'Delimiter','space');

plot(Y)