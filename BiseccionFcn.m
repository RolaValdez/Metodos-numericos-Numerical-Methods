function [M,XR,ER,Iter]=BiseccionFcn(f,xl,xu,Niter,Tol)
%Autor: Rolando Valdez Guzmán
%Alias: Tutoingeniero
%Canal de Youtube: https://www.youtube.com/channel/UCU1pdvVscOdtLpRQBp-TbWg
%Versión: 1.0
%Actualizado: 16/jun/2020

% ESTA FUNCION PIDE LOS SIGUIENTES DATOS DE ENTRADA:

% f=función como un identificador de función (function handle) 
%   ej. @(x) cos(x)
% xl=Límite inferior. Este dato es un escalar.
% xu=Límite superior. Este dato es un escalar.
% Niter=Número de iteraciones (100 por default).
% Tol=Tolerancia para el criterio de convergencia a superar o igualar en
% porcentaje (0.001 por default)

% VARIABLES DE SALIDA:

% M= Tabla de resultados {'xl','xr','xu','f(xl)','f(xr)','f(xu)','Error relativo (%)'}
% XR=Ultima iteración de la raíz de la función.
% ER=Ultima iteracion del error relativo.
% Iter=Número de iteraciones

if nargin<3
    error('Se necesita definir una función y un intervalo a evaluar');
elseif nargin==3
    Niter=100;
    Tol=0.001;
elseif nargin==4
    Tol=0.001;
end

fxl=f(xl); %Punto en Y para el límite inferior.
fxu=f(xu); %Punto en Y para el límite superior.

if fxl*fxu > 0 %Esta propiedad es la que hace que éste sea un método cerrado.
    error('No hay una raíz en ese intervalo!'); 
end

for i = 1:Niter
    
    xr(i)=(xl(i)+xu(i))/2; %Calcula el punto medio actual.
    fxr(i)=f(xr(i)); %Evalua la función en el punto medio actual.
    
    if f(xr(i))*f(xl(i)) > 0 %Si esta condición se cumple, la raíz NO está entre xl y xr
        xl(i+1) = xr(i); %El punto medio es el nuevo límite inferior.
        xu(i+1) = xu(i); %El límite superior se mantiene igual.
        fxl(i+1)=f(xl(i+1));
        fxu(i+1)=f(xu(i+1));
    elseif f(xr(i))*f(xu(i)) > 0 %Si esta condición se cumple, la raíz NO está entre xl y xr
        xu(i+1) = xr(i); %El punto medio es el nuevo límite superior.
        xl(i+1) = xl(i); %El límite inferior se mantiene igual.
        fxl(i+1)=f(xl(i+1));
        fxu(i+1)=f(xu(i+1));
    end
    
    xr(i+1)=(xu(i+1)+xl(i+1))/2; %Actulizamos el punto medio y su punto en Y
    fxr(i+1)=f(xr(i+1));
    Error(i+1)=abs((xr(i+1)-xr(i))/xr(i+1))*100; %Calcula el error relativo actual
    
    if Error(i+1) < Tol %Si el error relativo es menor a la tolerancia exigida, se acaba el ciclo.
        break;
    end
end

M1={'xl','xr','xu','f(xl)','f(xr)','f(xu)','Error relativo (%)'};
M2=num2cell([xl' xr' xu' fxl' fxr' fxu' Error']);
M=[M1; M2];
XR=xr(end);
ER=Error(end);
Iter=i+1;

%Evaluar la función con la raíz aproximada.
Resultado=f(XR);
disp(newline)
disp(['Evaluando la función ' func2str(f) ' con ' num2str(XR) ', el resultado es: ' num2str(Resultado)]);
disp(['Error relativo (%): ' num2str(ER)]);
disp(['Número de iteraciones: ' num2str(Iter)]);
