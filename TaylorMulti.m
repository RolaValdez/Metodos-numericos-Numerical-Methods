function [aprox,etf,eaf,M] = TaylorMulti(fun,X,A,n)
%Autor: Rolando Valdez Guzmán
%Alias: Tutoingeniero
%Canal de Youtube: https://www.youtube.com/channel/UCU1pdvVscOdtLpRQBp-TbWg
%Versión: 1.0
%Actualizado: 12/jun/2021

% ESTA FUNCION PIDE LOS SIGUIENTES DATOS DE ENTRADA:

% fun = Función de dos variables escrita como un string ej. 'cos(x) + y' 
% X = Vector de valores [x,y] con los cuales evaluar la función.
% A = Vector de puntos de expansión [a,b] donde se centran las derivadas de fun.
% n = Número de términos del polinomio de grado n, empezando desde 0.

% VARIABLES DE SALIDA:

% M = Tabla de resultados {'Iter','aprox','et','ea'};
% aprox = Valor aproximado final de fun.
% etf = Error relativo porcentual final.
% eaf = Error aproximado porcentual final.

%~~~~~~~~~~~~~~~~Protección contra errores en las entradas~~~~~~~~~~~~~~~~%
if nargin ~= 4
    error('Sólo se debe ingresar la función, el valor a evaluar, el punto base y el número de términos');
else
    if length(X) ~= 2 || length(A) ~= 2
        error('Se necesitan dos valores [x,y] para X y dos valores [a,b] para A');
    end
end
if n < 0
    error('El grado del polinomio de Taylor debe ser de mínimo orden 0');
end


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Setup~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

fs = str2sym(fun); %Convertir fun a una función simbólica.
vs = symvar(fs);  %Encontrar la variable simbólica en fs.
R = double(subs(fs,vs,X)); %Valor real al cual aproximarse.


%Inicializar variables para ahorrar memoria.
k = 1; c = 0; 
coeffs = zeros(1,n+1); sigma = zeros(1,n+1); et = zeros(1,n+1);
ea = zeros(1,n+1); ea(1) = NaN;

for i = 0:n
    for j = 0:n-i
        fsp = diff(fs,vs(1),i);
        fsp = diff(fsp,vs(2),j);
        s = subs(fsp,vs,A)/(factorial(i)*factorial(j)) * (X(1) - A(1))^i * (X(2) - A(2))^j;
        c = c + 1;
        if c <= n+1
            coeffs(j+1) = double(s);
            sigma(j+1) = sum(coeffs)';
        end
    end
    
    
    et(k) = abs(((R - sigma(k))/R))*100;   %Error relativo porcentual
    if k >= 2 %A partir de la segunda iteración podemos calcular un error aproximado porcentual.
        ea(k) = abs((sigma(k) - sigma(k-1))/sigma(k))*100;
    end
    %Polinomio de Taylor
    Tp(k) = taylor(fs,vs,A,'Order',k);
    k = k + 1;
    
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Resultados~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

%Tabla de resultados
aprox = sigma(end); etf = et(end); eaf = ea(end);
Encabezado = {'Iteración','Valor aproximado','Error relativo porcentual',...
              'Error aproximado porcentual'};
T = num2cell([(1:n+1)', sigma', et', ea']); M = [Encabezado ; T];

%Gráfica
fsurf(fs,'FaceColor',rand(1,3)); grid on; hold on
plot3(X(1),X(2),R,'ro','MarkerFaceColor','r'); hold on
plot3(A(1),A(2),subs(fs,vs,A),'bo','MarkerFaceColor','b');
for i = 2:n+1
    hold on
    fsurf(Tp(i),'FaceColor',rand(1,3));
end
txt1 = strcat(strseq('T_p_',1:n+1),{'(x,y)'});
legend([cellstr(fun); {['f(',num2str(X(1)),',',num2str(X(2)),')']}; {'a,b'}; txt1],'Location','Best')
