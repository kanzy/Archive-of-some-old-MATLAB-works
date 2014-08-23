%%%2011 july17.m: comparison of Algo 3 (k=50) and Algo 4 at fitLevel 3

figure %Res=1e5, change S/N

subplot(3,1,1)
x=[10, 100, 300, 3000];
y3=[0.11, 0.06, 0.065, 0.06];
y4=[0.065, 0.08, 0.23/3, 0.09];
semilogx(x, y4, 'b*-')
hold on
semilogx(x, y3, 'r*-')
xlabel('S/N')
ylabel('RMSE of D%')

subplot(3,1,2)
y3=[1.61E-03, 1.54E-04, 5.38E-05, 1.04E-05];
y4=[1.615E-03, 2.16E-04, 4.74e-4, 5.45e-4];
semilogx(x, log10(y4), 'b*-')
hold on
semilogx(x, log10(y3), 'r*-')
xlabel('S/N')
ylabel('log_1_0(RMSE3)')

subplot(3,1,3)
y3=[57, 60, 50, 47];
y4=[40.5, 43.5, 40, 40.5];
semilogx(x, y4, 'b*-')
hold on
semilogx(x, y3, 'r*-')
xlabel('S/N')
ylabel('Run Time (sec)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure %S/N=300, change Res

subplot(3,1,1)
x=[1e4, 3e4, 6e4, 1e5, 2.4e5, 2e6];
y3=[0.09, 0.06, 0.06, 0.065, 0.06, 0.03];
y4=[0.07, 0.065, 0.105, 0.23/3, 0.25/3, 0.06];
semilogx(x, y4, 'b*-')
hold on
semilogx(x, y3, 'r*-')
xlabel('log_1_0(Resolution)')
ylabel('RMSE of D%')

subplot(3,1,2)
y3=[2.22e-5, 1.76e-5, 3.2e-5, 5.38e-5, 3.65e-5, 6.45e-5];
y4=[2.62e-4, 4.82e-4, 6.4e-4, 4.74e-4, 2.08e-4, 9.85e-5];
semilogx(x, log10(y4), 'b*-')
hold on
semilogx(x, log10(y3), 'r*-')
xlabel('log_1_0(Resolution)')
ylabel('log_1_0(RMSE3)')

subplot(3,1,3)
y3=[66, 77, 60, 50, 48, 37];
y4=[44, 36, 35, 40, 45, 66];
semilogx(x, y4, 'b*-')
hold on
semilogx(x, y3, 'r*-')
xlabel('log_1_0(Resolution)')
ylabel('Run Time (sec)')
















