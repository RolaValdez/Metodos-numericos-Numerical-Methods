function BusquedaPorIntervalosAUTO(f,Inicio,Fin,Incremento)
%Autor: Rolando Valdez Guzmán
%Alias: Tutoingeniero
%Canal de Youtube: https://www.youtube.com/channel/UCU1pdvVscOdtLpRQBp-TbWg
%Versión: 1.0
%Actualizado: 17/jun/2020

%Búsqueda por Intervalos (versión función) ESPAÑOL
%Llama a esta función desde la ventana de comandos o cualquier script para
%iniciar una búsqueda por intervalos de todas las raíces de una función que 
%hay en un rango determinado y evalua todos los intervalos encontrados que
%contengan raíces con uno de los tres métodos cerrados que cree
%previamente.

% ESTA FUNCION PIDE LOS SIGUIENTES DATOS DE ENTRADA:

% f=función como un identificador de función (function handle) 
%   ej. @(x) cos(x)
% Inicio=Valor inicial del rango de búsqueda.
% Fin=Valor final del rango de búsqueda.
% Incremento=Valor incremental para ir de Inicio hasta Fin.

%NOTA: Esta función usa los códigos BiseccionFcn.m, ReglaFalsaFcn.m y
%ReglaFalsaModFcn.m que hice previamente y NO funcionará sin estos códigos. Puedes
%obtener todos los códigos en estos dos enlaces:
%?https://github.com/RolaValdez/Metodos-numericos-Numerical-Methods
%?https://www.mathworks.com/matlabcentral/fileexchange/77031-libreria-de-metodos-numericos-numerical-methods-library

j=1;
for i=Inicio:Incremento:Fin
    xl=i;                           %Límite inferior actual.
    xu=i + Incremento;              %Límite superior actual.
    fxl=f(xl);                      %Punto en Y para el límite inferior.
    fxu=f(xu);                      %Punto en Y para el límite superior.
    
    if fxl*fxu > 0 %Esta propiedad es la que hace que éste sea un método cerrado.
        continue   %Si no hay una raíz entre xl y xu, pasa a la siguiente iteración.
    else
        x(j,:)=[xl xu]; %Si hay una raíz, guardar ese intervalo actual en un arreglo.
        j=j+1;
    end
end

disp(newline);
fprintf('Raíces encontradas: %d \n',j-1);
disp('Intervalos que contienen una raíz');
x

a=input('Evaluar límites con Bisección (1), Regla Falsa (2) o Regla Falsa Modificada (3) : ');
b=input('Número de iteraciones: ');
c=input('Tolerancia para converger: ');

if a==1 %Evaluar todos los intervalos que contienen a una raíz con cualquiera de estos tres métodos.
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