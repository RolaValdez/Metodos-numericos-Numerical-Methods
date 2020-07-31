function [M, XR, ER, Iter] = ReglaFalsaModFcn(f, xl, xu, Niter, Tol)
%Autor: Rolando Valdez Guzmán
%Alias: Tutoingeniero
%Canal de Youtube: https://www.youtube.com/channel/UCU1pdvVscOdtLpRQBp-TbWg
%Versión: 2.0
%Actualizado: 30/jul/2020

%Método de la regla falsa modificada (versión función) ESPAÑOL.
%Llama a esta función desde la ventana de comandos o cualquier script para
%encontrar la raíz de una función en un intervalo y obtén una tabla con el
%proceso.

% ESTA FUNCION PIDE LOS SIGUIENTES DATOS DE ENTRADA:

% f = función como un identificador de función (function handle) 
%   ej. @(x) cos(x)
% xl = Límite inferior. Este dato es un escalar.
% xu = Límite superior. Este dato es un escalar.
% Niter = Número de iteraciones.
% Tol = Tolerancia para el criterio de convergencia a superar o igualar en
% porcentaje.

% VARIABLES DE SALIDA:

% M = Tabla de resultados {'xl', 'xr', 'xu', 'f(xl)', 'f(xr)', 'f(xu)', 'Error relativo (%)'}
% XR = Ultima iteración de la raíz de la función.
% ER = Ultima iteracion del error relativo.
% Iter = Número de iteraciones

%METODOS DE SOLUCION

%Método 1: Si Niter está vacío (Niter = []) entonces se debe especificar un
%error relativo mínimo para converger.
%Método 2: Si Tol está vacío (Tol = []) entonces se debe especificar un
%número máximo de iteraciones para el código. Es posible que un número muy
%grande de iteraciones cree un error y un mensaje aparecerá sugiriendo
%reducir el número de iteraciones.

%Si se ingresan menos de tres datos de entrada...
if nargin < 5                 
    error('Se necesita definir una función, un intervalo a evaluar, un número máximo de iteraciones y un error relativo mínimo');
%Si se ingresan todos los datos de entrada, elegir un método de solución
else                          
    if  isempty(Niter) == 1 
        metodo = 1;
        Niter = 1000;
        disp(newline);
        disp('Solución por error relativo mínimo para converger');
    elseif isempty(Tol) == 1 
        metodo = 2;
        disp(newline);
        disp('Solución por número máximo de iteraciones para converger');
    elseif isempty(Niter) == 0 && isempty(Tol) == 0
        error('Niter y Tol no pueden tener un dato de entrada al mismo tiempo, uno de los dos debe estar vacío (ejemplo: Niter = [])');
    end
end

fxl = f(xl); %Punto en Y para el límite inferior.
fxu = f(xu); %Punto en Y para el límite superior.
il = 0;
iu = 0;

if fxl * fxu > 0 %Esta propiedad es la que hace que éste sea un método cerrado.
    error('No hay una raíz en ese intervalo!'); 
end

for i = 1:Niter - 1
    xr(i) = xu(i) - fxu(i) * ((xu(i) - xl(i)) / (fxu(i) - fxl(i))); %Calcula el punto medio falso actual.
    fxr(i) = f(xr(i)); %Evalua la función en el punto medio falso actual.
    
    if f(xr(i)) * f(xl(i)) > 0 %Si esta condición se cumple, la raíz NO está entre xl y xr
        xl(i+1) = xr(i); %El punto medio es el nuevo límite inferior.
        xu(i+1) = xu(i); %El límite superior se mantiene igual.
        fxl(i+1) = f(xl(i+1));
        fxu(i+1) = f(xu(i+1));
        il = 0;
        iu = iu + 1;
        %Si usamos dos o más veces seguidas el mismo límite superior, evaluar en la función y dividir sobre 2
        if iu >= 2        
            fxu(i+1) = (fxu(i))/2;
        end
    elseif f(xr(i)) * f(xu(i)) > 0 %Si esta condición se cumple, la raíz NO está entre xl y xr
        xu(i+1) = xr(i); %El punto medio es el nuevo límite superior.
        xl(i+1) = xl(i); %El límite inferior se mantiene igual.
        fxl(i+1) = f(xl(i+1));
        fxu(i+1) = f(xu(i+1));
        iu = 0;
        il = il + 1;
        %Si usamos dos o más veces seguidas el mismo límite inferior, evaluar en la función y dividir sobre 2
        if il >= 2
            fxl(i+1) = (fxl(i))/2;
        end
    end
    %Asegurarse de que si Niter es muy grande aparezca una alerta.
    try
        xr(i+1)=xu(i+1)-fxu(i+1)*((xu(i+1)-xl(i+1))/(fxu(i+1)-fxl(i+1))); %Actulizamos el punto medio falso y su punto en Y
    catch
        error('Intenta un número menor de iteraciones');
    end
    
    fxr(i+1) = f(xr(i+1));
    Error(i+1) = abs((xr(i+1) - xr(i)) / xr(i+1)) * 100; %Calcula el error relativo actual
    
    if Error(i+1) < Tol %Si el error relativo es menor a la tolerancia exigida, se acaba el ciclo.
        break;
    end
end

M1 = {'xl', 'xr', 'xu', 'f(xl)', 'f(xr)', 'f(xu)', 'Error relativo (%)'};
M2 = num2cell([xl', xr', xu', fxl', fxr', fxu', Error']);
M = [M1; M2];
XR = xr(end);
ER = Error(end);
Iter = i+1;

%Evaluar la función con la raíz aproximada y mensaje de resumen.
Resultado = f(XR);
disp(['Evaluando la función ' func2str(f) ' con ' num2str(XR) ', el resultado es: ' num2str(Resultado)]);
disp(['Error relativo (%): ' num2str(ER)]);
disp(['Número de iteraciones: ' num2str(Iter)]);
