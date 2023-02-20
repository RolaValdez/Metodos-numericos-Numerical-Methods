function [Y,NewtonPol,M] = NewtonInt(x,y,n,X)
%Autor: Rolando Valdez Guzmán
%Alias: Tutoingeniero
%Canal de Youtube: https://www.youtube.com/channel/UCU1pdvVscOdtLpRQBp-TbWg
%Versión: 1.0
%Actualizado: 18/feb/2023

% ESTA FUNCION PIDE LOS SIGUIENTES DATOS DE ENTRADA:

% x = Vector de coordenadas en x
% y = Vector de coordenadas en y
% n = Grado del polinomio a crear
% X = Coordenada para evaluar en el polinomio de interpolación

% VARIABLES DE SALIDA:

% Y = Valor del polinomio creado evaluado en X
% NewtonPol = Polinomio de Newton creado como un string.
% M = Tabla con los valores interpolados para cada grado del polinomio y
%     con los errores aproximados correspondientes.

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Algoritmo~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

%Construir la matriz de diferencias divididas finitas
ddf = zeros(length(x),length(y)); ddf(:,1) = y;
for j = 2:n+1
    for i = 1:(n+1)-(j-1)
        ddf(i,j) = (ddf(i+1,j-1) - ddf(i,j-1)) / (x(i+j-1) - x(i));
    end
end

%Interpolación de Newton
xterm = 1; yint = ddf(1,1); yacum = 0;
for i = 2:n+1
    xterm = xterm*(X-x(i-1));
    yint(i) = ddf(1,i)*xterm;
    yacum(i) = yacum(i-1) + yint(i);
    ea(i) = yacum(i) - yacum(i-1);
end
Y = sum(yint);

%Construir el polinomio de Newton como un string
pol{1,1} = num2str(ddf(1,1));
if n == 0
    NewtonPol = cell2mat(pol);
else
    for i = 2:n+1
        if sign(x(i)) == 1
            xr{1,i} = ['*(x - ',num2str(x(i-1)),')'];            
        elseif sign(x(i)) == -1
            xr{1,i} = ['*(x + ',num2str(x(i-1)),')'];
        end
        if sign(ddf(1,i)) == 1
            pol{1,i} = cell2mat([' +',num2str(ddf(1,i)),xr(2:end)]);
        elseif sign(ddf(1,i)) == -1
            pol{1,i} = cell2mat([' ',num2str(ddf(1,i)),xr(2:end)]);
        end
    end
    NewtonPol = cell2mat(pol);
end

%Resumen en una tabla
disp(['Interpolación con x = ', num2str(X)]);
vn = 0:n;
Encabezado = {'Grado','P(x)','Error'};
Datos = num2cell([vn',yacum',ea']);
M = [Encabezado ; Datos];

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Gráfica~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

fs = str2sym(NewtonPol); %Convierte el string a función simbólica.
fplot(fs,[min(x)-1,max(x)+1],'k-','LineWidth',2); %Grafica la función de color negro y grosor 2
title(['P(x) = ',NewtonPol]); hold on
x2 = sort(x); y2 = sort(y);
plot(x2,y2,'m--','LineWidth',1.5); hold on
scatter(x,y,'LineWidth',2,'MarkerEdgeColor','b'); hold on
plot(X,Y,'ro','MarkerFaceColor','r'); grid on
h = gcf; h.Position(1:2) = [750,90];
