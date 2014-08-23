
figure

x=algo1data;
subplot(1,2,1)
plot(log10(x(:,2)), log10(x(:,3)), 'ro')
hold on
plot(log10(x(:,2)), log10(x(:,4)), 'bo')
hold on

for i=1:size(x,1)
    plot([log10(x(i,2)),log10(x(i,2))],[log10(x(i,3)),log10(x(i,4))],'k:')
    hold on
end
hold on
plot([-9,1], [-9,1], 'k:')


x=algo2data;
subplot(1,2,2)
plot(log10(x(:,2)), log10(x(:,3)), 'ro')
hold on
plot(log10(x(:,2)), log10(x(:,4)), 'bo')
hold on

for i=1:size(x,1)
    plot([log10(x(i,2)),log10(x(i,2))],[log10(x(i,3)),log10(x(i,4))],'k:')
    hold on
end
hold on
plot([-9,1], [-9,1], 'k:')