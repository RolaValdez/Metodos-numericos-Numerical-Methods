function [aprox,etf,eaf,M] = Taylor(fun,xi,a,n)
%Autor: Rolando Valdez Guzmán
%Alias: Tutoingeniero
%Canal de Youtube: https://www.youtube.com/channel/UCU1pdvVscOdtLpRQBp-TbWg
%Versión: 2.0
%Actualizado: 16/may/2021

% ESTA FUNCION PIDE LOS SIGUIENTES DATOS DE ENTRADA:

% fun = Función escrita como un string ej. 'cos(x)' 
% xi = Valor a evaluar de la función.
% a = Punto donde se centran las derivadas de fun.
% n = Número de términos del polinomio de grado n, empezando desde 0.

% VARIABLES DE SALIDA:

% M = Tabla de resultados {'Iter','aprox','et','ea'};
% aprox = Valor aproximado final de fun.
% etf = Error relativo porcentual final.
% eaf = Error aproximado porcentual final.

%~~~~~~~~~~~~~~~~Protección contra errores en las entradas~~~~~~~~~~~~~~~~%
if nargin ~= 4
    error('Sólo se debe ingresar la función, el valor a evaluar, el punto base y el número de términos');
end
if n < 0
    error('El grado del polinomio de Taylor debe ser de mínimo orden 0');
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Setup~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

fs = str2sym(fun); %Convertir fun a una función simbólica.
vs = symvar(fs);   %Encontrar la variable simbólica en fs.
R = double(subs(fs,vs,xi)); %Valor real al cual aproximarse.

%Inicializar variables para ahorrar memoria.
s = zeros(1,n+1); sigma = zeros(1,n+1); et = zeros(1,n+1);
ea = zeros(1,n+1); ea(1) = NaN;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Algoritmo~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

for i = 0:n
    %Polinomio de Taylor: Modo divertido
    s(i+1) = subs(diff(fs,vs,i),vs,a)/factorial(i) * (xi - a)^i;
    sigma(i+1) = sum(double(s));               %Sumatoria de orden n del polinomio

    %Polinomio de Taylor
    Tp(i+1) = taylor(fs,vs,a,'Order',i+1);
    
    et(i+1) = abs(((R - sigma(i+1))/R))*100;    %Error relativo porcentual
    if i >= 1 %A partir de la segunda iteración podemos calcular un error aproximado porcentual.
        ea(i+1) = abs((sigma(i+1) - sigma(i))/sigma(i+1))*100;
    end
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Resultados~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

%Tabla de resultados
aprox = sigma(end); etf = et(end); eaf = ea(end);
Encabezado = {'Iteración','Valor aproximado','Error relativo porcentual',...
              'Error aproximado porcentual'};
T = num2cell([(1:n+1)', sigma', et', ea']); M = [Encabezado ; T];

%Gráfica
fplot(fs,'LineWidth',2); grid on; hold on
plot(xi,R,'ro','MarkerFaceColor','r'); hold on
plot(a,subs(fs,vs,a),'bo','MarkerFaceColor','b');
for i = 2:n+1
    hold on
    fplot(Tp(i));
end
txt1 = strcat(strseq('T_p_',1:n+1),{'(x)'});
legend([cellstr(fun); {['f(',num2str(xi),')']}; {'a'}; txt1],'Location','Best')
