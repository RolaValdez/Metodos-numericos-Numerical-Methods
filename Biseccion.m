%Autor: Rolando Valdez Guzm�n
%Alias: Tutoingeniero
%Canal de Youtube: https://www.youtube.com/channel/UCU1pdvVscOdtLpRQBp-TbWg
%Versi�n: 1.0
%Actualizado: 17/jun/2020

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Setup~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

%M�todo de la bisecci�n (versi�n interactiva) ESPA�OL
%Ingresa los datos de entrada para encontrar la ra�z de una funci�n en un
%intervalo dado y presiona Enter repetidas veces para ver el proceso paso
%por paso.

clc; clear all;

f=@(x) cos(x)+x; %Funci�n dependiente de x.
fplot(f,'k-','LineWidth',2); %Grafica la funci�n de color negro y grosor 2
title(func2str(f)); hold on; grid on; %T�tulo de la funci�n.
line([-5 5],[0 0],'Color','k','LineStyle','--'); %Marca el eje X.
line([0 0],[-5 5],'Color','k','LineStyle','--') %Marca el eje Y.

xl=-2; %L�mite inferior.
xu=0; %L�mite superior.
fxl=f(xl); %Punto en Y para el l�mite inferior.
fxu=f(xu); %Punto en Y para el l�mite superior.
Niter=100; %N�mero de iteraciones. Recomiendo usar 100.
Tol=0.01; %Tolerancia para el criterio de convergencia a superar o igualar (%)

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~Algoritmo~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

x = linspace(xl,xu,100);
ylim = [min(f(x)),max(f(x))];
if fxl*fxu > 0 %Esta propiedad es la que hace que �ste sea un m�todo cerrado.
    error('No hay una ra�z en ese intervalo!'); 
end

obj=plot([xl,xu],[fxl,fxu],'ko','markerfacecolor','b'); %Grafica los l�mites como puntos
fprintf('Presiona una tecla para continuar\n'); pause;

for i = 1:Niter
    % Biseccionar
    xr(i)=(xl(i)+xu(i))/2; %Calcula el punto medio actual.
    fxr(i)=f(xr(i)); %Evalua la funci�n en el punto medio actual.
    
    if f(xr(i))*f(xl(i)) > 0 %Si esta condici�n se cumple, la ra�z NO est� entre xl y xr
        xl(i+1) = xr(i); %El punto medio es el nuevo l�mite inferior.
        xu(i+1) = xu(i); %El l�mite superior se mantiene igual.
        fxl(i+1)=f(xl(i+1));
        fxu(i+1)=f(xu(i+1));
    elseif f(xr(i))*f(xu(i)) > 0 %Si esta condici�n se cumple, la ra�z NO est� entre xu y xr
        xu(i+1) = xr(i); %El punto medio es el nuevo l�mite superior.
        xl(i+1) = xl(i); %El l�mite inferior se mantiene igual.
        fxl(i+1)=f(xl(i+1));
        fxu(i+1)=f(xu(i+1));
    end
    
    xr(i+1)=(xu(i+1)+xl(i+1))/2; %Actulizamos el punto medio y su punto en Y
    fxr(i+1)=f(xr(i+1));
    Error(i+1)=abs((xr(i+1)-xr(i))/xr(i+1))*100; %Calcula el error relativo actual
    
    %Grafica nuevos puntos
    obj1 = plot(xr(i),fxr(i),'ko','markerfacecolor','r'); %Grafica el punto medio actual.
    obj2 = plot([xr(i),xr(i)],ylim,'r--'); %Grafica una l�nea vertical que pasa por el punto medio actual
    fprintf('Presiona una tecla para continuar\n'); pause;
    
    % Grafica el nuevo intervalo
    delete(obj1); delete(obj2); %Borra el punto medio actual y su l�nea de apoyo
    set(obj,'markerfacecolor','w'); %Vuelve blanco el punto que ya no nos sirve
    obj=plot([xl(i+1),xu(i+1)],[fxl(i+1),fxu(i+1)],'ko','markerfacecolor','b'); %Actualiza los l�mites
    fprintf('Presiona una tecla para continuar\n'); pause;
    
    if Error(i+1) < Tol %Si el error relativo es menor a la tolerancia exigida, se acaba el ciclo.
        fprintf('Convergencia!\n'); 
        obj1 = plot(xr(i),fxr(i),'ko','markerfacecolor','r');
        obj2 = plot([xr(i),xr(i)],ylim,'r--');
        break;
    end
end

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Resultados~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

Raiz=xr(end)
Error_relativo=Error(end)
Numero_iter=i+1



