

figure 

x=[3, 5, 8, 10, 12];
y2=[0.052, 0.04, 0.049, 0.078, 0.067]; %by FL2
y3=[0.0054, 0.011, 0.026, 0.068, 0.065]; %by FL3
plot(x, y2, 'b*-')
hold on
plot(x, y3, 'r*-')
xlabel('Number of Fitted D Sites')
ylabel('RMSE of D%')