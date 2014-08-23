


figure


% plot([-10,1],[-10,1],'b')
% hold on
% 
% k=log10(3);
% plot([-10+k,1],[-10,1-k],'b:')
% hold on
% plot([-10,1-k],[-10+k,1],'b:')
% hold on
% 
% k=1;
% plot([-10+k,1],[-10,1-k],'b:')
% hold on
% plot([-10,1-k],[-10+k,1],'b:')
% hold on

X=simSettings.simDarray(1, [3:10, 12:28]);
Y1=fitResults1.DFit;
Y2=fitResults2.DFit;

plot([0,1],[0,1],'k:')
hold on
plot(X, Y1, 'bo')
hold on
plot(X, Y2, 'ro')
hold on

% 
% xlabel('log_1_0(NMR rate)')
% ylabel('log_1_0(MSDFit rate)')