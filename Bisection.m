%Author: Rolando Valdez Guzmán
%Aka: Tutoingeniero
%Youtube channel: https://www.youtube.com/channel/UCU1pdvVscOdtLpRQBp-TbWg
%Versinn: 1.0
%Updated: 17/jun/2020

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Setup~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

%Bisection method (interactive version) ENGLISH
%Give inputs to find the root of a function in an interval and press Enter
%key several times to watch the process step by step.

clc; clear all;

f=@(x) cos(x)+x; %Function of x.
fplot(f,'k-','LineWidth',2); %Plot the function.
title(func2str(f)); hold on; grid on; 
line([-5 5],[0 0],'Color','k','LineStyle','--'); %Highlight X axis.
line([0 0],[-5 5],'Color','k','LineStyle','--') %Highlight Y axis.

xl=-2; %Lower limit.
xu=0; %Upper limit.
fxl=f(xl); %Function evaluated with lower limit.
fxu=f(xu); %Function evaluated with upper limit.
Niter=100; %Number of iterations. A 100 is recommended for most cases.
Tol=0.01; %Minimum relative error for convergence criteria.

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~Algorithm~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

x = linspace(xl,xu,100);
ylim = [min(f(x)),max(f(x))];
if fxl*fxu > 0 %This property is what makes a closed method work.
    error('There is no root inside that interval!'); 
end

obj=plot([xl,xu],[fxl,fxu],'ko','markerfacecolor','b'); %Plot xl and xu as dots.
fprintf('Press a key to continue \n'); pause;

for i = 1:Niter
    % Bisection
    xr(i)=(xl(i)+xu(i))/2; %Calculate the current midpoint.
    fxr(i)=f(xr(i)); %Evaluate the function with the current midpoint.
    
    if f(xr(i))*f(xl(i)) > 0 %If this condition is true, the root is NOT between xl and xr
        xl(i+1) = xr(i); %The midpoint is now the new lower limit.
        xu(i+1) = xu(i); %The upper limit stays the same.
        fxl(i+1)=f(xl(i+1));
        fxu(i+1)=f(xu(i+1));
    elseif f(xr(i))*f(xu(i)) > 0 %If this condition is true, the root is NOT between xr and xu
        xu(i+1) = xr(i); %The midpoint is now the new upper limit.
        xl(i+1) = xl(i); %The upper limit stays the same.
        fxl(i+1)=f(xl(i+1));
        fxu(i+1)=f(xu(i+1));
    end
    
    xr(i+1)=(xu(i+1)+xl(i+1))/2; %Update the midpoint and evaluate the function with it.
    fxr(i+1)=f(xr(i+1));
    Error(i+1)=abs((xr(i+1)-xr(i))/xr(i+1))*100; %Calculate the current relative error.
    
    %Plot the new points
    obj1 = plot(xr(i),fxr(i),'ko','markerfacecolor','r'); %Plot the current midpoint.
    obj2 = plot([xr(i),xr(i)],ylim,'r--'); %Plot a vertical line that passes through the current midpoint.
    fprintf('Press a key to continue\n'); pause;
    
    %Plot the new interval
    delete(obj1); delete(obj2); %Erase the current midpoint and the line that goes through it.
    set(obj,'markerfacecolor','w'); %Make white the point that is not useful anymore.
    obj=plot([xl(i+1),xu(i+1)],[fxl(i+1),fxu(i+1)],'ko','markerfacecolor','b'); %Update the limits.
    fprintf('Press a key to continue\n'); pause;
    
    if Error(i+1) < Tol %If the relative error is less than the convergence criteria, end the cycle.
        fprintf('Convergence!\n'); 
        obj1 = plot(xr(i),fxr(i),'ko','markerfacecolor','r');
        obj2 = plot([xr(i),xr(i)],ylim,'r--');
        break;
    end
end

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Results~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

Root=xr(end)
Relative_Error=Error(end)
Number_Iterations=i+1
