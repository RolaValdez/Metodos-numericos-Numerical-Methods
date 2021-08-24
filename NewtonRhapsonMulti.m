%Autor: Rolando Valdez Guzmán
%Alias: Tutoingeniero
%Canal de Youtube: https://www.youtube.com/channel/UCU1pdvVscOdtLpRQBp-TbWg
%Versión: 1.0
%Actualizado: 8/ago/2021

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Setup~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

%Método de Newton-Rhapson (versión interactiva)
%Ingresa los datos de entrada para encontrar la raíz de una función y presiona 
%Enter repetidas veces para ver el proceso paso a paso.

%NECESITA LA SYMBOLIC MATH TOOLBOX

clc; clear all;

f = {'2*x^2 + 2*x*y + y^2 - 1'; 'x^2 - 3*x*y + 3*y^2 - 1'};

fs = str2sym(f);
vs = symvar(fs);
J = jacobian(fs,vs);

for i = 1:length(fs)
   fimplicit(fs(i),'k-','LineWidth',2) %Grafica la función de color negro y grosor 2
   hold on
end
grid on;
set(gcf,'Position',[551,86,560,420],'Units','pixels');

xi = [-2,0]; %Valor inicial.
Niter = 100; %Número de máximo de iteraciones. Recomiendo usar 100.
es=0.001; %Tolerancia para el criterio de convergencia a superar o igualar (%)


%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~Algoritmo~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

obj = plot(xi(1),xi(2),'ko','markerfacecolor','b');
fprintf('Presiona una tecla para continuar\n'); pause;

osc = 0;
for i = 1:Niter - 1
    xi(i+1,:) = xi(i,:)' - double((subs(J,vs,xi(i,:)))\subs(fs,vs,xi(i,:)));
    ea(i+1,:) = abs((xi(i+1,:) - xi(i,:)) ./ xi(i+1,:)) * 100;
       
    %Grafica nuevos puntos
    obj1 = plot(xi(i+1,1),xi(i+1,2),'ko','markerfacecolor','r'); %Grafica el punto medio actual.
    fprintf('Presiona una tecla para continuar\n'); pause;
    
    % Grafica el nuevo intervalo
    delete(obj1);%Borra el punto medio actual y su línea de apoyo
    set(obj,'markerfacecolor','w'); %Vuelve blanco el punto que ya no nos sirve
    obj = plot(xi(i+1,1),xi(i+1,2),'ko','markerfacecolor','b'); %Actualiza los límites
    fprintf('Presiona una tecla para continuar\n'); pause;
    
    if isnan(ea(i+1,:))
        error('Divergencia detectada. Use otros valores iniciales');
    end
    
    if i >= 2
        if xi(i+1,:) == xi(i-1,:) 
            osc = osc + 1;
            if osc == 3
                error('Divergencia oscilatoria detectada. Use otros valores iniciales');
            end
        end
    end
    
    if i >= 30
        if any(ea(i+1,:) > es)
            error('Convergencia lenta o divergencia detectada. Use otros valores iniciales');
        end
    end
    
    if ea(i+1,:) < es  %Si el error relativo es menor a la tolerancia exigida, se acaba el ciclo.
        break;
    end
end

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Resultados~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

Raiz = xi(end,:)
Error_relativo = ea(end,:)
Numero_iter = i+1