function [M,xn] = GaussJacobi(A,B,xi,Niter,es)
%Autor: Rolando Valdez Guzmán
%Alias: Tutoingeniero
%Canal de Youtube: https://www.youtube.com/channel/UCU1pdvVscOdtLpRQBp-TbWg
%Versión: 1.1
%Actualizado: 31/dic/2021

% ESTA FUNCION PIDE LOS SIGUIENTES DATOS DE ENTRADA:

% A = matriz cuadrada de coeficientes del sistema de ecuaciones.
% B = Vector columna de resultados de cada ecuación.
% xi = Valores iniciales para cada variable.
% N = Número de iteraciones
% es = Error estimado en porcentaje

%METODOS DE SOLUCION

%Método 1: Si Niter está vacío (Niter = []) entonces se debe especificar un
%error relativo máximo para converger.
%Método 2: Si "es" está vacío ("es" = []) entonces se debe especificar un
%número máximo de iteraciones para el código.


% VARIABLES DE SALIDA:

% M = Tabla de iteraciones para los valores de cada variable y sus errores
% aproximados.
% xn = Resultados del sistema tras la convergencia.

%~~~~~~~~~~~~~~~Protección contra errores en las entradas~~~~~~~~~~~~~~~~~%
if nargin < 5                 
    error('Insuficientes datos de entrada. Lea las instrucciones del código para más información');
else                          
    if size(A,1) ~= size(A,2)
        error('Se necesita que la matriz A sea cuadrada')
    elseif size(B,2) ~= 1
        error('B debe ser un vector columna');
    elseif size(A,1) ~= size(B,1)
        error('El número de filas de A no coincide con el de B. Sistema inconsistente');
    elseif size(A,1) ~= length(xi)
        error('Se debe ingresar un valor inicial para cada variable del sistema');
    end
end

%Si se ingresan todos los datos de entrada y no hay errores, elegir un método de solución
if  isempty(Niter) == 1
    metodo = 1; Niter = 100; disp(newline);
    disp('Solución por error aproximado establecido para converger');
elseif isempty(es) == 1
    metodo = 2; disp(newline);
    disp('Solución por número máximo de iteraciones para converger');
elseif isempty(Niter) == 0 && isempty(es) == 0
    error('Niter y es no pueden tener un dato de entrada al mismo tiempo, uno de los dos debe estar vacío (ejemplo: Niter = [])');
end

if det(A) == 0
    error('El determinante de la matriz A es cero, no se puede resolver');
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Pivoteo parcial~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

for k = 1:length(B)
    if A(k,k) ~= max(abs(A(:,k)))
        [filapivote,~] = find(abs(A) == max(abs(A(:,k))));
        A([k,filapivote(1)],:) = A([filapivote(1),k],:);
        B([k,filapivote(1)]) = B([filapivote(1),k]);
    end
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~GaussJacobi~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

ea = zeros(1,length(xi)); xn = zeros(1,length(xi)); indx = 1:length(xi);
for i = 1:Niter - 1
    for j = 1:length(B)
        col = indx(indx ~= j);
        xi(i+1,j) = (B(j) - sum(A(j,col).*xi(i,col)))/A(j,j);
    end
    ea(i+1,:) = abs((xi(i+1,:) - xi(i,:)) ./ xi(i+1,:)) * 100;
    
    if i >= 30
        if any(ea(i+1,:) > es)
            error('Convergencia lenta o divergencia detectada. Use otros valores iniciales');
        end
    end
    
    if metodo == 1
        if ea(i+1,:) < es %Si el error relativo es menor a la tolerancia exigida, se acaba el ciclo.
            break;
        end
    end
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Resultados~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

for i = 1:length(B)
    E1(i) = cellstr(['x',num2str(i)]);
    E2(i) = cellstr(['Ea (%) de x', num2str(i)])';
end
Encabezado = [E1,E2]; Datos = num2cell([xi,ea]);
xn = xi(end,:)'; M = [Encabezado ; Datos];
