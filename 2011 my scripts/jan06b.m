

% c=colormap(jet(70));
% figure
% % plot(data(1,6),data(1,7),'o','Color',c(1,:))
% plot(data(1,6),data(1,7),'ko')
% hold on
% n=1;
% for i=2:size(data,1)
% %     plot(data(i,6),data(i,7),'o','Color',c(n,:))
% plot(data(i,6),data(i,7),'ko')
%     hold on
%     if abs(data(i,4)-data(i-1,4))<=0.02
%         plot([data(i-1,6),data(i,6)],[data(i-1,7),data(i,7)],'Color',c(n,:))
%         hold on
%     else
%         n=n+1;
%     end
% end


figure
subplot(2,1,1)
plot(1,data(1,7),'ko')
hold on
n=1;
for i=2:size(data,1)
    if abs(data(i,4)-data(i-1,4))<=0.02
        plot(n,data(i,7),'ko')
        hold on
        plot([n,n],[data(i,7),data(i-1,7)])
        hold on
    else
        n=n+1;
        plot(n,data(i,7),'ko')
        hold on
    end
end
plot([-1 71],[2.9 2.9],'k:')
hold on
ylabel('XCorr')
axis([-1 71 -0.5 8.1])

subplot(2,1,2)
plot(1,data(1,6),'ko')
hold on
n=1;
for i=2:size(data,1)
    if abs(data(i,4)-data(i-1,4))<=0.02
        plot(n,data(i,6),'ko')
        hold on
        plot([n,n],[data(i,6),data(i-1,6)],'r')
        hold on
    else
        n=n+1;
        plot(n,data(i,6),'ko')
        hold on
    end
end
ylabel('P Score')
xlabel('Isobaric Peptide Pairs')
axis([-1 71 -0.125 1.125])


    