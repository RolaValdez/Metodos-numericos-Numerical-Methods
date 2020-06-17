function BusquedaPorIntervalosAUTO(f,Inicio,Fin,Incremento)
%Autor: Rolando Valdez Guzm�n
%Alias: Tutoingeniero
%Canal de Youtube: https://www.youtube.com/channel/UCU1pdvVscOdtLpRQBp-TbWg
%Versi�n: 1.0
%Actualizado: 17/jun/2020

%B�squeda por Intervalos (versi�n funci�n) ESPA�OL
%Llama a esta funci�n desde la ventana de comandos o cualquier script para
%iniciar una b�squeda por intervalos de todas las ra�ces de una funci�n que 
%hay en un rango determinado y evalua todos los intervalos encontrados que
%contengan ra�ces con uno de los tres m�todos cerrados que cree
%previamente.

% ESTA FUNCION PIDE LOS SIGUIENTES DATOS DE ENTRADA:

% f=funci�n como un identificador de funci�n (function handle) 
%   ej. @(x) cos(x)
% Inicio=Valor inicial del rango de b�squeda.
% Fin=Valor final del rango de b�squeda.
% Incremento=Valor incremental para ir de Inicio hasta Fin.

%NOTA: Esta funci�n usa los c�digos BiseccionFcn.m, ReglaFalsaFcn.m y
%ReglaFalsaModFcn.m que hice previamente y NO funcionar� sin estos c�digos. Puedes
%obtener todos los c�digos en estos dos enlaces:
%?https://github.com/RolaValdez/Metodos-numericos-Numerical-Methods
%?https://www.mathworks.com/matlabcentral/fileexchange/77031-libreria-de-metodos-numericos-numerical-methods-library

j=1;
for i=Inicio:Incremento:Fin
    xl=i;                           %L�mite inferior actual.
    xu=i + Incremento;              %L�mite superior actual.
    fxl=f(xl);                      %Punto en Y para el l�mite inferior.
    fxu=f(xu);                      %Punto en Y para el l�mite superior.
    
    if fxl*fxu > 0 %Esta propiedad es la que hace que �ste sea un m�todo cerrado.
        continue   %Si no hay una ra�z entre xl y xu, pasa a la siguiente iteraci�n.
    else
        x(j,:)=[xl xu]; %Si hay una ra�z, guardar ese intervalo actual en un arreglo.
        j=j+1;
    end
end

disp(newline);
fprintf('Ra�ces encontradas: %d \n',j-1);
disp('Intervalos que contienen una ra�z');
x

a=input('Evaluar l�mites con Bisecci�n (1), Regla Falsa (2) o Regla Falsa Modificada (3) : ');
b=input('N�mero de iteraciones: ');
c=input('Tolerancia para converger: ');

if a==1 %Evaluar todos los intervalos que contienen a una ra�z con cualquiera de estos tres m�todos.
    for i=1:size(x,1)
        [M,XR,ER,Iter]=BiseccionFcn(f,x(i,1),x(i,2),b,c);
    end
elseif a==2
    for i=1:size(x,1)
        [M,XR,ER,Iter]=ReglaFalsaFcn(f,x(i,1),x(i,2),b,c);
    end
elseif a==3
    for i=1:size(x,1)
        [M,XR,ER,Iter]=ReglaFalsaModFcn(f,x(i,1),x(i,2),b,c);
    end
end
end