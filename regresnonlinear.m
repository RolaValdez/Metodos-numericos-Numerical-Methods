function [M,errstd,ccorrelacion,Y] = regresnonlinear(x,y,f,a,Niter,es,X)
%Autor: Rolando Valdez Guzmán
%Alias: Tutoingeniero
%Canal de Youtube: https://www.youtube.com/@Programacion_CAD_FEA/featured
%Versión: 1.0
%Actualizado: 22/ene/2023

% ESTA FUNCION PIDE LOS SIGUIENTES DATOS DE ENTRADA:

% x = Vector de coordenadas x de los datos observados.
% y = Vector de coordenadas y de los datos observados, dependientes de x.
% f = Función escrita como un dato tipo string → 'a + b*x + c*x^2'
% a = vector fila con los valores iniciales para cada constante de f
%     → ej. a0 = 1, a1 = 2, a2 = 0.5 → a = [1 2 0.5]
% Niter = Número predeterminado de iteraciones, usualmente 100.
% es = Error estimado para converger y detener el algoritmo.
% X = Valor a usar para interpolar en f/

% VARIABLES DE SALIDA:

% M = Tabla de iteraciones con los valores de los coeficientes de la
%     función y sus errores aproximados 
% errstd = Error estándar del estimado (Sy/x)
% ccorrelacion = Coeficiente de correlación (r)
% Y = Si se ingresó un valor para X, Y entrega el valor de la función de
      %regresión evaluada en X.
      
%Otra variables calculadas:
    %Sr = Suma total de los cuadrados de las diferencias entre los datos y 
          %la recta alrededor de la línea de regresión.
    %St = Suma total de los cuadrados de las diferencias entre los datos y 
          %la media
    %cdet = Coeficiente de determinación (r^2)

%En un ajuste perfecto, Sr = 0 y r = r2 = 1, significa que la función explica
%el 100% de la variabilidad de los datos. Si r = r2 = 0, Sr = St el ajuste
%no representa alguna mejora. 
%(Chapra S, Métodos Numéricos para Ingenieros,5ta edición)

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Algoritmo~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

%Protección contra errores en las entradas.
if nargin ~= 7                 
    error('No hay suficientes datos de entrada');
%Si se ingresan todos los datos de entrada, elegir un método de solución
else
    if  isempty(Niter) == 1
        metodo = 1; Niter = 100;
        disp(newline);
        disp('Solución por error relativo establecido para converger');
    elseif isempty(es) == 1
        metodo = 2; disp(newline);
        disp('Solución por número máximo de iteraciones para converger');
    elseif isempty(Niter) == 0 && isempty(es) == 0
        error('Los argumentos de entrada 5 y 6 no pueden tener un dato de entrada al mismo tiempo');
    end
end

%Datos de entrada
fs = str2sym(f); var = symvar(fs);
c = var(1:end-1); vs = var(end);

%Algoritmo de Gauss-Newton
for i = 1:Niter - 1
    dpfs = subs(gradient(fs,c),c,a(i,:));
    Z0 = double(subs(dpfs,vs,x))';
    Z = Z0'*Z0;
    fmod = subs(fs,c,a(i,:));
    ymod = double(subs(fmod,vs,x));
    D = (y - ymod)';
    dA = Z\(Z0'*D);
    a(i+1,:) = a(i,:) + dA';
    ea(i+1,:) = abs((a(i+1,:) - a(i,:))./a(i+1,:))*100;
    
    if metodo == 1
        if ea(i+1,:) < es
            break
        end
    end
end

%Crear una gráfica
scatter(x,y); hold on
fmod = subs(fs,c,a(end,:));
ymod = double(subs(fmod,vs,x));
F = matlabFunction(fmod); Y = F(X);
fplot(fmod,[x(1),x(end)+2],'LineWidth',1,'Color','k'); hold on
plot(X,Y,'ro','MarkerFaceColor','r'); grid on
title(f);
h = gcf; h.Position(1:2) = [768,76];

%Cálculos estadísticos
n = length(x); m = length(c);
Sr = (y - ymod).^2;
St = sum((y - sum(y)/n).^2);
errstd = sqrt(sum(Sr)/(n-(m+1)));
ccorrelacion = ((St - sum(Sr))/St)*100;

%Resumen en una tabla
E1 = strseq('a',0:length(c)-1)';
E2 = strseq('Ea (%) de a',0:length(c)-1)';
Encabezado = [E1,E2];
Datos = num2cell([a,ea]);
M = [Encabezado ; Datos];


