function [a,Y,T] = regrespol(x,y,m,X)
%Autor: Rolando Valdez Guzmán
%Alias: Tutoingeniero
%Canal de Youtube: https://www.youtube.com/channel/UCU1pdvVscOdtLpRQBp-TbWg
%Versión: 1.0
%Actualizado: 15/may/2022

% ESTA FUNCION PIDE LOS SIGUIENTES DATOS DE ENTRADA:

% x = Vector de 1 hasta n cantidad de datos.
% y = Vector que representa los valores de Y para cada valor de x.
% m = Grado del polinomio de regresión
% X = Valor a evaluar en la recta de regresión lineal. Si no se desea
      %evaluar un valor en la recta se puede ingresar un vector vacío así: []

% VARIABLES DE SALIDA:

% a = Coeficientes de la recta de regresión: [a0,a1,a2,...,a_n]
% Y = Si se ingresó un valor para X, Y entrega el valor de la función de
      %regresión evaluada en X.
% T = Tabla con las siguientes variables estadísticas calculadas:

    %Sr = Suma total de los cuadrados de las diferencias entre los datos y 
          %la recta alrededor de la línea de regresión.
    %St = Suma total de los cuadrados de las diferencias entre los datos y 
          %la media
    %es = Error estándar del estimado (Sy/x)
    %cdet = Coeficiente de determinación (r^2)
    %ccor = Coeficiente de correlación (r)

%En un ajuste perfecto, Sr = 0 y r = r2 = 1, significa que la función explica
%el 100% de la variabilidad de los datos. Si r = r2 = 0, Sr = St el ajuste
%no representa alguna mejora. 
%(Chapra S, Métodos Numéricos para Ingenieros,5ta edición)

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Algoritmo~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

n = length(x); 
if n < m+1
    error('No es posible realizar una regresión de este orden');
end

%Crear el sistema de ecuaciones de m+1 x m+1 dinámicamente
A = zeros(m+1,m+1); B = zeros(1,m+1); k = 0;
for i = 1:m+1
    for j = 1:m+1
        A(i,j) = sum(x.^((j-1)+k));
    end
    B(i) = sum(y.*x.^k);
    k = k + 1;
end
a = A\B'; %Resolver el sistema y obtener los coeficientes del polinomio

%Evaluar el polinomio con todos los valores de X y guardarlos en una matriz
ymodelo = zeros(n,m+1); k = 0;
for j = 1:m+1
    ymodelo(:,j) = a(j).*x.^k;
    k = k+1;
end
ymodelo = sum(ymodelo,2);
Sr = sum((y - ymodelo').^2); %Regresión por mínimos cuadrados

%Otros datos estadísticos
St = sum((y - sum(y)/n).^2);
es = sqrt(Sr/(n-(m+1)));
cdet = ((St - Sr)/St);
ccor = sqrt(cdet);

%Tabla de resultados
E1 = {'Sr';'St';'Error estándar del estimado';...
      'Coeficiente de determinación';'Coeficiente de correlación'};
E2 = [Sr; St; es; cdet; ccor];
T = table(E1,E2,'VariableNames',{'Valores calculados','Resultados'});

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Gráfica~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

%PARA USAR ESTA SECCION DEL CODIGO SE NECESITA LA SYMBOLIC MATH TOOLBOX
%DE LO CONTRARIO, HAY QUE BORRAR TODO ESTO
scatter(x,y,'LineWidth',2,'MarkerEdgeColor','b'); hold on
modelo = poly2sym(flipud(a));
f = matlabFunction(modelo);
fplot(modelo,[x(1),x(end)],'LineWidth',2); hold on
grid on
titlestr{1} = num2str(a(1));
for i = 2:m+1
    if sign(a(i)) == 1
        titlestr{i} = [' + ',num2str(a(i)),'x^',num2str(i-1)];
    elseif sign(a(i)) == -1
        titlestr{i} = [' ',num2str(a(i)),'x^',num2str(i-1)];
    end
end
S = cell2mat(titlestr); title(['Y = ',S]);
maxX = max(x); minX = min(x);
maxY = max(y); minY = min(y);
axis([minX, maxX + 2, minY - 2, maxY + 2]);
h = gcf; h.Position(1:2) = [765,90];

if nargin < 4
    Y = NaN;
    return
elseif nargin == 4
    Y = f(X);
    plot(X,Y,'ro','MarkerFaceColor','r');
end
