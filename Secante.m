%Autor: Rolando Valdez Guzmán
%Alias: Tutoingeniero
%Canal de Youtube: https://www.youtube.com/channel/UCU1pdvVscOdtLpRQBp-TbWg
%Versión: 1.0
%Actualizado: 16/may/2021

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Setup~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

%Método de la secante (versión interactiva)
%Ingresa los datos de entrada para encontrar la raíz de una función y presiona 
%Enter repetidas veces para ver el proceso paso a paso.

clc; clear all;
syms x
f=@(x) cos(x) + x; %Función dependiente de x.
fplot(f,'k-','LineWidth',2); %Grafica la función de color negro y grosor 2
title(func2str(f)); hold on; grid on; %Título de la función.
line([-5 5],[0 0],'Color','k','LineStyle','--'); %Marca el eje X.
line([0 0],[-5 5],'Color','k','LineStyle','--') %Marca el eje Y.

x0 = 0; xi = 1; %Valor inicial.
Niter=100; %Número de máximo de iteraciones. Recomiendo usar 100.
Tol=0.001; %Tolerancia para el criterio de convergencia a superar o igualar (%)
set(gcf,'Position',[551,86,560,420],'Units','pixels');

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~Algoritmo~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

obj = plot([x0,xi],[f(x0),f(xi)],'ko','markerfacecolor','b'); %Grafica los límites como puntos
fprintf('Presiona una tecla para continuar\n'); pause;

for i = 1:Niter
    
    xi_2(i) = xi(i) - (f(xi(i))*(x0(i)-xi(i)))/(f(x0(i)) - f(xi(i)));
    xi(i+1) = xi_2(i); x0(i+1) = xi(i); fxi(i) = f(xi(i));
    ea(i+1) = abs((xi(i+1) - xi(i)) / xi(i+1)) * 100; %Calcula el error relativo actual
    dfdx = (f(xi(i)) - f(x0(i)))/(xi(i) - x0(i));
    dfunc = poly2sym([dfdx,(dfdx * -xi(i)) + f(xi(i))],x); %Calcula la recta tangente y graficala.
        
    %Grafica nuevos puntos
    obj1 = plot(xi(i+1),f(xi(i+1)),'ko','markerfacecolor','r');
    obj2 = fplot(dfunc,'Color','r');
    obj3 = plot([xi(i+1),xi(i+1)],[0,f(xi(i+1))],'r--');
    fprintf('Presiona una tecla para continuar\n'); pause;
    
    % Grafica el nuevo intervalo
 delete(obj1); delete(obj2); delete(obj3);%Borra el punto medio actual y su línea de apoyo
    set(obj(1),'markerfacecolor','w'); %Vuelve blanco el punto que ya no nos sirve
    obj = plot([x0(i+1),xi(i+1)],[f(x0(i+1)),f(xi(i+1))],'ko','markerfacecolor','b'); %Actualiza los límites
    fprintf('Presiona una tecla para continuar\n'); pause;
    
    if i >= 2
        if xi(i+1) == xi(i-1)
            osc = osc + 1;
            if osc == 3
                error('Divergencia oscilatoria detectada. Use otro valor inicial de x');
            end
        end
    end
    
    if i >= 30 && ea(i+1) > es
        error('Convergencia lenta o divergencia detectada. Use otro valor inicial de x');
    end
      
    if ea(i+1) < Tol  || isnan(ea(i+1)) %Si el error relativo es menor a la tolerancia exigida, se acaba el ciclo.
        fprintf('Convergencia!\n');
        break;
    end
end

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Resultados~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

Raiz = xi(end)
Error_relativo = ea(end)
Numero_iter = i+1
