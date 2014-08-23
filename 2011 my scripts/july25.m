%%%2010-08-03 figdata.m: extract original raw data of mass spectrum from ExMS_pepscansview.fig 

clear
clc

h=gcf %get current figure
% get(h) %show its properties

a=get(h,'Children') %get h's children: Axes 1 and Axes 2
% get(a(1)) %a(1) is Axes 1: show its properties
% get(a(2)) %a(2) is Axes 2: show its properties

a1=get(a(1),'Children') %get Axes 1 (i.e., a(1))'s children
a2=get(a(2),'Children')

XData1=get(a1(1),'XData'); %raw MS data
YData1=get(a1(1),'YData');

XData2=get(a1(2),'XData'); %old blue lines
YData2=get(a1(2),'YData');
x=get(a1(2),'Children');

XData3=get(a1(4),'XData'); %old red lines
YData3=get(a1(4),'YData');



YData2n=zeros(size(YData2));
for i=1:size(XData2,2)
    Max=0;
    for j=1:size(XData1,2)
        if XData1(1,j)>=XData2(1,i)-0.005 && XData1(1,j)<=XData2(1,i)+0.005
            if YData1(j)>Max
                Max=YData1(j);
            end
        end
    end
    YData2n(i)=Max;
end
set(x(2),'YData',YData2n)


% 
% 
% YData3n=zeros(size(YData3));
% for i=1:size(XData3,2)
%     Max=0;
%     for j=1:size(XData1,2)
%         if XData1(1,j)>=XData3(1,i)-0.01 && XData1(1,j)<=XData3(1,i)+0.01
%             if YData1(j)>Max
%                 Max=YData1(j);
%             end
%         end
%     end
%     YData3n(i)=Max;
% end
% 
% 
% 
% 
% figure
% 
% stem(XData2,YData2,'b:')
% hold on
% stem(XData2,YData2n,'g')
% hold on
% stem(XData3,YData3,'r:')
% hold on
% stem(XData3,YData3n,'m')
% hold on
% plot(XData1,YData1,'k')
% hold on
% 
% % FigData=[XData',YData'];
% % save('figdata.txt', 'FigData', '-ascii', '-tabs')
% % 
% % disp('XData and YData have been extracted and now in workspace!')
% % disp('Also a copy of text file has been saved in MATLAB current directory.')
% 
