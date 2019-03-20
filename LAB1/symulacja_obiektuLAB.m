function y =symulacja_obiektuLAB(U, Y, k)

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



    y=b1*U(k-Td-1)+b2*U(k-Td-2)-a1*Y(k-1)-a2*Y(k-2);

end

