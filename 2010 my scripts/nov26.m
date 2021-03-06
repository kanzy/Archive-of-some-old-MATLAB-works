

figure

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(5,1,1)
clear
disp('Import data for subplot 1 ...')
uiimport
void=input('Press "Enter" to continue...');

colors=cell(size(similarPeptides,1),1);
for i=1:size(similarPeptides,1)
    if i==1
        colors{i}='r';
    else
        colors{i}=[0 0.25*rem(i,5) 1-0.3*rem(i,4)];  %RGB color selection
    end
end
for i=1:size(similarPeptides,1)
    predictPeaks=ones((1+similarPeptides(i,5)),2);
    for j=1:size(predictPeaks,1)
        predictPeaks(j,1)=similarPeptides(i,4)+deltamass(j-1)/similarPeptides(i,3); %call deltamass.m 2010-09-03
    end
    stem(predictPeaks(:,1),predictPeaks(:,2)*max(YData)*(0.9-0.2*rem(i,5)),':','color',colors{i}, 'MarkerSize',5)
    text(predictPeaks(end,1)+0.1, max(YData)*(0.9-0.2*rem(i,5)), [num2str(similarPeptides(i,1)), '--', num2str(similarPeptides(i,2)),' +', num2str(similarPeptides(i,3))],'FontWeight','bold','FontSize',8,'color',colors{i});
    hold on
end

plot(XFitData, YFitData*max(YData)*1/max(YFitData),'m','LineWidth',1)
hold on

plot(XData,YData,'k','LineWidth',1)
hold on

% xlabel('m/z')
% ylabel('Intensity')
v=axis;
axis([v(1),v(2),0,max(YData)*1.1])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(5,1,2)
clear
disp('Import data for subplot 2 ...')
uiimport
void=input('Press "Enter" to continue...');

colors=cell(size(similarPeptides,1),1);
for i=1:size(similarPeptides,1)
    if i==1
        colors{i}='r';
    else
        colors{i}=[0 0.25*rem(i,5) 1-0.3*rem(i,4)];  %RGB color selection
    end
end
for i=1:1%size(similarPeptides,1)
    predictPeaks=ones((1+similarPeptides(i,5)+similarPeptides(i,6)),2);
    for j=1:size(predictPeaks,1)
        predictPeaks(j,1)=similarPeptides(i,4)+deltamass(j-1)/similarPeptides(i,3); %call deltamass.m 2010-09-03
    end
    stem(predictPeaks(:,1),predictPeaks(:,2)*max(YData)*(0.9-0.2*rem(i,5)),':','color',colors{i}, 'MarkerSize',5)
    text(predictPeaks(end,1)+0.1, max(YData)*(0.9-0.2*rem(i,5)), [num2str(similarPeptides(i,1)), '--', num2str(similarPeptides(i,2)),' +', num2str(similarPeptides(i,3))],'FontWeight','bold','FontSize',8,'color',colors{i});
    hold on
end

plot(XFitData, YFitData*max(YData)*1/max(YFitData),'m','LineWidth',1)
hold on

plot(XData,YData,'k','LineWidth',1)
hold on

% xlabel('m/z')
% ylabel('Intensity')
v=axis;
axis([v(1),v(2),0,max(YData)*1.1])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(5,1,3)
clear
disp('Import data for subplot 3 ...')
uiimport
void=input('Press "Enter" to continue...');

colors=cell(size(similarPeptides,1),1);
for i=1:size(similarPeptides,1)
    if i==1
        colors{i}='r';
    else
        colors{i}=[0 0.25*rem(i,5) 1-0.3*rem(i,4)];  %RGB color selection
    end
end
for i=1:size(similarPeptides,1)
    predictPeaks=ones((1+similarPeptides(i,5)),2);
    for j=1:size(predictPeaks,1)
        predictPeaks(j,1)=similarPeptides(i,4)+deltamass(j-1)/similarPeptides(i,3); %call deltamass.m 2010-09-03
    end
    stem(predictPeaks(:,1),predictPeaks(:,2)*max(YData)*(0.9-0.2*rem(i,5)),':','color',colors{i}, 'MarkerSize',5)
    text(predictPeaks(end,1)+0.1, max(YData)*(0.9-0.2*rem(i,5)), [num2str(similarPeptides(i,1)), '--', num2str(similarPeptides(i,2)),' +', num2str(similarPeptides(i,3))],'FontWeight','bold','FontSize',8,'color',colors{i});
    hold on
end

plot(XFitData, YFitData*max(YData)*0.9/max(YFitData),'m','LineWidth',1)
hold on

plot(XData,YData,'k','LineWidth',1)
hold on

% xlabel('m/z')
ylabel('Intensity')
v=axis;
axis([v(1),v(2),0,max(YData)*1.1])
axis([522,526,0,max(YData)*1.05])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(5,1,4)
clear
disp('Import data for subplot 4 ...')
uiimport
void=input('Press "Enter" to continue...');

colors=cell(size(similarPeptides,1),1);
for i=1:size(similarPeptides,1)
    if i==1
        colors{i}='r';
    else
        colors{i}=[0 0.25*rem(i,5) 1-0.3*rem(i,4)];  %RGB color selection
    end
end
for i=1:size(similarPeptides,1)
    predictPeaks=ones((1+similarPeptides(i,5)),2);
    for j=1:size(predictPeaks,1)
        predictPeaks(j,1)=similarPeptides(i,4)+deltamass(j-1)/similarPeptides(i,3); %call deltamass.m 2010-09-03
    end
    stem(predictPeaks(:,1),predictPeaks(:,2)*max(YData)*(0.9-0.2*rem(i,5)),':','color',colors{i}, 'MarkerSize',5)
    text(predictPeaks(end,1)+0.1, max(YData)*(0.9-0.2*rem(i,5)), [num2str(similarPeptides(i,1)), '--', num2str(similarPeptides(i,2)),' +', num2str(similarPeptides(i,3))],'FontWeight','bold','FontSize',8,'color',colors{i});
    hold on
end

plot(XFitData, YFitData*max(YData)*0.95/max(YFitData),'m','LineWidth',1)
hold on

plot(XData,YData,'k','LineWidth',1)
hold on

% xlabel('m/z')
% ylabel('Intensity')
v=axis;
axis([v(1),v(2),0,max(YData)*1.1])
axis([940.75,947.75,0,max(YData)*1.05])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(5,1,5)
clear
disp('Import data for subplot 5 ...')
uiimport
void=input('Press "Enter" to continue...');

colors=cell(size(similarPeptides,1),1);
for i=1:size(similarPeptides,1)
    if i==1
        colors{i}='r';
    else
        colors{i}=[0 0.25*rem(i,5) 1-0.3*rem(i,4)];  %RGB color selection
    end
end
for i=1:1%size(similarPeptides,1)
    predictPeaks=ones((1+similarPeptides(i,5)),2);
    for j=1:size(predictPeaks,1)
        predictPeaks(j,1)=similarPeptides(i,4)+deltamass(j-1)/similarPeptides(i,3); %call deltamass.m 2010-09-03
    end
    stem(predictPeaks(:,1),predictPeaks(:,2)*max(YData)*(0.9-0.2*rem(i,5)),':','color',colors{i}, 'MarkerSize',5)
    text(predictPeaks(end,1)+0.1, max(YData)*(0.9-0.2*rem(i,5)), [num2str(similarPeptides(i,1)), '--', num2str(similarPeptides(i,2)),' +', num2str(similarPeptides(i,3))],'FontWeight','bold','FontSize',8,'color',colors{i});
    hold on
end

plot(XFitData, YFitData*max(YData)*0.9/max(YFitData),'m','LineWidth',1)
hold on

plot(XData,YData,'k','LineWidth',1)
hold on

xlabel('m/z')
% ylabel('Intensity')
v=axis;
axis([v(1),v(2),0,max(YData)*1.1])
axis([993.75,1000.75,0,max(YData)*1.05])





