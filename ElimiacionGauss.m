function x = EliminacionGauss(A,B)
%Autor: Rolando Valdez Guzmán
%Alias: Tutoingeniero
%Canal de Youtube: https://www.youtube.com/channel/UCU1pdvVscOdtLpRQBp-TbWg
%Versión: 2.1
%Actualizado: 18/may/2022

% ESTA FUNCION PIDE LOS SIGUIENTES DATOS DE ENTRADA:

% A = matriz cuadrada de coeficientes del sistema de ecuaciones.
% B = Vector columna de resultados de cada ecuación.

% VARIABLES DE SALIDA:

% x = vector con los valore para todas las variables del sistema de
% ecuaciones.

%~~~~~~~~~~~~~~~Protección contra errores en las entradas~~~~~~~~~~~~~~~~~%
if nargin ~= 2                 
    error('Se debe ingresar una matriz cuadrada A y un vector columna B');
%Si se ingresan todos los datos de entrada, elegir un método de solución
else                          
    if size(A,1) ~= size(A,2)
        error('Se necesita que la matriz A sea cuadrada')
    elseif size(B,2) ~= 1
        error('B debe ser un vector columna');
    elseif size(A,1) ~= size(B,1)
        error('El número de filas de A no coincide con el de B. Sistema inconsistente');
    end
end

% disp(newline);
% if prod(diag(A)) == 0
%     error('El determinante de la matriz A es cero, no se puede resolver');
% end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Setup~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

n = size(A,1); t = ' | '; T = repmat(t,n,1);
a = num2str(A); b = num2str(B); c = [a T b]; %%unión de los datos en una solo matriz
disp('Sistema original'); disp(c); disp(newline);

%~~~~~~~~~~~~~~~~~~~~~~Eliminación hacia adelante~~~~~~~~~~~~~~~~~~~~~~~~~%

j = 1;
for k = 1:n - 1
    for i = k + 1:n
        if A(i,k) ~= 0 %Si no hay un cero en este elemento, hacer eliminación
            factor = A(i,k)/A(k,k);
            A(i,:) = A(i,:) - factor*A(k,:);
            B(i) = B(i) - factor*B(k);
            c = [num2str(A), T, num2str(B)]; %%unión de los datos en una solo matriz
            disp(['Paso ',num2str(j)]); disp(c); disp(newline);
            j = j+1;
        else
            continue %Si hay un cero, saltarse al siguiente elemento
        end
    end
end

%~~~~~~~~~~~~~~~~~~~~~~~~~Sustitución hacia atrás~~~~~~~~~~~~~~~~~~~~~~~~~%

x(n) = B(n)/A(n,n);
for i = n - 1:-1:1
    sum = B(i);
    for j = i + 1:n
        sum = sum - A(i,j)*x(j);
    end
    x(i) = sum/A(i,i);
end
x = x';

%~~~~~~~~~~~~~~~~~~~~~~~~~Impresión de resultados~~~~~~~~~~~~~~~~~~~~~~~~~%

disp('Resultados');
for i = 1:n
    fprintf('x%d = %f',i,x(i));
    fprintf('\n');
end

