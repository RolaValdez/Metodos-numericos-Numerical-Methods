function [M,XR,ER,Iter]=BisectionFcn(f,xl,xu,Niter,Tol)
%Author: Rolando Valdez Guzmán
%Aka: Tutoingeniero
%Youtube channel: https://www.youtube.com/channel/UCU1pdvVscOdtLpRQBp-TbWg
%Versinn: 1.0
%Updated: 16/jun/2020

%MBisection method (function version) ENGLISH.
%Call this function from the command window or any other script to find 
%the root of a function given an interval and get a results table.


% THIS FUNCTION NEEDS THE FOLLOWING INPUTS:

% f=Function as a function handle
%   example: @(x) cos(x)
% xl=Lower limit. This is a scalar.
% xu=Upper limit. This is a scalar.
% Niter=Number of iterations (100 by default).
% Tol=Minimum relative error for convergence criteria (0.001 by default)

% OUTPUTS:

% M= Results table {'xl','xr','xu','f(xl)','f(xr)','f(xu)','Relative error (%)'}
% XR=Last iteration for the function root.
% ER=Last iteraton for the relative error.
% Iter=Number of iterations used.

if nargin<3                 %If you give less than three inputs...
    error('You need to define a function and an interval');
elseif nargin==3            %If you give only three inputs...
    Niter=100;
    Tol=0.001;
elseif nargin==4            %If you give only four inputs...
    Tol=0.001;
end

fxl=f(xl); %Function evaluated with lower limit.
fxu=f(xu); %Funtion evaluated with upper limit.

if fxl*fxu > 0 %This property is what makes a closed method work.
    error('There is no root inside this interval!'); 
end

for i = 1:Niter
    
    xr(i)=(xl(i)+xu(i))/2; %Calculate the current midpoint.
    fxr(i)=f(xr(i)); %Evaluate the function with the current midpoint.
    
    if f(xr(i))*f(xl(i)) > 0 %If this condition is true, the root is NOT between xl and xr
        xl(i+1) = xr(i); %The midpoint is the new lower limit.
        xu(i+1) = xu(i); %The upper limit stays the same.
        fxl(i+1)=f(xl(i+1));
        fxu(i+1)=f(xu(i+1));
    elseif f(xr(i))*f(xu(i)) > 0 %If this condition is true, the root is NOT between xu and xr
        xu(i+1) = xr(i); %The midpoint is the new upper limit.
        xl(i+1) = xl(i); %%The lower limit stays the same.
        fxl(i+1)=f(xl(i+1));
        fxu(i+1)=f(xu(i+1));
    end
    
    xr(i+1)=(xu(i+1)+xl(i+1))/2; %Update the midpoint and evaluate the function with the new midpoint
    fxr(i+1)=f(xr(i+1));
    Error(i+1)=abs((xr(i+1)-xr(i))/xr(i+1))*100; %Calculate the current relative error
    
    if Error(i+1) < Tol %If the current relative error is less than the tolerance for convergence, end the cycle.
        break;
    end
end

M1={'xl','xr','xu','f(xl)','f(xr)','f(xu)','Relative error (%)'};
M2=num2cell([xl' xr' xu' fxl' fxr' fxu' Error']);
M=[M1; M2];
XR=xr(end);
ER=Error(end);
Iter=i+1;

%Evaluate the function with the approximated function and show a summary message.
Result=f(XR);
disp(newline)
disp(['Evaluating the function ' func2str(f) ' with the "root" ' num2str(XR) ', the result is: ' num2str(Result)]);
disp(['Relative error (%): ' num2str(ER)]);
disp(['Number of iterations used: ' num2str(Iter)]);
