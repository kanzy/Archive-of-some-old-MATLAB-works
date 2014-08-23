
figdata %call figdata.m

x=164;

START=peptidesPool(x,1);
END=peptidesPool(x,2);
CS=peptidesPool(x,3);
monoMZ=finalTable(x,4);
maxND=peptidesPool(x,5);
maxD=peptidesPool(x,6);
if flagND==0
    DM=1.00628;
    maxPlus=maxND+maxD;
    similarPeptides=wholeResults{x}.similarPeptidesD;
else
    DM=1.00336;
    maxPlus=maxND;
    similarPeptides=wholeResults{x}.similarPeptidesND;
end
endMZ=monoMZ+(maxPlus)/CS;

fitPara=finalTable(x,14:19);

if flagND==0
    XFitData=monoMZ:0.01:endMZ;
    YFitData=fitPara(1)*exp(-((XFitData-(fitPara(2)/CS+monoMZ))/fitPara(3)*CS).^2) + ...
        fitPara(4)*exp(-((XFitData-(fitPara(5)/CS+monoMZ))/fitPara(6)*CS).^2);
else
    XFitData=monoMZ:DM/CS:monoMZ+maxPlus*DM/CS;
    YFitData=fitPara(4)*wholeResults{x}.distND;
end

figure

% for i=1:(1+maxPlus)
%         stem(monoMZ+DM*(i-1)/CS,max(YData)*0.5,':','r', 'MarkerSize',5)
%         hold on
% end
% text(monoMZ+DM*maxPlus/CS+0.1, max(YData)*0.5, [num2str(START), '--', num2str(END),' +', num2str(CS)],'color','r','FontWeight','bold','FontSize',8);



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
ylabel('Intensity')
v=axis;
axis([v(1),v(2),0,max(YData)*1.1])
axis([993.75,1000.75,0,max(YData)*1.1])
















