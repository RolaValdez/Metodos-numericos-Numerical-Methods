function [xn,M] = NewtonRhapsonMultiFcn(f,xi,Niter,es)
%Autor: Rolando Valdez Guzmán
%Alias: Tutoingeniero
%Canal de Youtube: https://www.youtube.com/channel/UCU1pdvVscOdtLpRQBp-TbWg
%Versión: 3.0
%Actualizado: 23/ago/2021

% ESTA FUNCION PIDE LOS SIGUIENTES DATOS DE ENTRADA:

% f = función como un vector celda de caracteres 
%   ej. {'4*xy -2*x + y' ; x^2 + y - 1};
% xi = Vector de valores iniciales de las variable independientes [xi,yi,zi]
    %ej. [1,2,3]
% Niter = Número de iteraciones.
% es = Error relativo porcentual máximo. 

% VARIABLES DE SALIDA:

% xn = Ultimas iteraciones de las raices de la función.
% M = Tabla de resultados {'xi',yi','Error relativo (%)'}

%METODOS DE SOLUCION

%Método 1: Si Niter está vacío (Niter = []) entonces se debe especificar un
%error relativo máximo para converger.
%Método 2: Si Tol está vacío (Tol = []) entonces se debe especificar un
%número máximo de iteraciones para el código. Es posible que un número muy
%grande de iteraciones cree un error y un mensaje aparecerá sugiriendo
%reducir el número de iteraciones.

%Protección contra errores en las entradas.
if nargin ~= 4                 
    error('Se necesita definir una función, dos valores iniciales, un número máximo de iteraciones y un error aproximado máximo');
%Si se ingresan todos los datos de entrada, elegir un método de solución
else                          
    if  isempty(Niter) == 1 
        metodo = 1; Niter = 1000;
        disp(newline); disp('Solución por error relativo establecido para converger');
    elseif isempty(es) == 1 
        metodo = 2; disp(newline);
        disp('Solución por número máximo de iteraciones para converger');
    elseif isempty(Niter) == 0 && isempty(es) == 0
        error('Niter y es no pueden tener un dato de entrada al mismo tiempo, uno de los dos debe estar vacío (ejemplo: Niter = [])');
    end
end

fs = str2sym(f); vs = symvar(fs);
J = jacobian(fs,vs); ea = zeros(1,length(xi));

if length(vs) ~= length(xi) || length(fs) ~= length(xi)
    error('El sistema de ecuaciones debe ser cuadrado, con el mismo número de variables que de ecuaciones simultáneas');    
end

osc = 0;
for i = 1:Niter - 1
    xi(i+1,:) = xi(i,:)' - double((subs(J,vs,xi(i,:)))\subs(fs,vs,xi(i,:)));
    ea(i+1,:) = abs((xi(i+1,:) - xi(i,:)) ./ xi(i+1,:)) * 100;
    
    if isnan(ea(i+1,:))
        error('Divergencia detectada. Use otros valores iniciales');
    end
    
    if i >= 2
        if xi(i+1,:) == xi(i-1,:) 
            osc = osc + 1;
            if osc == 3
                error('Divergencia oscilatoria detectada. Use otros valores iniciales');
            end
        end
    end
    
    if i >= 30
        if any(ea(i+1,:) > es)
            error('Convergencia lenta o divergencia detectada. Use otros valores iniciales');
        end
    end
    
    if metodo == 1
        if ea(i+1,:) < es  %Si el error relativo es menor a la tolerancia exigida, se acaba el ciclo.
            break;
        end
    end
end

E1 = strseq('x',1:length(vs))';
E2 = strseq('Ea (%) de x',1:length(vs))';
Encabezado = [E1,E2];
Datos = num2cell([xi,ea]);
xn = xi(end,:)';
M = [Encabezado ; Datos];

