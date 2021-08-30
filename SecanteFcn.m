function [XR,EA,M] = SecanteFcn(f,x0,xi,Niter,es)
%Autor: Rolando Valdez Guzmán
%Alias: Tutoingeniero
%Canal de Youtube: https://www.youtube.com/channel/UCU1pdvVscOdtLpRQBp-TbWg
%Versión: 3.0
%Actualizado: 3/ene/2021

% ESTA FUNCION PIDE LOS SIGUIENTES DATOS DE ENTRADA:

% f = función como una función anónima ej. @(x) cos(x) + x
% x0 = Valor inicial de x. Este dato es un escalar.
% xi = Valor inicial de x mas un incremento, de preferencia pequeño.
% Niter = Número de iteraciones.
% es = Error relativo porcentual máximo. 

% VARIABLES DE SALIDA:

% XR = Ultima iteración de la raíz de la función.
% ER = Ultima iteracion del error relativo.
% M = Tabla de resultados {'xi','Error relativo (%)'}

%METODOS DE SOLUCION

%Método 1: Si Niter está vacío (Niter = []) entonces se debe especificar un
%error relativo máximo para converger.
%Método 2: Si Tol está vacío (Tol = []) entonces se debe especificar un
%número máximo de iteraciones para el código. Es posible que un número muy
%grande de iteraciones cree un error y un mensaje aparecerá sugiriendo
%reducir el número de iteraciones.

%Protección contra errores en las entradas.
if nargin ~= 5                 
    error('Se necesita definir una función, un intervalo a evaluar, un número máximo de iteraciones y un error relativo mínimo');
%Si se ingresan todos los datos de entrada, elegir un método de solución
else                          
    if  isempty(Niter) == 1 
        metodo = 1; Niter = 1000;
        disp(newline);
        disp('Solución por error relativo establecido para converger');
    elseif isempty(es) == 1 
        metodo = 2; disp(newline);
        disp('Solución por número máximo de iteraciones para converger');
    elseif isempty(Niter) == 0 && isempty(es) == 0
        error('Niter y es no pueden tener un dato de entrada al mismo tiempo, uno de los dos debe estar vacío (ejemplo: Niter = [])');
    end
end

osc = 0;
for i = 1:Niter + 1
    
    xi_2(i) = xi(i) - (f(xi(i))*(x0(i)-xi(i)))/(f(x0(i)) - f(xi(i)));
    xi(i+1) = xi_2(i); x0(i+1) = xi(i); fxi(i) = f(xi(i));
    ea(i) = abs((xi(i+1) - xi(i)) / xi(i+1)) * 100; %Calcula el error relativo actual
    
    if xi(i+1) == 0
        error('Derivada aproximada de la función igual a cero. Utilice otros valores iniciales para xi y x0');
    end
    
    if i >= 2
        if xi(i+1) == xi(i-1) && ea(i) > es
            osc = osc + 1;
            if osc == 3
                error('Divergencia oscilatoria detectada. Use otro valor inicial de x');
            end
        end
    end
    
    if i >= 30 && ea(i) > es
        error('Convergencia lenta o divergencia detectada. Use otro valor inicial de x');
    end
    
    if metodo == 1
        if ea(i) < es %Si el error relativo es menor a la tolerancia exigida, se acaba el ciclo.
            break;
        end
    end
end

M1 = {'xi', 'f(xi)','Error relativo (%)'};
M2 = num2cell([xi(1:end-1)',fxi',ea']);
M = [M1; M2]; XR = xi(end); EA = ea(end);