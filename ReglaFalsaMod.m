%Autor: Rolando Valdez Guzmán
%Alias: Tutoingeniero
%Canal de Youtube: https://www.youtube.com/channel/UCU1pdvVscOdtLpRQBp-TbWg
%Versión: 1.0
%Actualizado: 17/jun/2020

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Setup~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

%Método de la regla falsa modificada (versión interactiva) ESPAÑOL
%Ingresa los datos de entrada para encontrar la raíz de una función en un
%intervalo dado y presiona Enter repetidas veces para ver el proceso paso
%por paso.

clc; clear all;

f=@(x) x.^(10) - 1; %Función dependiente de x.
fplot(f,'k-','LineWidth',2); %Grafica la función de color negro y grosor 2
title(func2str(f)); hold on; grid on; %Título de la función.
line([-5 5],[0 0],'Color','k','LineStyle','--'); %Marca el eje X.
line([0 0],[-5 5],'Color','k','LineStyle','--') %Marca el eje Y.
axis([-0.5 3 -5 15])

xl=0; %Límite inferior.
xu=1.3; %Límite superior.
fxl=f(xl); %Punto en Y para el límite inferior.
fxu=f(xu); %Punto en Y para el límite superior.
Niter=100; %Número de iteraciones. Recomiendo usar 100.
Tol=0.01; %Tolerancia para el criterio de convergencia a superar o igualar (%)
il=0;
iu=0;

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~Algoritmo~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

x = linspace(xl,xu,100);
ylim = [min(f(x)),max(f(x))];
if fxl*fxu > 0 %Esta propiedad es la que hace que éste sea un método cerrado.
    error('No hay una raíz en ese intervalo!'); 
end

obj=plot([xl,xu],[fxl,fxu],'ko','markerfacecolor','b'); %Grafica los límites como puntos
fprintf('Presiona una tecla para continuar\n'); pause;

for i = 1:Niter
    % Regla Falsa
    xr(i)=xu(i)-fxu(i)*((xu(i)-xl(i))/(fxu(i)-fxl(i))); %Calcula el punto medio falso actual.
    fxr(i)=f(xr(i)); %Evalua la función en el punto medio falso actual.
    
    if f(xr(i))*f(xl(i)) > 0 %Si esta condición se cumple, la raíz NO está entre xl y xr
        xl(i+1) = xr(i); %El punto medio es el nuevo límite inferior.
        xu(i+1) = xu(i); %El límite superior se mantiene igual.
        fxl(i+1)=f(xl(i+1));
        fxu(i+1)=f(xu(i+1));
        il=0;
        iu=iu+1;
        %Si usamos dos o más veces seguidas el mismo límite superior, evaluar en la función y dividir sobre 2
        if iu>=2
            fxu(i+1)=(fxu(i))/2;
        end
    elseif f(xr(i))*f(xu(i)) > 0 %Si esta condición se cumple, la raíz NO está entre xu y xr
        xu(i+1) = xr(i); %El punto medio es el nuevo límite superior.
        xl(i+1) = xl(i); %El límite inferior se mantiene igual.
        fxl(i+1)=f(xl(i+1));
        fxu(i+1)=f(xu(i+1));
        iu=0;
        il=il+1;
        %Si usamos dos o más veces seguidas el mismo límite inferior, evaluar en la función y dividir sobre 2
        if il>=2
            fxl(i+1)=(fxl(i))/2;
        end
    end
    
    xr(i+1)=xu(i+1)-fxu(i+1)*((xu(i+1)-xl(i+1))/(fxu(i+1)-fxl(i+1))); %Actulizamos el punto medio falso y su punto en Y
    fxr(i+1)=f(xr(i+1));
    Error(i+1)=abs((xr(i+1)-xr(i))/xr(i+1))*100; %Calcula el error relativo actual
    
    %Grafica nuevos puntos
    obj1 = plot(xr(i),fxr(i),'ko','markerfacecolor','r'); %Grafica el punto medio actual.
    obj2 = plot([xr(i),xr(i)],ylim,'r--'); %Grafica una línea vertical que pasa por el punto medio actual.
    
    %Construye los dos triángulos que intersectan con el eje X.
    obj3 = line([xl(i),xu(i)],[fxl(i),fxu(i)],'Color','r');
    obj4 = line([xl(i),xl(i)],[fxl(i),0],'Color','r');
    obj5 = line([xu(i),xu(i)],[fxu(i),0],'Color','r');
    obj6 = line([xl(i),xu(i)],[0,0],'Color','r');
    obj7 = area([xl(i),xr(i)],[fxl(i),0]);
    obj8 = area([xr(i),xu(i)],[0,fxu(i)]);
    alpha(obj7,0.3);
    alpha(obj8,0.3);
    fprintf('Presiona una tecla para continuar\n'); pause;
    
    % Grafica el nuevo intervalo
    delete(obj1); delete(obj2); 
    delete(obj3); delete(obj4); delete(obj5); delete(obj6);
    delete(obj7); delete(obj8);%Borra el punto medio actual y su línea de apoyo
    set(obj,'markerfacecolor','w'); %Vuelve blanco el punto que ya no nos sirve
    obj=plot([xl(i+1),xu(i+1)],[fxl(i+1),fxu(i+1)],'ko','markerfacecolor','b'); %Actualiza los límites
    fprintf('Presiona una tecla para continuar\n'); pause;
    
    if Error(i+1) < Tol %Si el error relativo es menor a la tolerancia exigida, se acaba el ciclo.
        fprintf('Convergencia!\n'); 
        obj1 = plot(xr(i),fxr(i),'ko','markerfacecolor','r');
        obj2 = plot([xr(i),xr(i)],ylim,'r--');
        break;
    end
end

M1={'xl','xr','xu','f(xl)','f(xr)','f(xu)','Error relativo (%)'};
M2=num2cell([xl' xr' xu' fxl' fxr' fxu' Error']);
M=[M1; M2];
XR=xr(end);
ER=Error(end);
Iter=i+1;

%Evaluar la función con la raíz aproximada y mensaje de resumen.
Resultado=f(XR);
disp(newline)
disp(['Evaluando la función ' func2str(f) ' con ' num2str(XR) ', el resultado es: ' num2str(Resultado)]);
disp(['Error relativo (%): ' num2str(ER)]);
disp(['Número de iteraciones: ' num2str(Iter)]);