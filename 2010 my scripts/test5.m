


figure

subplot(7,1,1)
plot(Times,TIC,'b','LineWidth',2)
axis([2,6,0,max(TIC)*1.1])
set(gca,'xtick',[])
ylabel('TIC')
hold on

subplot(7,1,2)
plot(XData_R2,YData_R2,'b','LineWidth',2)
axis([2,6,0,max(YData_R2)*1.1])
set(gca,'xtick',[])
ylabel('R^2')
hold on

subplot(7,1,3)
plot(XData_EIC,YData_EIC,'b','LineWidth',2)
axis([2,6,0,max(YData_EIC)*1.1])
set(gca,'xtick',[])
ylabel('EIC')
hold on

subplot(7,1,4)
plot(XData_EIC,YData_EIC.*YData_R2,'b','LineWidth',2)
axis([2,6,0,max(YData_EIC.*YData_R2)*1.1])
ylabel('EIC*R^2')
hold on

xlabel('Retention Time (minute)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure

subplot(7,1,5:7)
plot(XData,YData,'r','LineWidth',1)
v=axis;
axis([v(1),v(2),0,max(YData)*1.1])
ylabel('Intensity')
hold on

xlabel('m/z')

















