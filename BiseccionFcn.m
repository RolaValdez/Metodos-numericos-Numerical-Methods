function [M,XR,ER,Iter]=BiseccionFcn(f,xl,xu,Niter,Tol)
%Autor: Rolando Valdez Guzm�n
%Alias: Tutoingeniero
%Canal de Youtube: https://www.youtube.com/channel/UCU1pdvVscOdtLpRQBp-TbWg
%Versi�n: 1.0
%Actualizado: 16/jun/2020

%M�todo de la bisecci�n (versi�n funci�n) ESPA�OL.
%Llama a esta funci�n desde la ventana de comandos o cualquier script para
%encontrar la ra�z de una funci�n en un intervalo y obt�n una tabla con el
%proceso.

% ESTA FUNCION PIDE LOS SIGUIENTES DATOS DE ENTRADA:

% f=funci�n como un identificador de funci�n (function handle) 
%   ej. @(x) cos(x)
% xl=L�mite inferior. Este dato es un escalar.
% xu=L�mite superior. Este dato es un escalar.
% Niter=N�mero de iteraciones (100 por default).
% Tol=Tolerancia para el criterio de convergencia a superar o igualar en
% porcentaje (0.001 por default)

% VARIABLES DE SALIDA:

% M= Tabla de resultados {'xl','xr','xu','f(xl)','f(xr)','f(xu)','Error relativo (%)'}
% XR=Ultima iteraci�n de la ra�z de la funci�n.
% ER=Ultima iteracion del error relativo.
% Iter=N�mero de iteraciones

if nargin<3                 %Si se ingresan menos de tres datos de entrada...
    error('Se necesita definir una funci�n y un intervalo a evaluar');
elseif nargin==3            %Si se ingresan s�lo tres datos de entrada...
    Niter=100;
    Tol=0.001;
elseif nargin==4            %Si se ingresan s�lo cuatro datos de entrada...
    Tol=0.001;
end

fxl=f(xl); %Punto en Y para el l�mite inferior.
fxu=f(xu); %Punto en Y para el l�mite superior.

if fxl*fxu > 0 %Esta propiedad es la que hace que �ste sea un m�todo cerrado.
    error('No hay una ra�z en ese intervalo!'); 
end

for i = 1:Niter
    
    xr(i)=(xl(i)+xu(i))/2; %Calcula el punto medio actual.
    fxr(i)=f(xr(i)); %Evalua la funci�n en el punto medio actual.
    
    if f(xr(i))*f(xl(i)) > 0 %Si esta condici�n se cumple, la ra�z NO est� entre xl y xr
        xl(i+1) = xr(i); %El punto medio es el nuevo l�mite inferior.
        xu(i+1) = xu(i); %El l�mite superior se mantiene igual.
        fxl(i+1)=f(xl(i+1));
        fxu(i+1)=f(xu(i+1));
    elseif f(xr(i))*f(xu(i)) > 0 %Si esta condici�n se cumple, la ra�z NO est� entre xl y xr
        xu(i+1) = xr(i); %El punto medio es el nuevo l�mite superior.
        xl(i+1) = xl(i); %El l�mite inferior se mantiene igual.
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

%Evaluar la funci�n con la ra�z aproximada y mensaje de resumen.
Resultado=f(XR);
disp(newline)
disp(['Evaluando la funci�n ' func2str(f) ' con ' num2str(XR) ', el resultado es: ' num2str(Resultado)]);
disp(['Error relativo (%): ' num2str(ER)]);
disp(['N�mero de iteraciones: ' num2str(Iter)]);
