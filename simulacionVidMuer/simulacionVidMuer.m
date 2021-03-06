function simulacionVidMuer(pa,pb,nT,k,nTray)
%pa     Probabilidad de llegada
%pb     Probabilidad de salida
%nT     N�mero de tiempos
%k      Capacidad del "servidor"
%nTray  N�mero de trayectorias 
close all;

numK=zeros(nTray,nT);

%Estados iniciales del servidor
numK(:,1)=randi(k,nTray,1);

for i=1:nTray
    for j=1:nT-1
        numK(i,j+1)=numK(i,j)+((rand()<pa).*(numK(i,j)<k))-((rand()<pb).*(numK(i,j)>0));
    end
end

xt=linspace(1,nT,nT);
%Gr�fica de tres trayectorias t�picas
for i=1:3
    figure(i);
    ssf=sprintf('Trayectoria t�pica n�mero %d',i);
    stairs(xt,numK(i,:)),title(ssf);
    axis([-nT*.02,nT+1,-1,k+1])
    xlabel('Tiempo');
    ylabel('N�mero de clientes en el sistema');
end

%Distribuci�n de estados
ppi=zeros(1,k+1);
for i=1:k+1
    ppi(i)=sum(sum(numK==i-1))/(nTray*nT);
end
%Comprobaci�n de que es una distribuci�n
sum(ppi)

%Vector de estado, s�lo para graficar
xk=[0:1:k];

figure(4)
stem(xk,ppi,'x')
hold on;
ssf=sprintf('Distribuci�n de estados de un servidor con %d de capacidad y \n %d Pasos \n %d Trayectorias \n pLlegada = %f pSalida = %f',...
    k,nT,nTray,pa,pb);
plot(xk,ppi,'--'),title(ssf);
xlabel('N�mero de clientes');
ylabel('Pi');
end