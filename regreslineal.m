function [a,Y,T] = regreslineal(x,y,X)
%Autor: Rolando Valdez Guzmán
%Alias: Tutoingeniero
%Canal de Youtube: https://www.youtube.com/channel/UCU1pdvVscOdtLpRQBp-TbWg
%Versión: 1.0
%Actualizado: 31/dic/2021

% ESTA FUNCION PIDE LOS SIGUIENTES DATOS DE ENTRADA:

% x = Vector de 1 hasta n cantidad de datos.
% y = Vector que representa los valores de Y para cada valor de x.
% X = Valor a evaluar en la recta de regresión lineal. Si no se desea
      %evaluar un valor en la recta se puede ingresar un vector vacío así: []

% VARIABLES DE SALIDA:

% a = Coeficientes de la recta de regresión: [a1,a0]
% Y = Si se ingresó un valor para X, Y entrega el valor de la recta de
      %regresión evaluada en X.
% T = Tabla con las siguientes variables estadísticas calculadas:

    %Sr = Suma total de los cuadrados de las diferencias entre los datos y 
          %la recta alrededor de la línea de regresión.
    %St = Suma total de los cuadrados de las diferencias entre los datos y 
          %la media
    %es = Error estándar del estimado (Sy/x)
    %cdet = Coeficiente de determinación (r^2)
    %ccor = Coeficiente de correlación (r)

%En un ajuste perfecto, Sr = 0 y r = r2 = 1, significa que la línea explica
%el 100% de la variabilidad de los datos. Si r = r2 = 0, Sr = St el ajuste
%no representa alguna mejora. 
%(Chapra S, Métodos Numéricos para Ingenieros,5ta edición)

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Algoritmo~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

n = length(x);
sigmaX = sum(x); sigmaX2 = sum(x.^2);
sigmaY = sum(y); sigmaXY = sum(x.*y);

A = [n, sigmaX; sigmaX, sigmaX2];
B = [sigmaY; sigmaXY];
a = A\B;

Sr = sum((y - a(1) - a(2).*x).^2);
St = sum((y - sigmaY/n).^2);
es = sqrt(Sr/(n-2));
cdet = (St - Sr)/St;
ccor = sqrt(cdet);
E1 = {'Sr';'St';'Error estándar del estimado';...
      'Coeficiente de determinación';'Coeficiente de correlación'};
E2 = [Sr; St; es; cdet; ccor];
T = table(E1,E2,'VariableNames',{'Valores calculados','Resultados'});

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Gráfica~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

scatter(x,y,'LineWidth',1,'MarkerEdgeColor','b'); hold on
modelo = poly2sym(flipud(a));
f = matlabFunction(modelo);
fplot(modelo,[x(1),x(end)],'LineWidth',2,'Color','k'); hold on
grid on
if sign(a(2)) == -1
    title(['Y = ',num2str(a(1)),num2str(a(2)),'x']);
else
    title(['Y = ',num2str(a(1)),' + ',num2str(a(2)),'x']);
end
maxX = max(x); 
maxY = max(y); minY = min(y);
axis([0, maxX + 2, minY - 2, maxY + 2]);
h = gcf; h.Position(1:2) = [765,90];

if nargin < 3
    Y = NaN;
    return
elseif nargin == 3
    Y = f(X);
    plot(X,Y,'ro','MarkerFaceColor','r');
end
