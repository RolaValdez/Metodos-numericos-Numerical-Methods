function x = GaussJordan(A,B)
%Autor: Rolando Valdez Guzmán
%Alias: Tutoingeniero
%Canal de Youtube: https://www.youtube.com/channel/UCU1pdvVscOdtLpRQBp-TbWg
%Versión: 2.0
%Actualizado: 3/sep/2021

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

if det(A) == 0
    error('El determinante de la matriz A es cero, no se puede resolver');
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Setup~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

n = size(A,1); t = ' | '; T = repmat(t,length(A(:,1)),1);
%%unión de los datos en una solo matriz
a = num2str(A); b = num2str(B); c = [a T b]; 
disp('Sistema original'); disp(c); disp(newline);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Pivoteo parcial~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

disp('Paso 0: Reordenar ecuaciones');
for k = 1:n
    if A(k,k) ~= max(abs(A(:,k)))
        [filapivote,~] = find(abs(A) == max(abs(A(:,k))));
        A([k,filapivote(1)],:) = A([filapivote(1),k],:);
        B([k,filapivote(1)]) = B([filapivote(1),k]);
%         c = [num2str(A), T, num2str(B)]
    end
end
c = [num2str(A), T, num2str(B)]; %%unión de los datos en una solo matriz
disp(c); disp(newline);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Gauss-Jordan~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

j = 1;
for k = 1:n
    if A(k,k) ~= 1 %%si el elemento i,i de la diagonal es diferente de 1
        B(k) = B(k)/A(k,k);
        A(k,:) = A(k,:)./A(k,k);
        c = [num2str(A), T, num2str(B)]; %%unión de los datos en una solo matriz
        disp(['Paso ',num2str(j),': Normalizar la ecuación ',num2str(k)]); 
        disp(c); disp(newline);
        j = j+1;
    end
    
    for i = 1:n
        if i ~= k
            factor = A(i,k)/A(k,k);
            A(i,:) = A(i,:) - factor*A(k,:);
            B(i) = B(i) - factor*B(k);
            c = [num2str(A), T, num2str(B)]; %%unión de los datos en una solo matriz
            disp(['Paso ',num2str(j)]); disp(c); disp(newline);
            j = j+1;
        end
    end
    x = B;
end

%~~~~~~~~~~~~~~~~~~~~~~~~~Impresión de resultados~~~~~~~~~~~~~~~~~~~~~~~~~%

for i = 1:n
    fprintf('x%d = %f',i,x(i));
    fprintf('\n');
end