%Autor: Rolando Valdez Guzmán
%Alias: Tutoingeniero
%Canal de Youtube: https://www.youtube.com/channel/UCU1pdvVscOdtLpRQBp-TbWg
%Versión: 1.0
%Actualizado: 17/jun/2020

%Búsqueda por intervalos versión interactiva ESPAÑOL
%Grafica una función y desplaza la gráfica a la izquierda o derecha con las
%flechas del teclado ? ? y/o acércate o aléjate con ? ?, cuando estés listo,
%presiona Enter para activar la mira de francotirador y selecciona
%manualmente intervalos que contengan a una raíz. Cuando termines de
%seleccionar intervalos, presiona Enter de nuevo y obtendrás las
%coordenadas X que contienen raíces en una sola variable.

%NOTA: Esta función usa los códigos BiseccionFcn.m, ReglaFalsaFcn.m y
%ReglaFalsaModFcn.m que hice previamente y NO funcionará sin estos códigos. Puedes
%obtener todos los códigos en estos dos enlaces:
%?https://github.com/RolaValdez/Metodos-numericos-Numerical-Methods
%?https://www.mathworks.com/matlabcentral/fileexchange/77031-libreria-de-metodos-numericos-numerical-methods-library

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Setup~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

clc; clear all;

global f intervalo lims %Variables globales
f=@(x) x*sin(x) - sqrt(x); %Función anónima a gráficar.
intervalo=[-10 10];        %Intervalo inicial de graficación.
h=figure('WindowKeyPressFcn',@DesplazarGrafica,'DeleteFcn',@Cerrar); %Funciones auxiliares.
fplot(f,intervalo);        %Graficar.
line(intervalo,[0 0],'Color','k','LineWidth',1); %Resaltar el eje X.
grid on

%%
function DesplazarGrafica(h,event)
global f intervalo lims
switch event.Key 
    case 'leftarrow' %Si presionas la flecha izquierda, desplazar la gráfica a la izquierda.
        intervalo=intervalo-1;
    case 'rightarrow' %Si presionas la flecha derecha, desplazar la gráfica a la derecha.
        intervalo=intervalo+1;
    case 'downarrow' %Si presionas la flecha abajo, alegar la gráfica.
        intervalo=intervalo + [-1 1];
    case 'uparrow'   %Si presionas la flecha arriba, acercar la gráfica.
        intervalo=intervalo + [1 -1];
end

fplot(f,intervalo); %Actualizar la gráfica.
line(intervalo,[0 0],'Color','k','LineWidth',1);
grid on

%Cuando termines de mover la gráfica, presiona enter.
switch event.Key
    case 'return'
        [x,y]=ginput;  %Activa la mira de francotirador y selecciona puntos de la gráfica.
        j=1;
        for i=1:length(x)/2 %Guarda todas las coordenadas X de los puntos elegidos en un arreglo
            lims(i,:)=[x(j) x(j+1)];
            j=j+2;
        end
        %Cuando termines de elegir puntos, presiona enter de nuevo.
end
end

function x=Cerrar(figure,event) %Cuando cierres la gráfica, evalua los intervalos elegidos con un método.
global f lims
x=lims
a=input('Evaluar límites con Bisección (1), Regla Falsa (2) o Regla Falsa Modificada (3) : ');
b=input('Número de iteraciones: ');
c=input('Tolerancia para converger: ');

if a==1
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

