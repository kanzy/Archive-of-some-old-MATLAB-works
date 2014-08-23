%%%aug01.m: for revising Fig2A red lines with Prism newly fit result

clear

h=gcf; %get current figure

a=get(h,'Children'); %a(2): Axes1?

b=get(a(1),'Children');


x=2; %L137
% x=6; %I92
% x=8; %K49

XData=get(b(x),'XData');
% YData=get(b(x),'YData');
% color=get(b(x),'Color')
% figure
% plot(XData,YData,'r')

K=0.02246; %K49
K=2.093e-006; %I92
K=0.0004435; %L137

YData_new=(0.9 - 0.09)*exp(-K*XData) + 0.09;

set(b(x),'YData',YData_new)