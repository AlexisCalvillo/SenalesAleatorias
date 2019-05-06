function MM1FCFS1Ser(n,mi,lambda,x0,x1)
%Simulaci�n de un sistema MM1. FCFS y un servidor

%     n: N�mero de eventos
%    mi: Media del tiempo de servicios 
%lambda: Tasa de llegadas
%x0--x1: Estado del sistema durante los servicios x1-x0

%k al n�mero de llegada
k=1;
close all;

%tipoG determina si se generan tiempos de salida o de llegada
% tipoG=1;
% Ts=zeros(1,n);
% Ti(1)=-log(rand())/lambda;
% Ts(1)=-log(rand())/mi;
% Te(1)=0;
% Nt(1,:)=[0,0];
% i=1;
% while i<n
% switch tipoG
%     case 1
%         if (Ti(k)>=Te(i))
%             tipoG=2;
%         else
%             Ti(k+1)=Ti(k)-log(rand())/lambda;
%             Nt(k+i,:)=[Nt(k+i-1,1)+1,Ti(k+1)];
%             k=k+1;
%         end
%     case 2
%         Ts(i+1)=-log(rand())/mi;
%         tacum=cumsum(Ts);
%         Te(i+1)=(tacum(i+1)-Ti(i))*(tacum(i+1)-Ti(i)>0);
%         Nt(k+i,:)=[Nt(k+i-1,1)-((Nt(k+i-1,1))>0),Te(i+1)+Ti(i)];
%         i=i+1;
%         tipoG=1;
% end
% end
% A=[Ti(1:n);Te+Ti(1:n);Ts;Te;Te+Ts]';

%Tiempos de llegada
Ti=-log(rand(1,n+1))/lambda;
Ti=cumsum(Ti);
%Tiempos de servicio
Ts=-log(rand(1,n+1))/mi;
Te(1)=0;
Tt(1)=Ts(1)+Ti(1);
i=1;
k=1;
Nt(1,:)=[0,0];
tipoG=1;
while k<n 
    switch tipoG
    case 1
        if (Ti(k)>=Tt(i))
            tipoG=2;
        else
            %Ti(k+1)=Ti(k)-log(rand())/lambda;
            Nt(k+i,:)=[Nt(k+i-1,1)+1,Ti(k)];
            k=k+1;
        end
    case 2
        %Ts(i+1)=-log(rand())/mi;
        tacum=cumsum(Ts);
        Te(i+1)=(Tt(i)-Ti(i+1)).*(Tt(i)-Ti(i+1)>0);
        Tt(i+1)=Ti(i+1)+Te(i+1)+Ts(i+1);
        Nt(k+i,:)=[Nt(k+i-1,1)-((Nt(k+i-1,1))>0),Tt(i)];
        i=i+1;
        tipoG=1;
    end
end

N=Nt(x0:x1,:);
stairs(N(:,1))
for i=1:max(Nt(:,1))+1
    aux=cumsum(Nt(:,1)==i-1);
    P(i)=aux(length(Nt(:,1)));
end
P=P/length(Nt(:,1));
figure(2)
plot([0:1:max(Nt(:,1))],P)

%Verificaci�n de Little
j=trapz(Nt(1:min([i,k]),2),Nt(1:min([i,k]),1))/max(Nt(1:min([i,k]),2))
d=mean(Te(1:min([i,k-1]))+Ts(1:min([i,k-1]))).*lambda;
abs(1-j/d)