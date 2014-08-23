%%%2012-11-02 update
%%%revised from may24.m for Figure 9
%%%modified from may22.m

data=raw;

figure

subplot(2,3,1)

plot([-10,1],[-10,1],'k')
hold on

k=0.5;
plot([-10+k,1],[-10,1-k],'k:')
hold on
plot([-10,1-k],[-10+k,1],'k:')
hold on

k=1;
plot([-10+k,1],[-10,1-k],'k:')
hold on
plot([-10,1-k],[-10+k,1],'k:')
hold on

plot(log10(data(:,1)), log10(data(:,2)), 'bo')
hold on
% plot(log10(data(:,1)), log10(data(:,3)), 'ro')
% hold on

% for i=1:size(data,1)
%     plot([log10(data(i,1)),log10(data(i,1))],[log10(data(i,2)),log10(data(i,3))],'k:')
%     hold on
% end



subplot(2,3,2)

plot([-10,1],[-10,1],'k')
hold on

k=0.5;
plot([-10+k,1],[-10,1-k],'k:')
hold on
plot([-10,1-k],[-10+k,1],'k:')
hold on

k=1;
plot([-10+k,1],[-10,1-k],'k:')
hold on
plot([-10,1-k],[-10+k,1],'k:')
hold on

plot(log10(data(:,1)), log10(data(:,3)), 'ro')
hold on



subplot(2,3,3)

plot([-10,1],[-10,1],'k')
hold on

k=0.5;
plot([-10+k,1],[-10,1-k],'k:')
hold on
plot([-10,1-k],[-10+k,1],'k:')
hold on

k=1;
plot([-10+k,1],[-10,1-k],'k:')
hold on
plot([-10,1-k],[-10+k,1],'k:')
hold on

plot(log10(data(:,1)), log10(data(:,4)), 'mo')
hold on




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(2,3,4)
hold off
hist(log10(data(:,2)./data(:,1)), 50)
hold on

subplot(2,3,5)
hist(log10(data(:,3)./data(:,1)), 50)
hold on

subplot(2,3,6)
hist(log10(data(:,4)./data(:,1)), 50)
hold on

