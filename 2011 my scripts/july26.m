%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure

colors=cell(size(similarPeptides,1),1);

for i=1:1
    colors{i}='r';
    predictPeaks=ones((1+similarPeptides(i,5)+similarPeptides(i,6)),2);
    for j=1:size(predictPeaks,1)
        predictPeaks(j,1)=similarPeptides(i,4)+deltamass(j-1)/similarPeptides(i,3); %call deltamass.m 2010-09-03
        Max=0;
        for k=1:size(XData,1)
            if XData(k)>predictPeaks(j,1)-0.005 && XData(k)<predictPeaks(j,1)+0.005
                if YData(k)>Max
                    Max=YData(k);
                end
            end
        end
        predictPeaks(j,2)=Max;
    end
    stem(predictPeaks(:,1),predictPeaks(:,2),':','color',colors{i}, 'MarkerSize',6)
    hold on
    text(522.6, max(YData)*(0.9-0.2*rem(i,5))*0.75, [num2str(similarPeptides(i,1)), '--', num2str(similarPeptides(i,2)),' +', num2str(similarPeptides(i,3))],'FontWeight','bold','FontSize',10,'color',colors{i});
    hold on
end

for i=3:3
    colors{i}='b';
    predictPeaks=ones((1+similarPeptides(i,5)+similarPeptides(i,6)),2);
    for j=1:size(predictPeaks,1)
        predictPeaks(j,1)=similarPeptides(i,4)+deltamass(j-1)/similarPeptides(i,3); %call deltamass.m 2010-09-03
                Max=0;
        for k=1:size(XData,1)
            if XData(k)>predictPeaks(j,1)-0.005 && XData(k)<predictPeaks(j,1)+0.005
                if YData(k)>Max
                    Max=YData(k);
                end
            end
        end
        predictPeaks(j,2)=Max;
    end
    stem(predictPeaks(:,1),predictPeaks(:,2),':','color',colors{i}, 'MarkerSize',6)
    text(522.25, max(YData)*(0.9-0.2*rem(i,5))*1.1, [num2str(similarPeptides(i,1)), '--', num2str(similarPeptides(i,2)),' +', num2str(similarPeptides(i,3))],'FontWeight','bold','FontSize',10,'color',colors{i});
    hold on
end

plot(XFitData1, YFitData1*max(YData)*0.9/max(YFitData1),'r','LineWidth',1)
hold on

plot(XFitData2, YFitData2*max(YData)*0.28/max(YFitData1),'b','LineWidth',1)
hold on

plot(XData,YData,'k','LineWidth',1)
hold on

xlabel('m/z')
ylabel('Intensity')
v=axis;
axis([v(1),v(2),0,max(YData)*1.1])
axis([522,526.25,0,max(YData)*1.05])

